import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/schedule_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ScheduleTab extends StatefulWidget {
  const ScheduleTab({super.key});

  @override
  createState() => _ScheduleTabState();
}

class _ScheduleTabState extends NyState<ScheduleTab> {
  @override
  get init => () {};

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              SizedBox(
                height: 36,
              ),
              Row(
                children: [
                  Text('HI, Sowon').displayLarge(fontWeight: FontWeight.w600),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {},
                  )
                ],
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: 15,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        routeTo(SchedulePage.path);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          // color:
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: Color(0xFF3D67B1),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Project: Mata Air Gunung Putri').titleLarge(),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text('Jadwal Project: ').titleMedium(),
                                SizedBox(width: 12),
                                Text('11 Januari 2025').titleMedium(),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Selesai Project: ').titleMedium(),
                                SizedBox(width: 12),
                                Text('30 Maret 2025').titleMedium(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
