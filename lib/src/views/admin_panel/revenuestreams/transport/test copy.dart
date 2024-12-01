import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  final String testVar;
  const TestPage({super.key, required this.testVar});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text(widget.testVar)));
  }
}
