import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterPage extends StatefulWidget {
  final Function(bool) onThemeChanged; // Theme toggle callback
  const CounterPage({super.key, required this.onThemeChanged});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadCounter(); // Load saved counter
    _loadTheme();   // Load saved theme
  }

  /// Load saved counter value from SharedPreferences
  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
    });
  }

  /// Save counter value
  Future<void> _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', _counter);
  }

  /// Load saved theme
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      widget.onThemeChanged(_isDarkMode);
    });
  }

  /// Save theme
  Future<void> _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _saveCounter();
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) _counter--;
    });
    _saveCounter();
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
    _saveCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Counter"),
        centerTitle: true,
        actions: [
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              widget.onThemeChanged(value);
              _saveTheme(value);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your Counter Value:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 40),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _decrementCounter,
                    icon: const Icon(Icons.remove),
                    label: const Text("Decrease"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: _resetCounter,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reset"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: _incrementCounter,
                    icon: const Icon(Icons.add),
                    label: const Text("Increase"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
