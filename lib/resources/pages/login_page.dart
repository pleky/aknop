import 'package:flutter/material.dart';
import 'package:flutter_app/app/forms/login_form.dart';
import 'package:flutter_app/resources/pages/base_navigation_hub.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/login_controller.dart';

class LoginPage extends NyStatefulWidget<LoginController> {
  static RouteView path = ("/login", (_) => LoginPage());

  LoginPage({super.key}) : super(child: () => _LoginPageState());
}

class _LoginPageState extends NyState<LoginPage> {
  /// [LoginController] controller
  LoginController get controller => widget.controller;

  @override
  get init => () {};

  LoginForm form = LoginForm();

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(Icons.chevron_left),
            color: Colors.black,
            onPressed: () {
              pop();
            }),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              NyForm(
                form: form,
                header: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Login').displayLarge(color: Colors.black),
                    SizedBox(
                      height: 36,
                    )
                  ],
                ),
              ),
              Spacer(),
              Button.rounded(
                text: 'Login',
                color: Colors.black,
                onPressed: () {
                  routeTo(BaseNavigationHub.path);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
