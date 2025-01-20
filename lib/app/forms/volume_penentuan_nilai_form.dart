import 'package:nylo_framework/nylo_framework.dart';

/* VolumePenentuanNilai Form
|--------------------------------------------------------------------------
| Usage: https://nylo.dev/docs/6.x/forms#how-it-works
| Casts: https://nylo.dev/docs/6.x/forms#form-casts
| Validation Rules: https://nylo.dev/docs/6.x/validation#validation-rules
|-------------------------------------------------------------------------- */

class VolumePenentuanNilaiForm extends NyFormData {
  VolumePenentuanNilaiForm({String? name}) : super(name ?? "volume_penentuan_nilai");

  @override
  fields() => [
        Field.text("Volume Penentuan Nilai", style: "compact"),
        Field.picker(
          "HSP",
          options: ["Rp.1000", "Rp. 2000", "Rp. 3000"],
          style: "compact",
        ),
      ];
}
