import 'package:crud/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StateProviderPage extends ConsumerWidget {
  const StateProviderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    ref.listen(
      counterProvider,
      (previous, next) {
        if (next == 5) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('the value is $next')));
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("State Provide"),
        actions: [
          IconButton(
              onPressed: () {
                // ref.invalidate(counterProvider);
                ref.refresh(counterProvider);
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Center(
        child: Text(
          count.toString(),
          style: const TextStyle(fontSize: 30),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ref.read(counterProvider.notifier).state++;
          ref.read(counterProvider.notifier).update(
                (state) => state + 1,
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
