import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_listview/page/edit.dart';

// ignore: unused_import
import './../models/task.dart';
import './../service/tasklist.dart';

class MyListPage extends StatefulWidget {
  const MyListPage({super.key});

  @override
  State<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends State<MyListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<Tasklist>().fetchTaskList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic Listview dengan provider"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: context.watch<Tasklist>().taskList.isNotEmpty ? ListView.builder(
                itemCount: context.watch<Tasklist>().taskList.length,
                itemBuilder: (context, index) {
                  // jika nanti di tap maka akan bisa
                  return 
                    Dismissible(
                      key: UniqueKey(),
                      onDismissed: (DismissDirection direction) {
                        log('$direction');
                      },
                      background: const ColoredBox(
                        color: Colors.blueAccent,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.edit, color: Colors.white),
                          ),
                        ),
                      ),
                      secondaryBackground: const ColoredBox(
                        color: Colors.red,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                      ),
                      confirmDismiss: (DismissDirection direction) async {
                        final bool? confirmed;
                        if(direction == DismissDirection.endToStart){
                            confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Are you sure you want to delete?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Yes'),
                                  )
                                ],
                              );
                            }
                          );                          
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditTaskPage(taskName: context.watch<Tasklist>().taskList[index].name)));
                          return false;
                        }
                        return confirmed;
                      },
                      child: ListTile(
                        title: Text(context.watch<Tasklist>().taskList[index].name),
                      ),
                    );
                },
              ) : const Center(child: Text('No data!')),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // context.read<Tasklist>().addTask();
                      Navigator.pushNamed(context, "/addTask");
                    },
                    child: const Text("Halaman Tambah"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
