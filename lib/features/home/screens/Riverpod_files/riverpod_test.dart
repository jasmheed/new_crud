import 'package:crud/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodTest extends ConsumerWidget {
  const RiverpodTest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final name = ref.watch(nameProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Riverpod Provider"),
      ),
      // body: Center(child: Text(name)),
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final name = ref.watch(nameProvider);
            return Text(name);
          },
        ),
      ),
    );
  }
}
