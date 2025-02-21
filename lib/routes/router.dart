import '/resources/pages/detail_survey_page.dart';
import '/resources/pages/survey_list_page.dart';
import '/resources/pages/survey_list_page.dart';
import '/resources/pages/summary_page.dart';
import '/resources/pages/volume_penentuan_nilai_page.dart';
import '/resources/pages/penentuan_nilai_page.dart';
import '/resources/pages/identifikasi_page.dart';
import '/resources/pages/drawing_map_page.dart';
import '/resources/pages/form_survey_page.dart';
import 'package:flutter_app/routes/guards/logged_in_route_guard.dart';

import '/resources/pages/schedule_page.dart';
import '/resources/pages/base_navigation_hub.dart';
import '/resources/pages/login_page.dart';
import '/resources/pages/landing_page.dart';
import '/resources/pages/not_found_page.dart';
import '/resources/pages/home_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
|
| * [Tip] Add authentication 🔑
| Run the below in the terminal to add authentication to your project.
| "dart run scaffold_ui:main auth"
|
| Learn more https://nylo.dev/docs/6.x/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
      router.add(LandingPage.path).initialRoute();
      router.add(LoginPage.path);
      router.group(
          () => {
                'route_guards': [LoggedInRouteGuard()],
                'prefix': '/dashboard'
              }, (router) {
        router.add(BaseNavigationHub.path);
        router.add(HomePage.path);
        router.add(SchedulePage.path);
        router.add(FormSurveyPage.path);
        router.add(DrawingMapPage.path);
        router.add(PenentuanNilaiPage.path);
        router.add(IdentifikasiPage.path);
        router.add(SummaryPage.path);
        router.add(VolumePenentuanNilaiPage.path);
        router.add(DetailSurveyPage.path);
      });
      router.add(NotFoundPage.path).unknownRoute();
      router.add(SurveyListPage.path, authenticatedRoute: true);
    });
