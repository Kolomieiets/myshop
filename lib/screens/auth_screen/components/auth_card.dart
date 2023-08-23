import 'package:flutter/material.dart';
import 'package:my_shop/screens/auth_screen.dart';
import 'package:my_shop/screens/auth_screen/mixin/auth_card_mixin.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin, AuthCardMixin {
  // final GlobalKey<FormState> _formKey = GlobalKey();
  // AuthMode _authMode = AuthMode.login;
  // Map<String, String> _authData = {
  //   'email': '',
  //   'password': '',
  // };
  // bool _isLoading = false;
  // final _passwordController = TextEditingController();
  // AnimationController? _controller;
  // Animation<Offset>? _slideAnimation;
  // Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    slideAnimation = Tween<Offset>(
            begin: const Offset(0, -1.5), end: const Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: controller!, curve: Curves.linear));
    opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller!, curve: Curves.easeIn));
    // _heightAnimation!.addListener(() => setState(() {}) );
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  // void showErrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text('An error occured!'),
  //       content: Text(message),
  //       actions: [
  //         TextButton(
  //             onPressed: () => Navigator.of(ctx).pop(),
  //             child: const Text('Ok')),
  //       ],
  //     ),
  //   );
  // }

  // Future<void> _submit() async {
  //   if (!_formKey.currentState!.validate()) {
  //     // Invalid!
  //     return;
  //   }
  //   _formKey.currentState!.save();
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     if (_authMode == AuthMode.login) {
  //       // Log user in
  //       //await Provider.of<AuthProvider>(context, listen: false).login(_authData['email']!, _authData['password']!);
  //       await context
  //           .read<AuthProvider>()
  //           .login(_authData['email']!, _authData['password']!);
  //     } else {
  //       // Sign user up
  //       await context
  //           .read<AuthProvider>()
  //           .signup(_authData['email']!, _authData['password']!);
  //     }
  //   } on HttpException catch (error) {
  //     String errorMessage = 'Authentication failed';
  //     if (error.toString().contains('EMAIL_EXISTS')) {
  //       errorMessage = 'This e-mail adress ia slready in use';
  //     } else if (error.toString().contains('INVALID_EMAIL')) {
  //       errorMessage = 'This is not a valid e-mail adress';
  //     } else if (error.toString().contains('WEAK_PASSWORD')) {
  //       errorMessage = 'This password is too weak';
  //     } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
  //       errorMessage = 'This email not found';
  //     } else if (error.toString().contains('INVALID_PASSWORD')) {
  //       errorMessage = 'This is not a valid password';
  //     }
  //     showErrorDialog(errorMessage);
  //   } catch (error) {
  //     String errorMessage =
  //         'Could not authenticate you. Please try again later';
  //     showErrorDialog(errorMessage);
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  // void _switchAuthMode() {
  //   if (_authMode == AuthMode.login) {
  //     setState(() {
  //       _authMode = AuthMode.signup;
  //     });
  //     _controller!.forward();
  //   } else {
  //     setState(() {
  //       _authMode = AuthMode.login;
  //     });
  //     _controller!.reverse();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: authMode == AuthMode.signup ? 320 : 260,
        // height: _heightAnimation!.value.height,
        constraints:
            BoxConstraints(minHeight: authMode == AuthMode.signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
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
                  },
                  onSaved: (value) {
                    authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    authData['password'] = value!;
                  },
                ),
                if (authMode == AuthMode.signup)
                  AnimatedContainer(
                    constraints: BoxConstraints(
                      maxHeight: authMode == AuthMode.signup ? 120 : 0,
                      minHeight: authMode == AuthMode.signup ? 60 : 0,
                    ),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: opacityAnimation!,
                      child: SlideTransition(
                        position: slideAnimation!,
                        child: TextFormField(
                          enabled: authMode == AuthMode.signup,
                          decoration: const InputDecoration(
                              labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: authMode == AuthMode.signup
                              ? (value) {
                                  if (value != passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                }
                              : null,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    child:
                        Text(authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      // foregroundColor: Theme.of(context).primaryTextTheme.button.color,
                    ),
                  ),
                TextButton(
                  child: Text(
                      '${authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: switchAuthMode,
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 4),
                      foregroundColor: Theme.of(context).primaryColor,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}