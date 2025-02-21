import 'package:flutter/material.dart';

import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

class LandingController extends Controller {
  late BuildContext _ctx;

  @override
  construct(BuildContext context) {
    super.construct(context);
    _ctx = context;
  }
}
