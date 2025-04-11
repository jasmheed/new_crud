import 'dart:convert';

import 'package:crud/common/constants/color_const.dart';
import 'package:crud/common/constants/icon_const.dart';

import 'package:crud/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ApiTask extends StatefulWidget {
  const ApiTask({super.key});

  @override
  State<ApiTask> createState() => _ApiTaskState();
}

class _ApiTaskState extends State<ApiTask> {
  List details = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  getData() async {
    Uri? uri = Uri.tryParse(
        'https://api-vmu6fsmmna-uc.a.run.app/api/users/display_allUsers');
    http.Response data = await http.get(uri!);
    var apiResponse = data.body;
    List apiData = jsonDecode(apiResponse);
    details = apiData;
    setState(() {});
  }

// Add New Detail to API
  addData(String name, String age, String phone) async {
    Uri? uri = Uri.tryParse(
        'https://api-vmu6fsmmna-uc.a.run.app/api/users/create_user'); // Replace with your POST endpoint

    final body = {
      "name": name,
      "age": int.parse(age),
      "phone": phone,
    };

    print("Sending Data: $body"); // Debug what is being sent to the API

    final response = await http.post(
      uri!,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Data added successfully: ${response.body}");
      getData(); // Refresh the data after adding a new user
    } else {
      print("Failed to add data: ${response.statusCode}, ${response.body}");
    }
  }

  updateData(String id, String name, String age, String phone) async {
    Uri? uri = Uri.tryParse(
        'https://api-vmu6fsmmna-uc.a.run.app/api/users/update_user/$id'); // Replace with your PUT endpoint

    final body = {
      "name": name,
      "age": int.parse(age),
      "phone": phone,
    };

    print("Updating Data: $body"); // Debug the data being sent

    final response = await http.put(
      uri!,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Data updated successfully");
      getData(); // Refresh the list after updating
    } else {
      print("Failed to update data: ${response.statusCode}, ${response.body}");
    }
  }

  deleteData(String id) async {
    Uri? uri = Uri.tryParse(
        'https://api-vmu6fsmmna-uc.a.run.app/api/users/delete_user/$id'); // Replace with your DELETE endpoint

    print("Deleting user with ID: $id"); // Debug log

    final response = await http.delete(
      uri!,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": id}),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("User deleted successfully");
      getData(); // Refresh the list after deletion
    } else {
      print("Failed to delete user: ${response.statusCode}, ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.secondryColor,
      appBar: AppBar(
        backgroundColor: ColorConst.secondryColor,
        title: const Text(
          "API",
          style: TextStyle(
            color: ColorConst.triColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            details.isEmpty
                ? Container(
                    height: height * 0.1,
                    width: width,
                  )
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: details.length,
                      itemBuilder: (context, index) {
                        String id = details[index]['id'].toString();
                        String phone = details[index]['phone'].toString();
                        String age = details[index]['age'].toString();
                        String name = details[index]['name'].toString();
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Text('age:$age'),
                              title: Text('name:$name'),
                              subtitle: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('phone:$phone'),
                                  Text('id:$id'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _showEditDialog(id, name, age, phone);
                                    },
                                    child: SvgPicture.asset(
                                      IconConst.editIcon,
                                      height: height * 0.03,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.05,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                                "Delete Confirmation"),
                                            content: const Text(
                                                "Are you sure you want to delete this user?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context), // Close the dialog
                                                child: const Text("Cancel"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context); // Close the dialog
                                                  deleteData(
                                                      id); // Call deleteData to remove the user
                                                },
                                                child: const Text("Delete"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: SvgPicture.asset(
                                          IconConst.deleteRedIcon)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    getData();
                  },
                  child: Text(
                    "GET",
                    style: GoogleFonts.montserrat(
                      color: ColorConst.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                FloatingActionButton(
                    onPressed: () {
                      _showAddDialog();
                    },
                    child: Icon(Icons.add)),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Detail"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Get the input values
                String name = nameController.text.trim();
                String age = ageController.text.trim();
                String phone = phoneController.text.trim();

                // Validate input values
                if (name.isEmpty || age.isEmpty || phone.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("All fields are required!"),
                    ),
                  );
                  return; // Do not proceed if validation fails
                }

                // Call the addData method and clear the fields
                addData(name, age, phone);
                Navigator.pop(context); // Close the dialog
                nameController.clear();
                ageController.clear();
                phoneController.clear();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(
      String id, String currentName, String currentAge, String currentPhone) {
    // Set initial values in the text controllers
    nameController.text = currentName;
    ageController.text = currentAge;
    phoneController.text = currentPhone;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Detail"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text.trim();
                String age = ageController.text.trim();
                String phone = phoneController.text.trim();

                if (name.isNotEmpty && age.isNotEmpty && phone.isNotEmpty) {
                  updateData(id, name, age, phone); // Call the PUT method
                  Navigator.pop(context); // Close the dialog
                  nameController.clear();
                  ageController.clear();
                  phoneController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("All fields are required!"),
                    ),
                  );
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
