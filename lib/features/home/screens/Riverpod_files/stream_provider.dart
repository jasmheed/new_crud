import 'package:crud/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreamProviderPage extends ConsumerWidget {
  const StreamProviderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamData = ref.watch(streamProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Stream Provider"),
      ),
      body: streamData.when(
        data: (data) => Center(
          child: Text(
            data.toString(),
            style: const TextStyle(fontSize: 25),
          ),
        ),
        error: ((error, stackTrace) => Text(error.toString())),
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
