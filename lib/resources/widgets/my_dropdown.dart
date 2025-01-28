import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/base.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class MyDropdownField extends StatelessWidget {
  const MyDropdownField({
    super.key,
    required this.controller,
    required this.name,
    required this.dataDropdown,
    required this.enable,
    required this.onSelected,
    this.errorText,
    this.placeholder,
  });

  final TextEditingController controller;
  final String name;
  final List<SelectedListItem<Base>> dataDropdown;
  final bool enable;
  final Function(SelectedListItem<Base>) onSelected;
  final String? placeholder;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<SelectedListItem>(
      enabled: enable,
      name: name,
      validator: FormBuilderValidators.required(errorText: errorText),
      builder: (field) {
        return Container(
          child: TextFormField(
            decoration: InputDecoration(
                enabled: enable,
                isDense: true,
                error: field.errorText != null
                    ? Text(
                        field.errorText!,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      )
                    : null,
                border: OutlineInputBorder(),
                filled: true,
                hintText: placeholder,
                fillColor: enable ? null : Colors.grey.shade300,
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
            controller: controller,
            readOnly: true,
            onTap: () {
              DropDownState<Base>(
                dropDown: DropDown<Base>(
                  useRootNavigator: true,
                  data: dataDropdown,
                  listItemBuilder: (index, dataItem) => Text(dataItem.data.nama ?? ''),
                  onSelected: (selectedItems) {
                    for (var item in selectedItems) {
                      controller.text = item.data.nama ?? '';
                      onSelected.call(item);
                      field.didChange(item);
                    }
                  },
                ),
              ).showModal(context);
            },
          ),
        );
      },
    );
  }
}
