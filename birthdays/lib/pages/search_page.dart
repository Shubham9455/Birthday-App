import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../models/profiles.dart';
import 'home_page.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key, required this.sperson}) : super(key: key);
  final List<Persons> sperson;

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
            
            "Search Results".text.xl5.bold.make(),
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
                          itemCount: sperson.length,
                          itemBuilder: ((context, index) {
                            Map<String, dynamic> map =
                                sperson[sperson.length - index - 1].toMap();
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