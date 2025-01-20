import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/home_page.dart';
import 'package:flutter_app/resources/widgets/home_tab_widget.dart';
import 'package:flutter_app/resources/widgets/schedule_tab_widget.dart';
import 'package:nylo_framework/nylo_framework.dart';

class BaseNavigationHub extends NyStatefulWidget with BottomNavPageControls {
  static RouteView path = ("/base", (_) => BaseNavigationHub());

  BaseNavigationHub() : super(child: () => _BaseNavigationHubState(), stateName: path.stateName());

  /// State actions
  static NavigationHubStateActions stateActions = NavigationHubStateActions(path.stateName());
}

class _BaseNavigationHubState extends NavigationHub<BaseNavigationHub> {
  /// Layouts:
  /// - [NavigationHubLayout.bottomNav] Bottom navigation
  /// - [NavigationHubLayout.topNav] Top navigation
  NavigationHubLayout? layout = NavigationHubLayout.bottomNav(
      // backgroundColor: Colors.white,
      );

  /// Should the state be maintained
  @override
  bool get maintainState => true;

  /// Navigation pages
  _BaseNavigationHubState()
      : super(
          () async {
            return {
              0: NavigationTab(
                title: "Status Survey",
                page: HomeTab(), // create using: 'dart run nylo_framework:main make:stateful_widget home_tab'
                // page: HomePage(),
                icon: Icon(Icons.home),
                activeIcon: Icon(Icons.home),
              ),
              1: NavigationTab(
                title: "Jadwal Survey",
                page: ScheduleTab(),
                // page: SettingsTab(), // create using: 'dart run nylo_framework:main make:stateful_widget settings_tab'
                icon: Icon(Icons.calendar_month),
                activeIcon: Icon(Icons.calendar_month),
              ),
            };
          },
        );

  /// Handle the tap event
  @override
  onTap(int index) {
    super.onTap(index);
  }
}
