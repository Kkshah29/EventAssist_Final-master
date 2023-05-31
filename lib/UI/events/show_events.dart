// ignore_for_file: unused_import, sort_child_properties_last, prefer_const_constructors, use_build_context_synchronously, unrelated_type_equality_checks, deprecated_member_use

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:testing/UI/events/add_events.dart";
import "package:testing/UI/events/event_details.dart";
import "package:testing/UI/events/myevent1.dart";
import "package:testing/UI/events/myevents.dart";
import 'package:url_launcher/url_launcher.dart';

import "../../common/theme_helper.dart";
import "../login_page.dart";
import "../profile_page.dart";

class ShowEvents extends StatefulWidget {
const ShowEvents({Key? key}) : super(key: key);

@override
State<ShowEvents> createState() => _ShowEventsState();
}

class _ShowEventsState extends State<ShowEvents> {
  final double  _drawerIconSize = 24;
  final double _drawerFontSize = 17;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool? valueExists;
  int ind=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    availability();
    //updateArrayObjectAtSpecificIndex();
  }
  void _handleSignOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("Logout Successfully"))));
    });
  }


/* void compareOuterKeysFromList() async {
  // Get a reference to the Firestore collection
  CollectionReference collection = FirebaseFirestore.instance.collection('Events');

  // Retrieve the documents from Firestore
  QuerySnapshot querySnapshot = await collection.get();

  // Iterate over the documents
  for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
    // Get the data from the document
    Map<String, dynamic> data = documentSnapshot.data() as Map<String,dynamic>;

    // Get the value of the outer key
    int outerKeyValue = data['participants'].length;
    if(outerKeyValue>0)
    {
      for(int i=0;i<outerKeyValue;i++)
    {
      if(data['participants'][i]['email']==FirebaseAuth.instance.currentUser!.email)
      {
       // int index=i;
        FirebaseFirestore.instance.collection('Events').doc('${documentSnapshot.id}').update(
          {
            'participants':[
              {
                'email':"${FirebaseAuth.instance.currentUser?.email}",
                'Attendance':'present'
              }
            ]
          },
        );
      }
    }
    }

  

    
    // Compare the outer key value to a specific value
    /* if (outerKeyValue == 'kunal123@somaiya.edu') {
      print('The outer key value matches the desired value for document ${documentSnapshot.id}');
    } else {
      print('The outer key value does not match the desired value for document ${documentSnapshot.id}');
    } */
  }
}
 */
void availability() async
{
  CollectionReference collection = FirebaseFirestore.instance.collection('Events');
  QuerySnapshot querySnapshot = await collection.get();
  for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs)
  {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    int outerKeyValue = data['participants'].length;
    //int index=0;
    if(outerKeyValue>0)
    {
      for(int i=0;i<outerKeyValue;i++)
      {
        if(data['participants'][i]['email']==FirebaseAuth.instance.currentUser!.email)
        {
          ind=i;
          print(ind);
          valueExists=true;
          break;
        }
      }
    }
  }
}

