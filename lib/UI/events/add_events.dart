// ignore_for_file: unused_local_variable, unused_import, avoid_web_libraries_in_flutter, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:testing/UI/events/create_events.dart';
import 'package:intl/intl.dart';
import 'package:testing/UI/events/myevents.dart';

import '../login_page.dart';
import '../profile_page.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final double  _drawerIconSize = 24;
  final double _drawerFontSize = 17;

  List<Meeting> appointments1 = [];
  CalendarController c=new CalendarController();
  DateTime? selectedDate;
  Timestamp? st;
  late DateTime et;
  Timestamp? st1;
  late DateTime et1;
  String title="";
  MeetingDataSource? _dataSource;
  String infra="";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    et=DateTime.now();
    et1=DateTime.now();
     selectedDate=DateTime.now();
    fetchData().then((value) => {
       _getDataSource(),
       _dataSource=MeetingDataSource(appointments1),
    });
  }

  Future<void> _getDataSource() async {
    final List<Meeting> meetings = appointments1;
    print("Meetings: ${meetings.length}");
  }

  

  List<TimeRegion> _getTimeRegions() {
  final List<TimeRegion> regions = <TimeRegion>[];
  DateTime date = DateTime.now();
  date = DateTime(date.year, date.month, date.day, 9, 0, 0);
  regions.add(TimeRegion(
      startTime: date,
      endTime: date.add(const Duration(hours: 2)),
      enablePointerInteraction: false,
      color: Colors.green,
      text: 'Break'));

  return regions;
}

  /* Future<void> _initData() async {
    // Perform asynchronous tasks here
    await Future.delayed(const Duration(seconds: 5));
    print('Async task completed!');
  } */

  Future<void> fetchData() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Events') // Replace with your collection name
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      List<Appointment> fetchedAppointments = [];
      // Iterate through the documents and retrieve data
      for (DocumentSnapshot document in querySnapshot.docs) {
        final dt=document.data() as Map<String,dynamic>;
          st=dt['event_stime'];
          et=st!.toDate();
          st1=dt['event_etime'];
          et1=st1!.toDate();
          title=dt['event_name'];
          infra=dt['Infrastructure'];
          print(dt);
          appointments1.add(Meeting(title, infra, et, et1, Color.fromARGB(255, 7, 134, 245), false));
      }
      print(appointments1.length);
    } else {
      // No documents found
      const CircularProgressIndicator();
    }
  } catch (e) {
    // Handle error
    print(e);
  }
}

void _handleAppointmentTap(Meeting details){
  
    // Handle the appointment tap event
    // You can navigate to a new page and pass the appointment details
    // Or show a dialog with the appointment information
    //Meeting tappedAppointment = details.appointments!.first;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(details.eventName),
          content: Text("Start Time: ${DateFormat('hh:mm a').format(details.from)} \nEnd Time: ${DateFormat('hh:mm a').format(details.to)} \nVenue: ${details.infra}"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }


void onCalendarTapped(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.calendarCell) {
      setState(() {
        selectedDate = details.date; 

        //print(selectedDate);// Update selected date
      });
       Navigator.push(context, MaterialPageRoute(builder: (context) => CreateEvents(event_date: selectedDate,starttime: DateTime(details.date!.year,details.date!.month,details.date!.day,details.date!.hour,details.date!.minute),)));
    }
    if(details.targetElement == CalendarElement.appointment)
    {
     //Meeting appointment = details.appointments![0];
      _handleAppointmentTap(details.appointments![0]);
    }
  }

  void _handleSignOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage())).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("Logout Successfully"))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Calendar with Firebase Appoin tments'),centerTitle: true),
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
                    Navigator.push( context, MaterialPageRoute(builder: (context) => MyApp()));
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
        body: SfCalendar(
          view: CalendarView.week,
          dataSource: _dataSource,
          showDatePickerButton: true,
          initialSelectedDate: selectedDate,
          showCurrentTimeIndicator: false,
          firstDayOfWeek: 1,
          showWeekNumber: true,
          onTap: onCalendarTapped,
          showNavigationArrow: true,
          //specialRegions: _getTimeRegions(),
        ),
      );
  }

  /* _AppointmentDataSource _getCalendarDataSource() {
    return _AppointmentDataSource(appointments);
  }
 */
  /* Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final Appointment appointment = details.appointments.first;
    return Container(
      color: Colors.blue, // Customize the appointment appearance as desired
      child: Text(appointment.title),
    );
  } */
}
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return "${appointments![index].eventName}";
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
class Meeting {
  Meeting(this.eventName, this.infra, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  String infra;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
/* class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class Appointment {
  String? title;
  DateTime? startTime;
  DateTime? endTime;

  Appointment({this.title, this.startTime, this.endTime});
}
 */