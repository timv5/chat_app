import 'package:chat_app/widgets/auth/auth_form_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {

  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();

}

class _AuthScreenState extends State<AuthScreen> {

  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String email, String password, String username, bool isLogin, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        // save username to the user after registration
        await FirebaseFirestore.instance.collection('users').doc(result.user!.uid).set({
          'username': username,
          'email': email
        });
      }

      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (error) {
      setState(() {
        _isLoading = false;
      });
      var message = 'An error occurred, please check your credentials';
      if (error.message != null) {
        message = error.message!;
      }

      // show error popup to the user
      ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('Error: $message'), backgroundColor: Theme.of(ctx).errorColor,)
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // show error popup to the user
      ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: const Text('Unknown error occurred'), backgroundColor: Theme.of(ctx).errorColor,)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthFormWidget(_submitAuthForm, _isLoading)
    );
  }

}
