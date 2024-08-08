import 'package:flutter/material.dart';
import 'package:parkeasy/core/constant/constants.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: bluecolor,
      body: CircularProgressIndicator(
        color: white,
      ),
    ));
  }
}
