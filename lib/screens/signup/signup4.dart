import 'package:codephile/resources/helper_functions.dart';
import 'package:codephile/screens/verify/verify_screen.dart';
import 'package:codephile/resources/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:codephile/models/signup.dart';
import 'package:codephile/services/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'progress_tab_bar.dart';

class SignUpPage4 extends StatefulWidget {
  final String? name;
  final String? email;
  final String? institute;
  final Handle? handle;
  final String? userImagePath;

  const SignUpPage4({
    Key? key,
    this.name,
    this.email,
    this.institute,
    this.handle,
    this.userImagePath,
  }) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage4> {
  String? _username, _password;
  String? name;
  String? email;
  String? institute;
  Handle? handle;
  String? userImagePath;
  bool enableTextFields = true;
  bool _userIconColor = false,
      _lockIconColor = false,
      _seePasswordIconColor = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isCreateAccountButtonTapped = false;
  bool isCreateAccountSuccessful = false;
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    name = widget.name;
    email = widget.email;
    institute = widget.institute;
    handle = widget.handle;
    userImagePath = widget.userImagePath;
    showConnectivityStatus();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ((isCreateAccountButtonTapped) || (isCreateAccountSuccessful))
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        const ProgressTabBar(4),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 15),
                              const Text(
                                  'Setup a username and password for Codephile',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 25.0),
                              _showUsernameInput(),
                              const SizedBox(height: 15.0),
                              _showPasswordInput(),
                            ],
                          ),
                        )
                      ],
                    ),
              _showCreateAccountButton(),
            ],
          ),
        ),
      ),
      onWillPop: _onBackPressed,
    );
  }

  Widget _showUsernameInput() {
    return TextFormField(
      onTap: () {
        setState(() {
          _userIconColor = true;
          if ((_passwordController.text == '') ||
              // ignore: unnecessary_null_comparison
              (_passwordController.text == null)) {
            _seePasswordIconColor = false;
            _lockIconColor = false;
          }
        });
      },
      controller: _usernameController,
      enabled: enableTextFields,
      maxLines: 1,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        labelText: "Username",
        prefixIcon: Icon(
          Icons.person,
          color: _userIconColor ? codephileMain : Colors.grey,
          size: 39,
        ),
        border: const OutlineInputBorder(),
        labelStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Username can\'t be empty' : null,
      onSaved: (value) => _username = value,
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          TextFormField(
            onTap: () {
              setState(() {
                _lockIconColor = true;
                _seePasswordIconColor = true;
                if ((_usernameController.text == '') ||
                    // ignore: unnecessary_null_comparison
                    (_passwordController.text == null)) {
                  _userIconColor = false;
                }
              });
            },
            controller: _passwordController,
            enabled: enableTextFields,
            maxLines: 1,
            obscureText: _obscureText,
            autofocus: false,
            decoration: InputDecoration(
              labelText: "Password",
              border: const OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.lock,
                color: _lockIconColor ? codephileMain : Colors.grey,
                size: 39,
              ),
              labelStyle: const TextStyle(
                color: Colors.grey,
              ),
            ),
            validator: (value) {
              return value!.isEmpty ? 'Password can\'t be empty' : null;
            },
            onSaved: (value) => _password = value,
          ),
          IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: _seePasswordIconColor ? codephileMain : Colors.grey,
            ),
            onPressed: _toggle,
          ),
        ],
      ),
    );
  }

  Widget _showCreateAccountButton() {
    showConnectivityStatus();
    return (isCreateAccountButtonTapped)
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey[500],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Text(
                      'Creating...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                onPressed: () {}),
          )
        : (isCreateAccountSuccessful)
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: codephileMain,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: const Text(
                          'Created Successfully',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {}),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: codephileMain,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: const Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  onPressed: _validateAndSubmit,
                ),
              );
  }

  bool _validateAndSave() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() {
    if (_validateAndSave()) {
      setState(() {
        isCreateAccountButtonTapped = true;
        enableTextFields = false;
        _userIconColor = true;
        _lockIconColor = true;
        _seePasswordIconColor = true;
      });
      SignUp details = SignUp(
          handle: handle,
          password: _password,
          username: _username,
          fullname: name,
          email: email,
          institute: institute);
      signUp(details).then((res) async {
        if (res["statusCode"] == 201) {
          // Fluttertoast.showToast(
          //   msg: "Account Creation successful",
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.CENTER,
          //   fontSize: 12.0,
          // );
          String? id = res["response"];
          setState(() {
            isCreateAccountButtonTapped = false;
            isCreateAccountSuccessful = true;
          });
          if (userImagePath != null) {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString('userImagePath', userImagePath!);
          }
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return VerifyScreen(
                  username: _username,
                  password: _password,
                  id: id,
                );
              },
            ),
          );
          // login(_username, _password).then((userToken) {
          //   if (userToken != null) {
          //     id(userToken.token, context).then((id) async {
          //       SharedPreferences prefs = await SharedPreferences.getInstance();
          //       prefs.setString("token", userToken.token);
          //       prefs.setString("uid", id);
          //       if (userImagePath != null) {
          //         int uploadStatusCode = await uploadImage(
          //             userToken.token, userImagePath, context);
          //       }
          //       if (isCreateAccountSuccessful) {
          //         Navigator.of(context).popUntil((route) => route.isFirst);
          //         Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) =>
          //                   HomePage(token: userToken.token, userId: id)),
          //         ).then((_) => _formKey.currentState.reset());
          //       }
          //     });
          //   } else {
          //     Fluttertoast.showToast(
          //       msg: "Something went wrong. Try Again",
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.CENTER,
          //       fontSize: 12.0,
          //     );
          //     setState(() {
          //       isCreateAccountButtonTapped = false;
          //       isCreateAccountSuccessful = false;
          //       enableTextFields = true;
          //     });
          //   }
          // });
        } else {
          Fluttertoast.showToast(
            msg: res["response"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 12.0,
          );
          setState(() {
            isCreateAccountButtonTapped = false;
            isCreateAccountSuccessful = false;
            enableTextFields = true;
          });
        }
      });
    }
  }

  Future<bool> _onBackPressed() async {
    if (isCreateAccountButtonTapped || isCreateAccountSuccessful) {
      return false;
    }
    return true;
  }
}
