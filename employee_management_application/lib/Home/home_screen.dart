import 'dart:developer';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List employeesList = ['A', 'B', 'C', 'D', 'F'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EMP'), centerTitle: true ,leading: Icon(Icons.menu,size: 30,)),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                spacing: 30,
                children: [
                  Icon(Icons.person, size: 30),
                  Text(employeesList[index], style: TextStyle(fontSize: 20)),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Center(child: DialogExample());
                      log('Are you sure want to delete');
                      setState(() {
                        
                      });
                    },
                    child: Icon(Icons.delete_outline))
                ],
              ),
            ),
          );
        },
        itemCount: employeesList.length,
      ),
    );
  }
}

class DialogExample extends StatelessWidget {
  const DialogExample({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
      
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const Text('AlertDialog description'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: const Text('Show Dialog'),
    );
  }
}