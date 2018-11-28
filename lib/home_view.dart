import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef Widget WidgetBuilder();

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class NavigationView {
  final WidgetBuilder view;
  final TickerProvider vsync;
  final BottomNavigationBarItem navItem;
  final AnimationController animationController;
  CurvedAnimation _animation;

  NavigationView({Icon icon, Text title, Color color, WidgetBuilder child, TickerProvider ticker})
      : view = child,
        vsync = ticker,
        navItem = BottomNavigationBarItem(icon: icon, title: title, backgroundColor: color),
        animationController = AnimationController(duration: Duration(milliseconds: 100), vsync: ticker) {
    _animation = CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  FadeTransition transition(BuildContext context) {
    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(0.0, 0.1), // Slightly down.
            end: Offset.zero,
          ).animate(_animation),
          child: view()),
    );
  }
}

class HomeViewState extends State<HomeView> with TickerProviderStateMixin, WidgetsBindingObserver {
  var _currentIndex = 0;
  List<NavigationView> _navItems = [];
  PageStorageBucket _storageBucket = PageStorageBucket();

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];

    for (var n in _navItems) transitions.add(n.transition(context));

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _navItems = [
      NavigationView(
          icon: Icon(Icons.library_books),
          color: Colors.deepPurple,
          title: Text('Food Log'),
          child: () => Scaffold(body: Text('Food Log')),
          ticker: this),
      NavigationView(
          icon: Icon(Icons.history),
          color: Colors.blue,
          title: Text('History'),
          child: () => Text('History'),
          ticker: this),
      NavigationView(
          icon: Icon(Icons.search),
          color: Colors.blueGrey,
          title: Text('Foods'),
          child: () => Text('Foods'),
          ticker: this),
      NavigationView(
          icon: Icon(Icons.insert_chart),
          color: Colors.indigo,
          title: Text('Ranks'),
          child: () => Text('Ranks'),
          ticker: this),
      NavigationView(
          icon: Icon(Icons.settings),
          color: Colors.lightBlue,
          title: Text('Settings'),
          child: () => Text('Settings'),
          ticker: this)
    ];

    for (var n in _navItems) n.animationController.addListener(_rebuild);

    _navItems[_currentIndex].animationController.value = 1.0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final themeData = Theme.of(context);
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: themeData.canvasColor, systemNavigationBarColor: themeData.canvasColor));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: PageStorage(bucket: _storageBucket, child: _navItems[_currentIndex].view()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          setState(() {
            // _navItems[_currentIndex].animationController.reverse().then((n) {
            //   _navItems[_currentIndex].animationController.forward();
            // });
            _currentIndex = i;
          });
        },
        currentIndex: _currentIndex,
        items: _navItems.map((n) => n.navItem).toList(),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (var n in _navItems) n.animationController.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }
}
