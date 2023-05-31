// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatefulWidget {
  final String? eventname;
  const EventDetails({Key? key,required this.eventname}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        foregroundColor: Colors.white,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
            child: const Icon(Icons.arrow_back)),
        iconTheme: const IconThemeData(color: Colors.white,
        ),
        title: const Text("Event Details"),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Events').doc(widget.eventname).snapshots(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  children: [
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
                          children:  [
                            Text(
                              "${snapshot.data?.get('Club')}",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/ebg.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.only(left:18.0),
                      child: Row(
                        children: [
                          Text(
                            "Event Name: ",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                              "${snapshot.data?.get('event_name')}",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left:18.0),
                      child: Row(
                        children: [
                          Text(
                            "Event Date: ",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${DateFormat('dd:MM:yyyy').format(snapshot.data?.get('event_date').toDate())}",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left:18.0),
                      child: Row(
                        children: [
                          Text(
                            "Event Time: ",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${DateFormat('hh:mm a').format(snapshot.data?.get('event_stime').toDate())} onwards",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left:18.0),
                      child: Row(
                        children: [
                          Text(
                            "Event Location: ",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${snapshot.data?.get('Infrastructure')}",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 45),
                    const Padding(
                      padding: EdgeInsets.only(left:18.0),
                      child: Text(
                        "Event Description: ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: AutoSizeText(
                          maxLines: 1,
                          "${snapshot.data?.get('event_desc')}",
                          style: TextStyle(
                            fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ),
          );
        }
      ),
    );
  }
}
