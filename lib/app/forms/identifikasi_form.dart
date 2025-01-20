import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* Identifikasi Form
|--------------------------------------------------------------------------
| Usage: https://nylo.dev/docs/6.x/forms#how-it-works
| Casts: https://nylo.dev/docs/6.x/forms#form-casts
| Validation Rules: https://nylo.dev/docs/6.x/validation#validation-rules
|-------------------------------------------------------------------------- */

class IdentifikasiForm extends NyFormData {
  IdentifikasiForm({String? name}) : super(name ?? "identifikasi");

  @override
  fields() => [
        Field.text("Judul Masalah", style: "compact"),
        Field.text("Judul Masalah", style: "compact"),
        Field.text("Judul Masalah", style: "compact"),
      ];
}
