import 'package:flutter/material.dart';
import 'package:my_shop/screens/auth_screen/auth_screen.dart';
import 'package:my_shop/screens/auth_screen/mixin/auth_card_mixin.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin, AuthCardMixin {
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
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

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
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    } else {
                      return null;
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
                    duration: const Duration(milliseconds: 300),
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
                                  } else {
                                    return null;
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
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 8.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child:
                        Text(authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(
                  onPressed: switchAuthMode,
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 4),
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text(
                      '${authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