void updateArrayObjectAtSpecificIndex(DateTime eventDate) async {
  CollectionReference collection = FirebaseFirestore.instance.collection('Events');

  QuerySnapshot querySnapshot = await collection.get();
  for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs)
  {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    int outerKeyValue = data['participants'].length;
    int index=0;
    if(outerKeyValue>0)
    {
      for(int i=0;i<outerKeyValue;i++)
      {
        if(data['participants'][i]['email']==FirebaseAuth.instance.currentUser!.email)
        {
          print(ind);
          index=i;
          ind=i;
          break;
        }
      }
      List<dynamic> array=data['participants'] as List<dynamic>;
      Map<String,dynamic> ob={
        'email':FirebaseAuth.instance.currentUser!.email,
        'attendance':'present'
      };
      array[index]=ob;
      FirebaseFirestore.instance.collection('Events').doc(documentSnapshot.id).update({
        'participants':array,
        //'generateCertificate':true
      }).then((value) => {
        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.email).update({
          'event_participated':[{
            'event_name':documentSnapshot.id,
            'event_date':eventDate
          }]
      })
      });
    }
  }
  // Get the array field and modify the object at a specific index
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Event Display"),
      centerTitle: true,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyEvents1()));
                },
              ),
              Divider(color: Theme.of(context).primaryColor, height: 1,),
              ListTile(
                leading: Icon(Icons.event, size: _drawerIconSize,color: Theme.of(context).colorScheme.secondary,),
                title: Text('Events',style: TextStyle(fontSize: _drawerFontSize,color: Theme.of(context).colorScheme.secondary),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ShowEvents()));
                },
              ),
              Divider(color: Theme.of(context).primaryColor, height: 1,),

              ListTile(
                leading: Icon(Icons.verified_user_sharp, size: _drawerIconSize,color: Theme.of(context).colorScheme.secondary,),
                title: Text('Profile',style: TextStyle(fontSize: _drawerFontSize,color: Theme.of(context).colorScheme.secondary),),
                onTap: () {
                  Navigator.push( context, MaterialPageRoute(builder: (context) => ProfilePage(email_add: FirebaseAuth.instance.currentUser!.email.toString(),)));
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
      stream: FirebaseFirestore.instance.collection('Events').snapshots(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
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
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/ebg.jpeg',
                              ),
                              radius: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${snapshot.data?.docs[index]['club']}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: (){
                            //availability();
                            print(valueExists);
                           // print("Event Name: ${snapshot.data?.docs[index]['participants']}");
                            //compareOuterKeysFromList();
                            /* Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => EventDetails(eventname: snapshot.data?.docs[index]['event_name'],))); */
                          //print("${DateTime.now().isAfter(snapshot.data?.docs[index]['deadline'].toDate())}");
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Event Name: ${snapshot.data?.docs[index]['event_name']}",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 10,),
                            DateTime.now().isAfter(snapshot.data?.docs[index]['deadline'].toDate())
                            ?Container(child: Center(child: Text('Registeration closed', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white,),textAlign: TextAlign.center,)),
                            width: 100,
                            height: 60,
                            decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.black,borderRadius: BorderRadius.circular(20)),
                            )
                            /* snapshot.data!.docs[index]['participants'].contains("kunal123@somaiya.edu")==true
                            ?Column(
                              children: [
                                Container(child: Center(child: Text('Already registered', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,),textAlign: TextAlign.center,)),
                                width: 150,
                                height: 60,
                                decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.black,borderRadius: BorderRadius.circular(20)),
                                ),
                                SizedBox(height: 20,),
                                DateTime.now().isAfter(snapshot.data!.docs[index]['event_etime'].toDate().subtract(Duration(minutes: 15)))
                                ?ElevatedButton(onPressed: (){
                                  FirebaseFirestore.instance.collection('Events').doc(snapshot.data!.docs[index]['event_name']).update(
                                    {
                                      'participants':[{
                                        '${FirebaseAuth.instance.currentUser!.email}':{
                                          "Attendance":"Present"
                                        }
                                      }]
                                    }
                                  ).then((value) => {
                                    FirebaseFirestore.instance.collection('Events').doc(snapshot.data!.docs[index]['event_name']).update(
                                    {
                                      'event_participated':[{
                                        '${FirebaseAuth.instance.currentUser!.email}':{
                                          "Attendance":"Present"
                                        }
                                      }]
                                    }
                                  )
                                  });
                                }, child: Text("Mark Attendance"))
                                :Container()
                              ],
                            ) */
                            :valueExists==true
                            ?Column(
                              children: [
                                Container(child: Center(child: Text('Already registered', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white,),textAlign: TextAlign.center,)),
                                    width: 100,
                                    height: 60,
                                    decoration: BoxDecoration(shape: BoxShape.rectangle,color: Colors.black,borderRadius: BorderRadius.circular(20)),
                                    ),
                                    SizedBox(height: 10,),
                                    DateTime.now().isAfter(snapshot.data!.docs[index]['event_etime'].toDate().subtract(Duration(minutes: 15)))
                                  ?Column(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 50,
                                        child: ElevatedButton(onPressed: (){
                                          snapshot.data?.docs[index]['participants'][ind]['attendance']=='Absent'
                                          ?updateArrayObjectAtSpecificIndex(snapshot.data?.docs[index]['event_date'].toDate())
                                          :Container();
                                                                      }, 
                                                                      child:  snapshot.data?.docs[index]['participants'][ind]['attendance']=='Absent'
                                                                      ?Text("Mark \n Attendance",style: TextStyle(fontSize: 12),textAlign: TextAlign.center,)
                                                                      :Text("Attendance is marked",style: TextStyle(fontSize: 12),textAlign: TextAlign.center,)
                                                                      ),
                                      ),
                                      SizedBox(height: 10,),
                                       snapshot.data?.docs[index]['participants'][ind]['attendance']=='present' && DateTime.now().isAfter(snapshot.data?.docs[index]['event_etime'].toDate())==true
                                      ?Container(width: 100,
                                        height: 50,child: ElevatedButton(onPressed: () async {
                                          //Uri uri=Uri.parse("https://forms.gle/WaPHG62xHhNHjFA68");
                                          //await launchUrl(uri);
                                          launch('https://forms.gle/WaPHG62xHhNHjFA68');
                                        }, child: Text("Generate Certificate")))
                                      :Container()
                                    ],
                                  )
                                :Container(),
                              ],
                            )
                              :ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(120,25),
                                backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder( 
                                borderRadius: BorderRadius.circular(20.0)
                              )
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text('Register'.toUpperCase(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),),
                              ),
                              onPressed: (){
                                showDialog(context: context, builder: (BuildContext context){
                                  return AlertDialog(
                                    backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20.0)
                                      ),
                                    title: const Text("Do you sure you want to register?",style: TextStyle(
                                      color: Colors.white
                                    ),),
                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                              onPressed: ()
                                              {
                                                setState(() {
                                                  FirebaseFirestore.instance.collection('Events').doc(snapshot.data!.docs[index]['event_name']).update(
                                                  {
                                                    'participants':[
                                                      {
                                                        'email':FirebaseAuth.instance.currentUser!.email,
                                                        'attendance':'Absent'
                                                      }
                                                    ]
                                                  }
                                                ).then((value) => {
                                                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                    backgroundColor: Colors.black,
                                                    content: Text("Registered Successfully",style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20
                                                    ),))),
                                                    Navigator.pop(context)
                                                }).then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                                  return ShowEvents();
                                                },)));  
                                                });                                     
                                          }, child: const Text("Yes")),
                                          ElevatedButton(onPressed: (){
                                            Navigator.pop(context);
                                          }, child: const Text("No"))
                                        ],
                                      ),
                                    ],
                                  );
                                });
                                //After successful login we will redirect to profile page. Let's create profile page now
                                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShowEvents()));
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        /*Row(
                      children: [
                        Image.asset(
                          'assets/images/ebg.jpeg',
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),*/
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
