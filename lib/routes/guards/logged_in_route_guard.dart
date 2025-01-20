import 'package:nylo_framework/nylo_framework.dart';

/* LoggedIn Route Guard
|-------------------------------------------------------------------------- */

class LoggedInRouteGuard extends NyRouteGuard {
  LoggedInRouteGuard();

  @override
  onRequest(PageRequest pageRequest) async {
    // example
    // if (Auth.isAuthenticated() == false) {
    //    return redirect(HomePage.path);
    // }
    //
    // helpers
    // data = will give you access to the data passed to the route
    // context = will give you access to the BuildContext
    return pageRequest;
  }
}
