import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final primaryColorLight = const Color(0xFFD8E0ED);
  final primaryColorDark = const Color(0xFF2E3243);
  final morningColors = [Color(0xFFFFCC81), Color(0xFFFF6E30)];
  final nightColors = [Color(0xFF2E3243), Color(0xFF121212)];

  var isPressed = false;
  var isDark = false;
  late AnimationController _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget dayNightIcon() {
    return Icon(
      isDark ? Icons.nightlight_round : Icons.wb_sunny,
      size: 80,
      color: isDark ? Colors.yellow[600] : Colors.orange[300],
    );
  }

  Widget dayNight() {
    final positionShadow = isDark ? -40.0 : -210.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 210,
          height: 210,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: isDark ? nightColors : morningColors,
            ),
          ),
        ),
        dayNightIcon(),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 500),
          curve: Curves.bounceOut,
          top: positionShadow,
          right: positionShadow,
          child: Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? primaryColorDark : primaryColorLight,
            ),
          ),
        ),
      ],
    );
  }

  Widget centerText() {
    return Text(
      isDark ? 'Good\nNight' : 'Good\nMorning',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 44,
        fontWeight: FontWeight.bold,
        color: isDark ? primaryColorLight : primaryColorDark,
      ),
    );
  }

  Widget powerButton() {
    return Listener(
      onPointerDown: (_) => setState(() {
        isPressed = true;
      }),
      onPointerUp: (_) => setState(() {
        isPressed = false;
        isDark = !isDark;
        isDark ? _controller.forward() : _controller.reverse();

        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          ),
        );
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? primaryColorDark : primaryColorLight,
          boxShadow: [
            BoxShadow(
              offset: const Offset(-5, 5),
              blurRadius: 10,
              color: isDark ? const Color(0xFF121625) : const Color(0xFFA5B7D6),
            ),
            BoxShadow(
              offset: const Offset(5, -5),
              blurRadius: 10,
              color: isDark ? const Color(0x4D9DA7CF) : Colors.white70,
            ),
          ],
        ),
        child: Icon(
          Icons.power_settings_new,
          size: 48,
          color: isDark ? primaryColorLight : primaryColorDark,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation ?? _controller, // fallback to _controller
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark ? nightColors : morningColors,
              ),
            ),
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dayNight(),
              const SizedBox(height: 36),
              centerText(),
              const SizedBox(height: 120),
              powerButton(),
            ],
          ),
        ),
      ),
    );
  }
}
