import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

class PenentuanNilaiController extends Controller {
  Map<String, dynamic> subHspIds = {};
  Map<String, dynamic> totalFields = {};

  @override
  bool get singleton => true;

  @override
  construct(BuildContext context) {
    super.construct(context);
  }

  void setSubHspIds(List<dynamic>? ids, int index) {
    subHspIds['$index'] = ids;
  }

  void setTotalFields(dynamic total, dynamic index) {
    print('total: $total -> $index');
    totalFields['$index'] = total;
  }
}
