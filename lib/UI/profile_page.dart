
// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing/UI/events/show_events.dart';
import 'package:testing/UI/widgets/header_widget.dart';

import 'events/myevent1.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget{
  final String email_add;
  const ProfilePage({super.key,required this.email_add});


  @override
  State<StatefulWidget> createState() {
     return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>{
  final double  _drawerIconSize = 24;
  final double _drawerFontSize = 17;
  final FirebaseAuth _auth = FirebaseAuth.instance;

   void _handleSignOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("Logout Successfully"))));
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
        title: const Text("Profile Page",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0.5,
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace:Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary,]
                )
            ),
          ),
        ),
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
                  title: Text('My Events',style: TextStyle(fontSize: _drawerFontSize,color: Theme.of(context).colorScheme.secondary),),
                  onTap: () {
                    Navigator.push( context, MaterialPageRoute(builder: (context) => const MyEvents1()));
                  },
                ),
                
                Divider(color: Theme.of(context).primaryColor, height: 1,),

                ListTile(
                  leading: Icon(Icons.event, size: _drawerIconSize,color: Theme.of(context).colorScheme.secondary,),
                  title: Text('Events',style: TextStyle(fontSize: _drawerFontSize,color: Theme.of(context).colorScheme.secondary),),
                  onTap: () {
                    Navigator.push( context, MaterialPageRoute(builder: (context) => ShowEvents()));
                  },
                ),

                Divider(color: Theme.of(context).primaryColor, height: 1,),

                ListTile(
                  leading: Icon(Icons.verified_user_sharp, size: _drawerIconSize,color: Theme.of(context).colorScheme.secondary,),
                  title: Text('Profile',style: TextStyle(fontSize: _drawerFontSize,color: Theme.of(context).colorScheme.secondary),),
                  onTap: () {
                    Navigator.push( context, MaterialPageRoute(builder: (context) => ProfilePage(email_add: FirebaseAuth.instance.currentUser!.email.toString())));
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
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(widget.email_add).snapshots(),
          builder: (BuildContext context,snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return Text('Loading...');
            }
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Container(height: 100, child: const HeaderWidget(100,false,Icons.house_rounded),),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 5, color: Colors.white),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(5, 5),),
                            ],
                          ),
                          child: Icon(Icons.person, size: 80, color: Colors.grey.shade300,),
                        ),
                        const SizedBox(height: 20,),
                        Text("${snapshot.data!['name']}",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                                alignment: Alignment.topLeft,
                                child: const Text(
                                  "User Information",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Card(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          ...ListTile.divideTiles(
                                            color: Colors.grey,
                                            tiles: [
                                              ListTile(
                                                leading: Icon(Icons.email),
                                                title: Text("Email"),
                                                subtitle: Text("${snapshot.data!['email']}"),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.phone),
                                                title: Text("Phone"),
                                                subtitle: Text("${snapshot.data!['Mobile Number']}"),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.book),
                                                title: Text("Roll number"),
                                                subtitle: Text("${snapshot.data!['Roll number']}"),
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.school),
                                                title: Text("College"),
                                                subtitle: Text("${snapshot.data!['College']}"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }

}