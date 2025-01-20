import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/form_survey_page.dart';
import 'package:flutter_app/resources/pages/home_page.dart';
import 'package:flutter_app/resources/pages/schedule_page.dart';
import 'package:flutter_app/resources/widgets/buttons/buttons.dart';
import 'package:nylo_framework/nylo_framework.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  createState() => _HomeTabState();
}

class _HomeTabState extends NyState<HomeTab> {
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
                        routeTo(FormSurveyPage.path);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Color(0xFF3D67B1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Project: Mata Air Gunung Putri').titleLarge(color: Colors.white),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text('Status :').bodyLarge(color: Colors.white),
                                SizedBox(width: 12),
                                Chip(
                                  label:
                                      Text('Selesai').bodyLarge(color: Color(0xFF3D67B1), fontWeight: FontWeight.w600),
                                  shape: StadiumBorder(side: BorderSide(color: Colors.white)),
                                  padding: EdgeInsets.all(0),
                                  visualDensity: VisualDensity(vertical: -1),
                                )
                              ],
                            )
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
