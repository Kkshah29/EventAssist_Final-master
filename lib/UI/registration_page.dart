
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing/common/theme_helper.dart';
import 'package:testing/UI/widgets/header_widget.dart';
import 'package:testing/utils/utils.dart';

import 'profile_page.dart';

class RegistrationPage extends  StatefulWidget{
  const RegistrationPage({super.key});

  @override
  State<StatefulWidget> createState() {
     return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage>{


  bool loading= false ;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  String? emailadd;
  String? pass;
  String? fname;
  String? lname;
  double? number;
  double? rollnumber;
  String sv="KJ Somaiya college of Engineering";
  var colnames=["KJ Somaiya college of Engineering","KJ Somaiya college of Commerce and Arts","KJ Somaiya Polytechnic","KJ Somaiya college of Management"];
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  void _updateDocument() {
    final Map<String, dynamic> userData = {
      'name': '$fname $lname',
      'email': emailadd,
      'Mobile Number':number,
      'Roll number':rollnumber,
      'College':sv
    };
    final DocumentReference userDoc = usersCollection.doc(emailadd);
    userDoc.set(userData)
    .then((value) {
      print('Document updated successfully.');
    }).catchError((error) {
      print('Failed to update document: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        GestureDetector(
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
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration('First Name', 'Enter your first name'),
                            onSaved: (value) {
                              fname = value!;
                              print(fname);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration('Last Name', 'Enter your last name'),
                            onSaved: (value) {
                              lname = value!;
                              print(lname);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration("E-mail address", "Enter your email"),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              emailadd = value!;
                              print(emailadd);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[a-zA-Z0-9_.+-]+@somaiya\.edu$').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                "Mobile Number",
                                "Enter your mobile number"),
                            keyboardType: TextInputType.phone,
                              onSaved: (value) {
                                number = double.parse(value!);
                                print(number);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Phone number';
                                }
                                if (!RegExp(r"^(\d+)*$").hasMatch(value)) {
                                  return 'Please enter a valid phone Number';
                                }
                                return null;
                              }
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                "Roll number",
                                "Enter your roll number"),
                            keyboardType: TextInputType.number,
                            onSaved: (value) {
                              rollnumber = double.parse(value!);
                              print(rollnumber);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your roll number';
                              }
                              if (!RegExp(r"^(\d+)*$").hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          width: 300,
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
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            onSaved: (value) {
                              pass = value!;
                              print(pass);
                            },
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password", "Enter your password"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your password";
                              }
                              if (val.length<8) {
                                return "Password should be minimum of 8 characters";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValue = value!;
                                            state.didChange(value);
                                          });
                                        }),
                                    const Text("I accept all terms and conditions.", style: TextStyle(color: Colors.grey),),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Theme.of(context).colorScheme.error,fontSize: 12,),
                                  ),
                                )
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'You need to accept terms and conditions';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 5.0),
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
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                print(emailadd);
                                print(pass);
                                print(fname);
                                print(lname);
                                setState(() {
                                  loading = true ;
                                });
                                _auth.createUserWithEmailAndPassword(email: emailadd.toString(),
                                    password: pass.toString()).then((value){
                                  setState(() {
                                    loading = false ;
                                  });

                                }).onError((error, stackTrace){
                                 Utils().toastMessage(error.toString());
                                 setState(() {
                                   loading = false ;
                                 });
                                }).then((value) {
                                  _updateDocument();
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("Registered Successfully"))));
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage(email_add: FirebaseAuth.instance.currentUser!.email.toString(),)
                                      ),(Route<dynamic> route) => false);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}