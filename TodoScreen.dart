

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  // ignore: deprecated_member_use
  List tasks = List();
  String taskName;
  String dec;

  void createTask() {
    DocumentReference Docs =
        Firestore.instance.collection("myTasks").document(taskName);

    Map<String, String> tasks = {"taskTitle": taskName};

    Docs.setData(tasks).whenComplete(() => print("$taskName created"));
  }

  void deleteTask(item)
  {
    DocumentReference Docs =
    Firestore.instance.collection("myTasks").document(item);
   Docs.delete().whenComplete(() => print("deleted"));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Do-List'),
        centerTitle: true,
      ),
      body:StreamBuilder(
        //everytask replace with snapshot
        stream: Firestore.instance.collection("myTasks").snapshots(),
          builder:(context,snapshots){
            if(snapshots.data == null) return Center(child: CircularProgressIndicator());

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
              child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshots.data.documents.length,
              itemBuilder: (context,index) {
                DocumentSnapshot docsShot=snapshots.data.documents[index];
                return Dismissible(

                  key: Key(index.toString()),
                  child: Card(
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    child: ListTile(

                      title: Text(
                        docsShot.data["taskTitle"],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  actions: [
                                    Row(
                                      children: [
                                        TextButton(
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              deleteTask(docsShot["taskTitle"]);
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(color: Colors.blue),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                  title: Text('Delete Task?'),
                                );
                              });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                );
              },
          ),
            );
      }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(

                  title: Text('Add a New Task',style: TextStyle(
                    fontWeight: FontWeight.w500,color: Colors.yellow,fontSize: 22
                  ),textAlign: TextAlign.center,
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              createTask();
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Add Task',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ))
                      ],
                    )
                  ],
                  content: Container(
                    height: 200,

                    child: Column(
                      children: [
                        SizedBox(height: 30,),
                        TextField(
                          onChanged: (value) {
                            taskName = value;
                          },
                          decoration: InputDecoration(hintText: 'Enter Task',border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                          ),labelText: 'Enter Task'
                          ),
                        ),
                        SizedBox(height: 30,),
                        TextField(
                          onChanged: (value) {
                            dec = value;
                          },
                          decoration: InputDecoration(hintText: 'Add Description',border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)
                          ),labelText: 'Add Description'),
                        ),
                      ],
                    ),
                  )
                );
              });
        },
      ),
    );
  }
}
