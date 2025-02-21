import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/auth.dart';
import 'package:flutter_app/app/networking/auth_api_service.dart';
import 'package:flutter_app/resources/pages/survey_list_page.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/landing_controller.dart';

class LandingPage extends NyStatefulWidget<LandingController> {
  static RouteView path = ("/landing", (_) => LandingPage());

  LandingPage({super.key}) : super(child: () => _LandingPageState());
}

class _LandingPageState extends NyState<LandingPage> {
  /// [LandingController] controller
  LandingController get controller => widget.controller;

  final _formKey = GlobalKey<FormBuilderState>();
  final AuthApiService _authApiService = AuthApiService();

  void showLoginForm() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return Container(
            padding: MediaQuery.of(context).viewInsets,
            width: double.infinity,
            child: FormBuilder(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => pop(),
                    ),
                    Center(child: Text('Login').displayLarge().alignCenter()),
                    SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'email',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Email'),
                        isDense: true,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ]),
                    ),
                    FormBuilderTextField(
                      name: 'password',
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Password'),
                        isDense: true,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          _formKey.currentState!.saveAndValidate();
                          if (_formKey.currentState?.validate() ?? false) {
                            pop();
                            showDialog(
                              context: context,
                              useRootNavigator: true,
                              builder: (context) {
                                return Center(
                                  child: Container(
                                    padding: EdgeInsets.all(30),
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    height: MediaQuery.of(context).size.width * 0.5,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            );

                            final email = _formKey.currentState!.value['email'];
                            final password = _formKey.currentState!.value['password'];

                            AuthModel? user = await _authApiService.login(
                              email,
                              password,
                            );

                            if (user != null) {
                              print('user nih ${user.toJson()}');
                              Auth.authenticate(data: user.toJson());

                              pop();
                              Future.delayed(Duration(milliseconds: 500), () {
                                routeTo(SurveyListPage.path, navigationType: NavigationType.pushReplace);
                              });
                            } else {
                              pop();
                              showToastDanger(
                                title: 'Login Failed',
                                description: 'Please check your email and password',
                              );
                            }
                          }
                        },
                        child: Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  get init => () {};

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF023a92),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(getImageAsset('logo.png'), width: 60, height: 60),
              Spacer(),
              Text('Angka Kebutuhan Nyata Operasi dan Pemeliharaan')
                  .displayMedium()
                  .setStyle(TextStyle(color: Color(0xFF61eabc))),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  child: Text('Login').titleMedium(color: Colors.black, fontWeight: FontWeight.w600),
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith((states) {
                    return Color(0xFF61eabc);
                  }), side: WidgetStateBorderSide.resolveWith(
                    (states) {
                      return BorderSide(color: Color(0xFF61eabc));
                    },
                  )),
                  onPressed: showLoginForm,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Center(
                child: Text('Versi v0.0.5').bodySmall(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
