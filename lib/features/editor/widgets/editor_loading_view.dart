import 'package:flutter/material.dart';

class EditorLoadingView extends StatelessWidget {
  const EditorLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading Resume...'), elevation: 0),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
