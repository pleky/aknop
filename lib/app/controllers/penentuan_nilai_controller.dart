import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

class PenentuanNilaiController extends Controller {
  Map<String, dynamic> subHspIds = {};
  Map<String, dynamic> totalFields = {};

  @override
  construct(BuildContext context) {
    super.construct(context);
  }

  void setSubHspIds(List<int> ids, int index) {
    subHspIds['$index'] = ids;
  }

  void setTotalFields(int total, int index) {
    totalFields['$index'] = total;
  }
}
