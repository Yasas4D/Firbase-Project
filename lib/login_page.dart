import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final formkey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      print('Form is Valid');
      print(_email);
      print(_password);
      return true;
    } else {
      print('Form is Null');
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          FirebaseUser user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
          print('Signed in :${user.uid}');

          Navigator.of(context).push(
            new MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return new Scaffold(
                  appBar: new AppBar(
                    title: const Text('You Are signed in'),
                  ),
                );
              },
            ),
          );
        } else {
          FirebaseUser user = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email, password: _password);
          print('Registerd user :${user.uid}');
          Navigator.of(context).push(
            new MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return new Scaffold(
                  appBar: new AppBar(
                    title: const Text('Registration Sucessfull'),
                  ),
                  body: Text("Go to Login"),
                );
              },
            ),
          );
        }
      } catch (e) {
        print('Error : $e');
        Navigator.of(context).push(
          new MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return new Scaffold(
                appBar: new AppBar(
                  title: const Text('Login Unsucessfull'),
                ),
                body: Text("Go to previous"),
              );
            },
          ),
        );
      }
    } else {}
  }

  void moveToRegister() {
    formkey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formkey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Login Page '),
      ),
      body: new Container(
          padding: EdgeInsets.all(16.0),
          child: new Form(
            key: formkey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + buildSubmitButtons(),
            ),
          )),
    );
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email Can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        validator: (value) => value.isEmpty ? 'Password Can\'t be empty' : null,
        onSaved: (value) => _password = value,
        obscureText: true,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text('Login', style: new TextStyle(fontSize: 20)),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text('Create an Account',
              style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToRegister,
        )
      ];
    } else {
      return [
        new RaisedButton(
          child:
              new Text('Create an Account', style: new TextStyle(fontSize: 20)),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text('Have an Account? Login',
              style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Registration Page'),
          ),
        )
      ];
    }
  }
}
