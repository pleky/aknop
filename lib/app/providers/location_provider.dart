import 'package:geolocator/geolocator.dart';
import 'package:nylo_framework/nylo_framework.dart';

class LocationProvider implements NyProvider {
  @override
  boot(Nylo nylo) async {
    // boot your provider
    // ...

    return nylo;
  }

  @override
  afterBoot(Nylo nylo) async {
    // Called after Nylo has finished booting
    // ...
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
