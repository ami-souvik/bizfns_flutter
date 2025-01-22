import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("Bad Request",style: TextStyle(fontSize: 16,color: Colors.black),),
        ),
      ),
    );
  }
}
