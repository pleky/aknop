import 'package:flutter/material.dart';
import 'package:flutter_app/app/forms/login_form.dart';
import 'package:flutter_app/resources/pages/base_navigation_hub.dart';
import 'package:flutter_app/resources/pages/survey_list_page.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

class LandingController extends Controller {
  late BuildContext _ctx;

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  construct(BuildContext context) {
    super.construct(context);
    _ctx = context;
  }

  void showLoginForm() {
    showModalBottomSheet(
        context: _ctx,
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
                        onPressed: () {
                          if (_formKey.currentState!.saveAndValidate()) {
                            print(_formKey.currentState!.value);
                            pop();
                            Future.delayed(Duration(milliseconds: 500), () {
                              routeTo(SurveyListPage.path, navigationType: NavigationType.pushReplace);
                            });
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
}
