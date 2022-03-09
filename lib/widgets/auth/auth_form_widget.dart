import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthFormWidget extends StatefulWidget {

  final void Function(String email, String password, String username, bool isLogin, BuildContext ctx) submitAuthFunction;
  final bool isLoading;

  AuthFormWidget(this.submitAuthFunction, this.isLoading);

  @override
  _AuthFormWidgetState createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {

  final _formKey = GlobalKey<FormState>();
  String ?_userEmail;
  String ?_userUsername;
  String ?_userPassword;
  var _isLogin = true;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      // move the focus of any input field to nothing
      FocusScope.of(context).unfocus();

      // it will trigger onSaved function on every form field
      _formKey.currentState!.save();

      // authenticate user on firebase
      widget.submitAuthFunction(
          _userEmail!,
          _userPassword!,
          _userUsername != null ? _userUsername! : '',
          _isLogin,
          context
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // take as much height as needed not as much as possible
                children: <Widget>[
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (inputtedValue) {
                      if (inputtedValue!.isEmpty || !inputtedValue.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email Address'),
                    onSaved: (inputtedValue) {
                      _userEmail = inputtedValue!.trim();
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (inputtedValue) {
                        if (inputtedValue!.isEmpty) {
                          return 'Please enter a username';
                        }
                        if (inputtedValue.length < 3) {
                          return 'Username should be at least 3 chars long';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(labelText: 'Username'),
                      onSaved: (inputtedValue) {
                        _userUsername = inputtedValue!.trim();
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (inputtedValue) {
                      if (inputtedValue!.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (inputtedValue.length < 5) {
                        return 'Password should be at least 5 chars long';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,  // hide password
                    onSaved: (inputtedValue) {
                      _userPassword = inputtedValue!.trim();
                    },
                  ),
                  const SizedBox(height: 12,),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: _isLogin ? const Text('Login') : const Text('Sign Up'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      child: _isLogin ? const Text('Create new account') : const Text('I already have an account'),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ],
              )
            ),
          ),
        ),
      ),
    );
  }
}
