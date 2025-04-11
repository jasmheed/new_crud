import 'package:crud/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodApi extends ConsumerWidget {
  const RiverpodApi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("User Data"),
      ),
      body: userData.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title:
                    Text("${data[index].firstname} ${data[index].lastname} "),
                subtitle: Text(data[index].email),
                leading: CircleAvatar(
                  child: Image.network(data[index].avatar),
                ),
              );
            },
          );
        },
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
