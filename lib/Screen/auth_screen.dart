import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../model/http_exception.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth-screen';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with TickerProviderStateMixin {
  //given by material dart as a clock
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  AnimationController? _controller;
  Animation<Offset>? _SlideAnimation;
  Animation<double>? _OpacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _SlideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(CurvedAnimation(
            parent: _controller!,
            curve: Curves
                .linear)); //between two values and just keep values donot give animation
    // _HeightAnimation!.addListener(
    //   () => {
    //     setState(
    //       () {},
    //     ),
    //   },
    // );
    _OpacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.ease));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller!.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('AN error Ocurrded'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('OK'))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
      Navigator.of(context).pushReplacementNamed('/OverViewScreen');
    } on Http_Exception catch (error) {
      // check for a speciific error(on)
      var errorMessage = 'Authantication failed ... Please try again';
      if (error.Message.contains('EMAIL_EXISTS')) {
        errorMessage = 'This Email already exists';
      } else if (error.Message.contains('INVALID_EMAIL')) {
        errorMessage = 'This Email is not valid';
      } else if (error.Message.contains('WEAK_PASSWROD')) {
        errorMessage = 'This Password is too weak';
      } else if (error.Message.contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'This Email dosenot exists';
      } else if (error.Message.contains('INVALID_PASSWORD')) {
        errorMessage = 'The Password is not valid';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      // const errorMessage =
      //     'Couldnot Authanticate you ... Please try again later';
      _showErrorDialog(error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
      _controller!.forward(); //starts the animation
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _controller!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child:
            // AnimatedBuilder(
            //   //this help to animate container without rebuilding everything in it
            //   //things which are not going to need animation needs to be in child
            //   animation: _HeightAnimation!,
            //   builder: (ctx, ch) => Container(
            AnimatedContainer(
          height: _authMode == AuthMode.signup ? 320 : 260, //
          // height: _HeightAnimation?.value.height, // Is used in Builder method
          constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.signup ? 320 : 260),
          width: deviceSize.width * 0.75,
          padding: const EdgeInsets.all(16.0),
          duration: Duration(milliseconds: 300),
          curve:
              Curves.easeIn, //donot need animation cotroller or heightAnimation
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                      // return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value!;
                    },
                  ),
                  // if (_authMode == AuthMode.signup)

                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.login ? 0.0 : 60,
                        maxHeight: _authMode == AuthMode.login ? 0 : 120),
                    curve: Curves.linear,
                    child: SlideTransition(
                      position: _SlideAnimation!,
                      child: FadeTransition(
                        opacity: _OpacityAnimation!,
                        child: TextFormField(
                          enabled: _authMode == AuthMode.signup,
                          decoration: const InputDecoration(
                              labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: _authMode == AuthMode.signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      child: Text(
                          _authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        primary: Theme.of(context).primaryColor,
                        // primary: Theme.of(context).primaryTextTheme.button.color,
                      ),
                    ),
                  TextButton(
                    child: Text(
                        '${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                    onPressed: _switchAuthMode,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      primary: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
