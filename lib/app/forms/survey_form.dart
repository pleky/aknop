import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* Survey Form
|--------------------------------------------------------------------------
| Usage: https://nylo.dev/docs/6.x/forms#how-it-works
| Casts: https://nylo.dev/docs/6.x/forms#form-casts
| Validation Rules: https://nylo.dev/docs/6.x/validation#validation-rules
|-------------------------------------------------------------------------- */

class SurveyForm extends NyFormData {
  SurveyForm({String? name}) : super(name ?? "survey");

  @override
  fields() => [
        Field.text("Judul Survey", style: "compact"),
        Field.picker(
          "Kota lokasi survey",
          options: ['Malang', 'Jombang'],
          style: 'compact',
        ),
        Field.picker(
          "Kategori Infra / Sungai",
          options: ['Malang', 'Jombang'],
          style: 'compact',
        ),
        Field.picker(
          "Bagian Yang di Amati",
          options: ['Malang', 'Jombang'],
          style: 'compact',
        ),
        Field.picker(
          "Kondisi Fisik",
          options: ['Malang', 'Jombang'],
          style: 'compact',
        ),
        Field.picker(
          "Kondisi Fungsi",
          options: ['Malang', 'Jombang'],
          style: 'compact',
        ),
        Field.textArea(
          "Tindakan Yang Diperlukan",
          style: "default",
        ),
        Field.textArea(
          "Taksir Volume",
          style: "default",
        ),
      ];
}
