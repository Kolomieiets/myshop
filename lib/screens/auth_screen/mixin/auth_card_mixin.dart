import 'package:flutter/material.dart';
import 'package:my_shop/models/http_exception.dart';
import 'package:my_shop/providers/auth_provider.dart';
import 'package:my_shop/screens/auth_screen/auth_screen.dart';
import 'package:provider/provider.dart';

mixin AuthCardMixin<AuthCard extends StatefulWidget> on State<AuthCard> {
final GlobalKey<FormState> formKey = GlobalKey();
    AuthMode authMode = AuthMode.login;
    Map<String, String> authData = {
      'email': '',
      'password': '',
    };
    bool isLoading = false;
    final passwordController = TextEditingController();
    AnimationController? controller;
    Animation<Offset>? slideAnimation;
    Animation<double>? opacityAnimation;

  void showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occured!'),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Ok')),
          ],
        ),
      );
    }

    Future<void> submit() async {
      if (!formKey.currentState!.validate()) {
        // Invalid!
        return;
      }
      formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      try {
        if (authMode == AuthMode.login) {
          // Log user in
          //await Provider.of<AuthProvider>(context, listen: false).login(_authData['email']!, _authData['password']!);
          await context
              .read<AuthProvider>()
              .login(authData['email']!, authData['password']!);
        } else {
          // Sign user up
          await context
              .read<AuthProvider>()
              .signup(authData['email']!, authData['password']!);
        }
      } on HttpException catch (error) {
        String errorMessage = 'Authentication failed';
        if (error.toString().contains('EMAIL_EXISTS')) {
          errorMessage = 'This e-mail adress ia slready in use';
        } else if (error.toString().contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid e-mail adress';
        } else if (error.toString().contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is too weak';
        } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'This email not found';
        } else if (error.toString().contains('INVALID_PASSWORD')) {
          errorMessage = 'This is not a valid password';
        }
        showErrorDialog(errorMessage);
      } catch (error) {
        String errorMessage =
            'Could not authenticate you. Please try again later';
        showErrorDialog(errorMessage);
      }

      setState(() {
        isLoading = false;
      });
    }

    void switchAuthMode() {
      if (authMode == AuthMode.login) {
        setState(() {
          authMode = AuthMode.signup;
        });
        controller!.forward();
      } else {
        setState(() {
          authMode = AuthMode.login;
        });
        controller!.reverse();
      }
    }
  }

