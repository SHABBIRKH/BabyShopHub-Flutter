import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:babyshophub/firebase_options.dart';
import 'drawer.dart';
Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyCategoryApp());
}

// void main() => runApp(MyCategoryApp());

class MyCategoryApp extends StatelessWidget {
  const MyCategoryApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyCategory(),
    );
  }
}

class MyCategory extends StatefulWidget {
  const MyCategory({super.key});

  @override
  State<MyCategory> createState() => _MyCategoryState();
}

class _MyCategoryState extends State<MyCategory> {
  final db = FirebaseFirestore.instance;
  final TextEditingController _categoryController = TextEditingController();
  String?documentIdToUpdate ;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MyCategory'),
        ),
        // drawer: sidebar(userName: userName),
        body:Container(
          child: Column(
            children: [
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  label: Text('categoryname'),
                ),
              ),
              ElevatedButton(onPressed: () async {
                try {
                    if(documentIdToUpdate == null){

                await db.collection('categories').add({
                  'categoryname' : _categoryController.text,
                });
                setState(() {
                  _categoryController.clear();
                });
        ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('category added'),backgroundColor: Colors.green,),
                                      );
                }
                else{
                        await db.collection('categories').doc(documentIdToUpdate).update({
                          'categoryname':_categoryController.text
                        });
                      }
                }
                catch(err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $err')));
                }
              }, child: Text('Add')),
              Expanded(
                child: StreamBuilder(
                  stream: db.collection('categories').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, int index) {
                          DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                          return ListTile(
                            title: Text(documentSnapshot['categoryname'] ?? 'No Name'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                   _categoryController.text = documentSnapshot['categoryname'];

                                  documentIdToUpdate = documentSnapshot.id;
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () async{
                                    try{
                                      await db.collection('categories').doc(documentSnapshot.id).delete();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('category deleted'),backgroundColor: Colors.red,),
                                      );
                                    }
                                      catch (e){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("error:$e")),
                                        );
                                      }
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}