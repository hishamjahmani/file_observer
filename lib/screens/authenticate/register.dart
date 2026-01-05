// ignore_for_file: prefer_const_constructors

import 'package:file_observer/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:file_observer/shared/constants.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String userName = '';
  String userSection = '';
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? section;

  FocusNode? registerFocusNode;

  @override
  void initState() {
    super.initState();
    registerFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    registerFocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        elevation: 0.0,
        title: const Center(child: Text('Sign in to File Track System')),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Enter email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email can't be empty";
                    }

                    if (!value.contains('@') || !value.contains('.')) {
                      return "Invalid email";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration:
                      const InputDecoration(hintText: 'Enter the password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email can't be empty";
                    } else {
                      return null;
                    }
                  },
                  obscureText: false,
                  onChanged: (val) {
                    //print(val);
                    setState(() => password = val);
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration:
                      const InputDecoration(hintText: 'Enter User Name'),
                      validator: (value) => value!.isEmpty ? 'Please enter a user name':null,
                  onChanged: (val) {
                    setState(() => userName = val);
                  },
                ),
                const SizedBox(height: 20.0),
                // TextFormField(
                //   decoration:
                //       new InputDecoration(hintText: ''),
                //   onChanged: (val) {
                //     setState(() => userSection = val);
                //   },
                // ),
                DropdownButtonFormField(
                  validator: (value)=> value==null ? "please select a user section" : null,
                  
                  hint: Text('Enter User Section'),
                  value: section,
                  items: sectionsList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      userSection = val!;
                      registerFocusNode!.requestFocus();
                    });
                    //print(val);
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    onPressed: () async {
                      // print(email);
                      // print(password);
                      _formKey.currentState!.validate();
                      await _auth.signInWithEmailAndPassword(email, password);
                    }),
                SizedBox(width: 20, height: 20),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 80, 8, 8),
                  child: ElevatedButton(
                      focusNode: registerFocusNode,
                      child: const Text(
                        'Register Now',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        // print(email);
                        //print('**************************************************$password');
                        _formKey.currentState!.validate();
                        await _auth.registerWithEmailAndPassword(
                            email, password, userName, userSection);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
