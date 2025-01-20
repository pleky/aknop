import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/landing_controller.dart';

class LandingPage extends NyStatefulWidget<LandingController> {
  static RouteView path = ("/landing", (_) => LandingPage());

  LandingPage({super.key}) : super(child: () => _LandingPageState());
}

class _LandingPageState extends NyState<LandingPage> {
  /// [LandingController] controller
  LandingController get controller => widget.controller;

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
                  onPressed: () {
                    controller.showLoginForm();
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1)
            ],
          ),
        ),
      ),
    );
  }
}
