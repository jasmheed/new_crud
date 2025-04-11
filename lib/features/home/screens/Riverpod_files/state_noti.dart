import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/features/home/screens/Riverpod_files/counter_demo.dart';
import 'package:crud/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StateNotiPage extends ConsumerWidget {
  const StateNotiPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(countProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("State Provide"),
      ),
      body: Center(
        child: Text(
          '$counter',
          style: const TextStyle(fontSize: 30),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(countProvider.notifier).increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
