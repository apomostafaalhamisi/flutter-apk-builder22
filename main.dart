import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'حاسبة',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double _num1 = 0;
  double _num2 = 0;
  String _operator = '';
  bool _newInput = false;

  void _onButton(String val) {
    setState(() {
      if (val == 'C') {
        _display = '0';
        _expression = '';
        _num1 = 0;
        _num2 = 0;
        _operator = '';
        _newInput = false;
      } else if (val == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
        }
      } else if (val == '+/-') {
        if (_display != '0') {
          _display = _display.startsWith('-')
              ? _display.substring(1)
              : '-$_display';
        }
      } else if (val == '%') {
        double v = double.tryParse(_display) ?? 0;
        _display = _fmt(v / 100);
      } else if (['+', '-', '×', '÷'].contains(val)) {
        _num1 = double.tryParse(_display) ?? 0;
        _operator = val;
        _expression = '$_display $val';
        _newInput = true;
      } else if (val == '=') {
        if (_operator.isEmpty) return;
        _num2 = double.tryParse(_display) ?? 0;
        double result = 0;
        switch (_operator) {
          case '+': result = _num1 + _num2; break;
          case '-': result = _num1 - _num2; break;
          case '×': result = _num1 * _num2; break;
          case '÷': result = _num2 != 0 ? _num1 / _num2 : 0; break;
        }
        _expression = '$_expression $_display =';
        _display = _fmt(result);
        _operator = '';
        _newInput = true;
      } else if (val == '.') {
        if (_newInput) { _display = '0.'; _newInput = false; return; }
        if (!_display.contains('.')) _display += '.';
      } else {
        if (_newInput || _display == '0') {
          _display = val;
          _newInput = false;
        } else {
          if (_display.length < 12) _display += val;
        }
      }
    });
  }

  String _fmt(double v) {
    if (v == v.truncateToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  Widget _btn(String label, {Color? bg, Color? fg}) {
    return GestureDetector(
      onTap: () => _onButton(label),
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: bg ?? const Color(0xFF16213E),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(2,4))],
        ),
        child: Center(
          child: Text(label,
            style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w600,
              color: fg ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orange = const Color(0xFFFF6B35);
    final gray   = const Color(0xFF2D2D44);

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // Display
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(_expression,
                    style: const TextStyle(fontSize: 16, color: Colors.white38),
                    textAlign: TextAlign.end,
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(_display,
                      style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w300, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Buttons
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(children: [
                Expanded(child: Row(children: [
                  Expanded(child: _btn('C',   bg: gray, fg: orange)),
                  Expanded(child: _btn('+/-', bg: gray, fg: Colors.white70)),
                  Expanded(child: _btn('%',   bg: gray, fg: Colors.white70)),
                  Expanded(child: _btn('÷',   bg: orange)),
                ])),
                Expanded(child: Row(children: [
                  Expanded(child: _btn('7')),
                  Expanded(child: _btn('8')),
                  Expanded(child: _btn('9')),
                  Expanded(child: _btn('×', bg: orange)),
                ])),
                Expanded(child: Row(children: [
                  Expanded(child: _btn('4')),
                  Expanded(child: _btn('5')),
                  Expanded(child: _btn('6')),
                  Expanded(child: _btn('-', bg: orange)),
                ])),
                Expanded(child: Row(children: [
                  Expanded(child: _btn('1')),
                  Expanded(child: _btn('2')),
                  Expanded(child: _btn('3')),
                  Expanded(child: _btn('+', bg: orange)),
                ])),
                Expanded(child: Row(children: [
                  Expanded(child: _btn('⌫', bg: gray, fg: Colors.white70)),
                  Expanded(child: _btn('0')),
                  Expanded(child: _btn('.')),
                  Expanded(child: _btn('=', bg: orange)),
                ])),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
