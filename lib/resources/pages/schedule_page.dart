import 'package:flutter/material.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/app/controllers/schedule_controller.dart';

class SchedulePage extends NyStatefulWidget<ScheduleController> {
  static RouteView path = ("/schedule", (_) => SchedulePage());

  SchedulePage({super.key}) : super(child: () => _SchedulePageState());
}

class _SchedulePageState extends NyState<SchedulePage> {
  /// [ScheduleController] controller
  ScheduleController get controller => widget.controller;

  @override
  get init => () {};

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project: Mata Air Gunung Putri"),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Text('Lokasi: Sukabumi, Jawa Barat').displaySmall(fontSize: 20),
              Text('Jumlah Tim : 20 Orang').displaySmall(fontSize: 20),
              SizedBox(height: 20),
              Text('Mulai Project : 11 Januari 2025').bodyLarge(),
              Text('Selesai Project : 30 Maret 2025').bodyLarge(),
              Spacer(),
              Button.primary(text: "Mulai Proyek"),
              SizedBox(height: 8),
              Button.outlined(text: "Batal"),
            ],
          ),
        ),
      ),
    );
  }
}
