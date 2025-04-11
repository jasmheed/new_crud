import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/common/constants/firebase_const.dart';
import 'package:crud/features/home/screens/usermodel.dart';
import 'package:flutter/material.dart';

class UserSingle extends StatefulWidget {
  // final String name;
  // final String id;
  const UserSingle({
    super.key,
    /*required this.id*/
  });

  @override
  State<UserSingle> createState() => _UserSingleState();
}

class _UserSingleState extends State<UserSingle> {
  var queryData;

  UserModel? user;

  QuerySnapshot? listenDataSnap;

  getData() async {
    QuerySnapshot query =
        await FirebaseFirestore.instance.collection(FirebaseConst.users).get();
    print(query.docs);

    queryData = query.docs;

    // DocumentSnapshot doc = await FirebaseFirestore.instance
    //     .collection(FirebaseConst.users)
    //     .doc(widget.id)
    //     .get();

    // user = UserModel.fromMap(doc.data() as Map<String, dynamic>);

    setState(() {});
  }

  listenData() {
    FirebaseFirestore.instance
        .collection(FirebaseConst.users)
        .snapshots()
        .listen(
      (event) {
        listenDataSnap = event;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(queryData.toString()),
          listenDataSnap == null
              ? Container()
              : Column(
                  children: List.generate(
                  listenDataSnap!.docs.length,
                  (index) => Text(listenDataSnap!.docs[index]['name']),
                )),

          user == null ? Text("") : Text(user!.name.toString()),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  listenData();
                  getData();
                },
                child: Text("GET")),
          ),
        ],
      ),
    );
  }
}
