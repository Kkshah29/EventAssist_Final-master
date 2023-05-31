// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing/UI/events/event_details.dart';
import 'package:testing/UI/events/viewparticipant.dart';

import '../../main.dart';
import '../login_page.dart';


class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  final double  _drawerIconSize = 24;
  final double _drawerFontSize = 17;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? currentuserclub;
  
  void _handleSignOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("Logout Successfully"))));
    });
  }

  Future<void> fetchData() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Admin_user') // Replace with your collection name
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      
      // Iterate through the documents and retrieve data
      for (DocumentSnapshot document in querySnapshot.docs) {
        final dt=document.data() as Map<String,dynamic>;
        currentuserclub=dt['Club'];
      }
      
    } else {
      // No documents found
      const CircularProgressIndicator();
    }
  } catch (e) {
    // Handle error
    print(e);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('My Events'),centerTitle: true),
        drawer: Drawer(
          child: Container(
            decoration:BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0.0, 1.0],
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.2),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                    ]
                )
            ) ,
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.0, 1.0],
                      colors: [ Theme.of(context).primaryColor,Theme.of(context).colorScheme.secondary,],
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    child: const Text("Nav Bar",
                      style: TextStyle(fontSize: 25,color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),


                 Divider(color: Theme.of(context).primaryColor, height: 1,),

                ListTile(
                  leading: Icon(Icons.event, size: _drawerIconSize,color: Theme.of(context).colorScheme.secondary,),
                  title: Text('Event Calender',style: TextStyle(fontSize: _drawerFontSize,color: Theme.of(context).colorScheme.secondary),),
                  onTap: () {
                    Navigator.push( context, MaterialPageRoute(builder: (context) => const MyApp()));
                  },
                ),

                Divider(color: Theme.of(context).primaryColor, height: 1,),

                ListTile(
                  leading: Icon(Icons.event, size: _drawerIconSize,color: Theme.of(context).colorScheme.secondary,),
                  title: Text('My Events',style: TextStyle(fontSize: _drawerFontSize,color: Theme.of(context).colorScheme.secondary),),
                  onTap: () {
                    Navigator.push( context, MaterialPageRoute(builder: (context) => const MyEvents()));
                  },
                ),

               

                Divider(color: Theme.of(context).primaryColor, height: 1,),
                ListTile(
                  leading: Icon(Icons.logout_rounded, size: _drawerIconSize,color: Theme.of(context).colorScheme.secondary,),
                  title: Text('Logout',style: TextStyle(fontSize: _drawerFontSize,color: Theme.of(context).colorScheme.secondary),),
                  onTap: () {
                     _handleSignOut(context);
                  },
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Events').where('club',isEqualTo: currentuserclub).snapshots(),
          builder: (context,  snapshot) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder:(context,index) {
            return Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                //color: Colors.grey[200],
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*InkWell(
                      onTap: () {
                        //Get.back();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 50, bottom: 20),
                        width: 30,
                        height: 30,
                        child: Image.asset(
                          'assets/images/ebg.jpeg',
                        ),
                      ),
                    ),*/
                    InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => EventDetails(eventname: snapshot.data?.docs[index]['event_name'],)));
                          },
                          child: Container(
                            height: 190,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: const DecorationImage(
                                image: AssetImage('assets/images/ebg.jpeg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          "${snapshot.data?.docs[index]['event_name']}",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: ElevatedButton(onPressed:(){
                          Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ViewParticipant(eventName: snapshot.data?.docs[index]['event_name'],)),
                                        );
                          }, child: Text(
                            "View participants",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ), 
                          ),
                        ),
                      ]
                  ),
                ),
              ),
            );
              }
            );
          }
        )
        );
  }
}