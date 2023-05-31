// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewParticipant extends StatefulWidget {
  final String eventName;
  const ViewParticipant({super.key,required this.eventName});

  @override
  State<ViewParticipant> createState() => _ViewParticipantState();
}

class _ViewParticipantState extends State<ViewParticipant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Events').doc(widget.eventName).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
          {
            return Text("No Data");
          }
          return ListView.builder(
            itemCount: snapshot.data?['participants'].length,
            itemBuilder: (context, index)  {
              return Padding(
                padding: EdgeInsets.all(10),
                child:Table(
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.blue),
                      children: [
                        TableCell(child: Text("${snapshot.data?['participants'][index]['email']}",style: TextStyle(fontSize: 20),)),
                        SizedBox(width: 10,),
                        TableCell(child: Text("${snapshot.data?['participants'][index]['attendance']}", style: TextStyle(fontSize: 20)))
                        /* TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Email Id',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Attendance',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),*/
                      ]
                    ) 
                  ],
                ) ,
              );
            },
          );
        }
      ),
    );
  }
}