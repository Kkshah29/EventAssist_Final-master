 // ignore_for_file: unused_field, non_constant_identifier_names

 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing/UI/events/add_events.dart';

import '../../common/theme_helper.dart';
import '../widgets/header_widget.dart';

class CreateEvents extends StatefulWidget {
  final DateTime? event_date;
  final DateTime starttime;
  const CreateEvents({Key? key, required this.event_date,required this.starttime}) : super(key: key);
  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String? event_name;
  String? event_date;
  String? event_time;
  String? location;
  String? desc;
  String? end_time;
  String? currentuserclub;
  TimeOfDay? selectedsTime;
  String? stime="Select your event start Time";
  String? etime="Select your event end Time";
  TimeOfDay? selectedeTime;
  String sv="Gargi Plaza";
  var colnames=["Auditorium","Labs","Seminar Hall","Classrooms","Gargi Plaza"];

  @override
  void initState()
  {
    super.initState();
    fetchData();
    //selectedsTime=TimeOfDay.fromDateTime(widget.starttime);
  }
  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(widget.starttime),
    );

    if (pickedTime != null && pickedTime != selectedsTime) {
      setState(() {
        selectedsTime = pickedTime;
        stime="Start Time is: ${selectedsTime!.hour}:${selectedsTime!.minute}";
        print(stime);
      });
    }
  }

  Future<void> _selectTime1() async {
    TimeOfDay? initialETime=TimeOfDay(hour: selectedsTime!.hour+1, minute: selectedsTime!.minute);
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialETime,
    );

    if (pickedTime != null && pickedTime != selectedeTime) {
      setState(() {
        selectedeTime = pickedTime;
        etime="End Time is: ${selectedeTime!.hour}:${selectedeTime!.minute}";
      });
    }
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
      appBar: AppBar(
        title: const Text("Add an event"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const SizedBox(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /* GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey.shade300,
                                  size: 80.0,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(80, 80, 0, 0),
                                child: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey.shade700,
                                  size: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),*/
                        const SizedBox(height: 100,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration('Event Name', 'Enter your event name'),
                            onSaved: (value) {
                              event_name = value!;
                              print(event_name);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your event name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Row(
                          children: [
                            const Text("Select Infrastructure: "),
                            const SizedBox(width: 20,),
                            Container(
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              width: 130,
                              height: 50,

                              child: DropdownButton(
                                dropdownColor: Colors.white,
                                underline: Container(),
                                // Initial Value
                                value: sv,

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),
                                isExpanded: true,

                                // Array list of items
                                items: colnames.map((String colnames) {
                                  return DropdownMenuItem(
                                    value: colnames,
                                    child: Text(colnames),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) {
                                  setState(() {
                                    sv = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30,),
                        Container(
                            decoration: BoxDecoration(border:Border.all(color: Colors.black),borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.alarm_add,color: Colors.blue,size: 20,),
                                  const SizedBox(width: 20.0),
                                  Text("${widget.event_date!.day}-${widget.event_date!.month}-${widget.event_date!.year}"),
                                ],
                              ),
                            )
                          ),
                        /* Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: ElevatedButton(
                            onPressed: _selectTime,
                            child:const Text('Select start Time'),
                        ),
                        ), */
                        const SizedBox(height: 20.0),
                        InkWell(
                          onTap: () {
                            _selectTime();
                          },
                          child: Container(
                            decoration: BoxDecoration(border:Border.all(color: Colors.black),borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.alarm_add,color: Colors.blue,size: 20,),
                                  const SizedBox(width: 20.0),
                                  Text(stime.toString()),
                                ],
                              ),
                            )
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        InkWell(
                          onTap: () {
                            _selectTime1();
                          },
                          child: Container(
                            decoration: BoxDecoration(border:Border.all(color: Colors.black),borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.alarm_add,color: Colors.blue,size: 20,),
                                  const SizedBox(width: 20.0),
                                  Text(etime.toString()),
                                ],
                              ),
                            )
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                         decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                              decoration: ThemeHelper().textInputDecoration(
                                  "Enter event description",
                                  "Description"),
                                keyboardType: TextInputType.text,
                              onSaved: (value) {
                                desc = value;
                                print(desc);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter event description';
                                }
                                return null;
                              } 
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Register".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              DateTime temps_time=DateTime(
                                widget.event_date!.year,
                                widget.event_date!.month,
                                widget.event_date!.day,
                                selectedsTime!.hour,
                                selectedsTime!.minute
                              );
                              Timestamp start_time=Timestamp.fromDate(temps_time);
                              DateTime tempe_time=DateTime(
                                widget.event_date!.year,
                                widget.event_date!.month,
                                widget.event_date!.day,
                                selectedeTime!.hour,
                                selectedeTime!.minute
                              );
                              Timestamp end_time=Timestamp.fromDate(tempe_time);
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                FirebaseFirestore.instance.collection('Events').doc(event_name).set({
                                  'club':currentuserclub,
                                  'event_name':event_name,
                                  'event_date':widget.event_date,
                                  'event_stime':start_time,
                                  'event_etime':end_time,
                                  'Infrastructure':sv,
                                  'event_desc':desc,
                                  'generatecertificate':false,
                                  'participants':[({

                                  })],
                                  'deadline':start_time.toDate().subtract(const Duration(days: 1))
                                }).then((value) => {
                                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("Event Registered Successfully")))),
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => MyApp(),)
                                      ,(Route<dynamic> route) => false)
                                });
                                 
                                }
                              }
    ))
    ]
    )
    )
    ]
    )
    )
    ]
    )
    )
    );
}}
