import 'package:crud/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodStflPage extends ConsumerStatefulWidget {
  const RiverpodStflPage({super.key});

  @override
  _RiverpodStflPageState createState() => _RiverpodStflPageState();
}

class _RiverpodStflPageState extends ConsumerState<RiverpodStflPage> {
  @override
  void initState() {
    super.initState();
    final name = ref.read(nameProvider);
    print(name);
  }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(nameProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Riverpod"),
      ),
      body: Center(
        child: Text(name),
      ),
    );
  }
}
