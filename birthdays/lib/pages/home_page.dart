// ignore_for_file: unrelated_type_equality_checks, depend_on_referenced_packages

import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:birthdays/models/profiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool addtapped = false;
  bool deletetapped = false;
  String dob = "";
  bool edittapped = false;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  int id = 0;
  final myController = TextEditingController();
  String name = "";
  List<Persons> person = [];

  @override
  void initState() {
    super.initState();
    var andro = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = const IOSInitializationSettings();
    var initsetting = InitializationSettings(android: andro, iOS: iOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initsetting,
    );
    getList();
    checkAndShowNotification();
  }

  Future<void> checkAndShowNotification() async {
    var currdate = DateTime.now();
    for (int i = 0; i < person.length; i++) {
      var Dob = DateTime.parse(person[i].dob);
      if ((Dob.month == currdate.month) && (Dob.day == currdate.day)) {
        debugPrint(currdate.toString() + '  ' + Dob.toString());
        _showNotification();
        print("yes");
      }
    }
  }

  //////////////////////////////////
  ///Important Functions
  ///
  ///
  //Create Data
  getMyDataBase() async {
    WidgetsFlutterBinding.ensureInitialized();
    Database database = await openDatabase(
        // await getDatabasesPath(),
        join(await getDatabasesPath(), 'database1.db'),
        onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE persons (id INTEGER PRIMARY KEY,name TEXT, dob TEXT)',
      );
    }, version: 1);
    return database;
  }

  //Delete Database
  Future<void> deleteDatabase() async {
    await databaseFactory
        .deleteDatabase(join(await getDatabasesPath(), 'database1.db'));
  }

  getList() async {
    person = await getPersonsList();
    setState(() {});
  }

  //Insert A Person
  Future<void> insertPerson(Persons person) async {
    final db = await getMyDataBase();
    await db.insert(
      'persons',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Get List Of Persons
  Future<List<Persons>> getPersonsList() async {
    final db = await getMyDataBase();
    final List<Map<String, dynamic>> maps = await db.query('persons');

    return List.generate(maps.length, (i) {
      return Persons(
        dob: maps[i]['dob'],
        name: maps[i]['name'],
        id: maps[i]['id'],
      );
    });
  }

  //Edit
  Future<void> updateperson(Persons person) async {
    final db = await getMyDataBase();
    await db.update(
      'persons',
      person.toMap(),
      where: 'id = ?',
      whereArgs: [person.id],
    );
  }

  //Delete
  Future<void> deleteperson(int id) async {
    final db = await getMyDataBase();
    await db.delete(
      'persons',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Show Notifications
  //
  Future _showNotification() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Birthday Alert!!',
      'Wish Your Friend 🎂🎂🥳🥳🎉🎉',
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: Colors.deepPurple,
        child: Column(
          children: [
            ///////////////////////
            ///Header Row
            ///
            Row(
              children: [
                const Text(
                  "Birthdays",
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Fascinate'),
                ).p24(),
                GestureDetector(
                  child: const Icon(
                    Icons.menu_book_sharp,
                    color: Colors.white,
                    size: 30,
                  ).px24(),
                )
              ],
            ),
            //////////////////////
            ///Button Row
            ///
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: const Icon(
                    CupertinoIcons.add_circled,
                    color: Colors.white,
                    size: 20,
                  ).px24().py12(),
                  onTap: () {
                    addtapped = addtapped ? false : true;
                    edittapped = false;
                    deletetapped = false;
                    setState(() {});
                  },
                ),
                InkWell(
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ).px24(),
                  onTap: () {
                    edittapped = edittapped ? false : true;
                    addtapped = false;
                    deletetapped = false;
                    setState(() {});
                  },
                ),
                InkWell(
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 20,
                  ).px24(),
                  onTap: () {
                    deletetapped = deletetapped ? false : true;
                    addtapped = false;
                    edittapped = false;
                    setState(() {});
                  },
                ),
              ],
            ),
            //////////////////////
            ///hidden Boxes
            /////////////////////
            ///For Delete
            ///
            Container(
              child: deletetapped
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              constraints:
                                  BoxConstraints(maxHeight: 20, maxWidth: 250),
                              icon: Icon(
                                CupertinoIcons.person,
                                size: 20,
                              ),
                              // alignLabelWithHint: true,
                              labelText: "Id",
                              hintText: "Enter Id",
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (id == "") {
                                  id = 0;
                                } else {
                                  id = int.parse(value);
                                }
                              });
                            },
                          ).px16().py8(),
                          GestureDetector(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: Colors.red,
                                height: 30,
                                width: 100,
                                child: const Center(
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ).p16(),
                            onTap: () async {
                              deleteperson(id);
                              await getList();
                            },
                          )
                        ],
                      ),
                    )
                  : Container(),
            ),
            //////////////////////////
            ///for Add
            ///
            Container(
              child: addtapped
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              icon: Icon(
                                CupertinoIcons.person,
                                size: 20,
                              ),
                              constraints:
                                  BoxConstraints(maxHeight: 20, maxWidth: 250),
                              // alignLabelWithHint: true,
                              labelText: "Name",
                              hintText: "Enter Name",
                            ),
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                          ).px16().py8(),
                          TextFormField(
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                            controller: myController,
                            onTap: () async {
                              DateTime? date = DateTime(1900);
                              FocusScope.of(context).requestFocus(FocusNode());
                              date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1980),
                                  lastDate: DateTime.now());
                              if (date != null) {
                                setState(() => {
                                      dob = date.toString(),
                                      myController.text = date.toString()
                                    });
                              }
                            },
                            decoration: const InputDecoration(
                              constraints:
                                  BoxConstraints(maxHeight: 20, maxWidth: 250),
                              border: OutlineInputBorder(),
                              icon: Icon(
                                CupertinoIcons.calendar,
                                size: 20,
                              ),
                              // alignLabelWithHint: true,
                              labelText: "Date Of Birth",
                              hintText: "Enter DOB",
                            ),
                          ).px16(),
                          GestureDetector(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: Colors.red,
                                height: 30,
                                width: 100,
                                child: const Center(
                                  child: Text(
                                    "ADD",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ).p16(),
                            onTap: () async {
                              insertPerson(Persons(
                                  dob: dob, name: name, id: person.length));
                              await getList();
                              checkAndShowNotification();
                            },
                          )
                        ],
                      ),
                    )
                  : Container(),
            ),
            ///////////////////////////////////
            ///For Edit
            ///
            Container(
              child: edittapped
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                            decoration: const InputDecoration(
                              constraints:
                                  BoxConstraints(maxHeight: 20, maxWidth: 250),
                              border: OutlineInputBorder(),
                              icon: Icon(
                                CupertinoIcons.person,
                                size: 20,
                              ),
                              // alignLabelWithHint: true,
                              labelText: "Id",
                              hintText: "Enter Id",
                            ),
                            onChanged: (value) {
                              setState(() {
                                id = int.parse(value);
                              });
                            },
                          ).px16().py8(),
                          TextFormField(
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                            decoration: const InputDecoration(
                              constraints:
                                  BoxConstraints(maxHeight: 20, maxWidth: 250),
                              border: OutlineInputBorder(),
                              icon: Icon(
                                CupertinoIcons.person,
                                size: 20,
                              ),
                              // alignLabelWithHint: true,
                              labelText: "Name",
                              hintText: "Enter Name",
                            ),
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                          ).px16().py8(),
                          TextFormField(
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                            controller: myController,
                            onTap: () async {
                              DateTime? date = DateTime(1900);
                              FocusScope.of(context).requestFocus(FocusNode());
                              date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1980),
                                  lastDate: DateTime.now());
                              if (date != null) {
                                setState(() => {
                                      dob = date.toString(),
                                      myController.text = date.toString()
                                    });
                              }
                            },
                            decoration: const InputDecoration(
                              constraints:
                                  BoxConstraints(maxHeight: 20, maxWidth: 250),
                              border: OutlineInputBorder(),
                              icon: Icon(
                                CupertinoIcons.calendar,
                                size: 20,
                              ),
                              // alignLabelWithHint: true,
                              labelText: "Date Of Birth",
                              hintText: "Enter DOB",
                            ),
                          ).px16(),
                          GestureDetector(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                color: Colors.red,
                                height: 30,
                                width: 100,
                                child: const Center(
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ).p16(),
                            onTap: () async {
                              updateperson(
                                  Persons(dob: dob, name: name, id: id));
                              await getList();
                              checkAndShowNotification();
                            },
                          )
                        ],
                      ),
                    )
                  : Container(),
            ),
            /////////////////////////////////
            /// List View To Show Data
            ///
            Expanded(
              child: VxArc(
                height: 15,
                edge: VxEdge.TOP,
                arcType: VxArcType.CONVEY,
                child: Container(
                  color: Colors.white,
                  height: 300,
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: person.length,
                          itemBuilder: ((context, index) {
                            Map<String, dynamic> map =
                                person[person.length - index - 1].toMap();
                            return PersonTile(
                              name: map['name'],
                              dob: map['dob'],
                              id: map['id'],
                            );
                          })),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

//////////////////////////////////////////
///person tile to show single data
///
class PersonTile extends StatefulWidget {
  PersonTile(
      {Key? key, required this.name, required this.dob, required this.id})
      : super(key: key);

  String dob;
  int id;
  String name;

  @override
  State<PersonTile> createState() => _PersonTileState();
}

class _PersonTileState extends State<PersonTile> {
  bool cardtapped = false;
  bool edittapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        cardtapped = cardtapped ? false : true;
        setState(() {});
      }),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              color: const Color.fromARGB(255, 255, 254, 253),
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widget.id.toString().text.bold.xl4.make(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 140, 140, 157),
                          ).px8(),
                          widget.name.text.xl4.red500.extraBold.make()
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: Color.fromARGB(255, 140, 140, 157),
                          ).px8(),
                          widget.dob.text.xl.purple600.semiBold.make(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ).px24().py8(),
    );
  }
}
