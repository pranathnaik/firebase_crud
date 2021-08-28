import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.cyan,
      ),
      home: FutureBuilder(
        // Initialize FlutterFire
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Container(child: Text('Error'));
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return MyApp();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        },
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String name, studentId, studyProgramId;
  late double gpa;

  getStudentName(name) {
    this.name = name;
  }

  getStudentId(studentId) {
    this.studentId = studentId;
  }

  getStudyProgramId(studyProgramId) {
    this.studyProgramId = studyProgramId;
  }

  getGpa(gpa) {
    this.gpa = double.parse(gpa);
  }

  insertData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudent").doc(name);
    Map<String, dynamic> students = {
      "studentName": name,
      "studentId": studentId,
      "studyProgramId": studyProgramId,
      "gpa": gpa
    };
    documentReference
        .set(students)
        .whenComplete(() => print("Student name created"));
  }

  readData() {
    return FirebaseFirestore.instance.collection("MyStudent").get().then(
      (QuerySnapshot datasnapshot) {
        datasnapshot.docs.forEach((element) {
          print(element['studentName']);
        });
      },
    );
  }

  updateData() {
    print("update");
  }

  deleteData() {
    print("delete");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crud app'),
      ),
      body: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: "Name",
              fillColor: Colors.white,
            ),
            onChanged: (String name) {
              getStudentName(name);
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Student Id",
              fillColor: Colors.white,
            ),
            onChanged: (String studentId) {
              getStudentId(studentId);
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Study Program id",
              fillColor: Colors.white,
            ),
            onChanged: (String studyPogramId) {
              getStudyProgramId(studyPogramId);
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "GPA",
              fillColor: Colors.white,
            ),
            onChanged: (String gpa) {
              getGpa(gpa);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                color: Colors.green,
                onPressed: () {
                  insertData();
                },
                child: Text("Insert"),
              ),
              RaisedButton(
                color: Colors.blue,
                onPressed: () {
                  readData();
                },
                child: Text("Read"),
              ),
              RaisedButton(
                color: Colors.yellow,
                onPressed: () {
                  updateData();
                },
                child: Text("Update"),
              ),
              RaisedButton(
                color: Colors.red,
                onPressed: () {
                  deleteData();
                },
                child: Text("Delete"),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.blueAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("student name"),
                Text("student id"),
                Text("program id"),
                Text("gpa"),
              ],
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("MyStudent")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(documentSnapshot['studentName']),
                            Text(documentSnapshot['studentId']),
                            Text(documentSnapshot['studyProgramId']),
                            Text(documentSnapshot['gpa'].toString()),
                          ],
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("error "),
                  );
                } else
                  return CircularProgressIndicator();
              })
        ],
      ),
    );
  }
}
