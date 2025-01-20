import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter_app/app/models/base.dart';
import 'package:flutter_app/app/networking/master_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

class FormSurveyController extends Controller {
  @override
  construct(BuildContext context) async {
    super.construct(context);
  }

  // void getSungai(id) async {
  //   await api<MasterApiService>(
  //     (request) => request.getAllSungai(id),
  //     onSuccess: (response, data) {
  //       updateState(
  //         'sungai_state',
  //         data: {
  //           "sungai": (data as List<Base>).map((element) {
  //             return SelectedListItem(data: element);
  //           }).toList()
  //         },
  //       );
  //     },
  //   );
  // }
}
