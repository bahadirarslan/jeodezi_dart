import 'package:flutter_test/flutter_test.dart';
import 'package:jeodezi/coordinates.dart';

import 'package:jeodezi/jeodezi.dart';

final greatCircle = GreatCircle();
final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
final fcoCoordinates = Coordinate(41.8002778, 12.2388889); // The coordinates of Roma Fiumicino Airport
final sfoCoordinates = Coordinate(37.615223, -122.389977); // The coordinates of San Francisco SFO Airport
const delta = 1; // The delta for the tests
void main() {
  test('coordinate', () {
    final coordinate = Coordinate(41.28111111, 28.75333333);
    expect(coordinate.latitude, 41.28111111);
    expect(coordinate.longitude, 28.75333333);

    final coordinate2 = Coordinate.fromString('41.28111111, 28.75333333');
    expect(coordinate2.latitude, 41.28111111);
    expect(coordinate2.longitude, 28.75333333);
  });

  test('distance', () {
    final distance = greatCircle.distance(istCoordinates, jfkCoordinates);
    expect(distance, closeTo(8028, delta));
  });
  test('distance in nm', () {
    final distance = greatCircle.distanceInNm(istCoordinates, jfkCoordinates);
    expect(distance, closeTo(4335, delta));
  });

  test('bearing', () {
    final bearing = greatCircle.bearing(istCoordinates, jfkCoordinates);
    expect(bearing, closeTo(308, delta));
    final zeroBearing = greatCircle.bearing(istCoordinates, istCoordinates);
    expect(zeroBearing, 0.0);
  });

  test('final bearing', () {
    final finalBearing = greatCircle.finalBearing(istCoordinates, jfkCoordinates);
    expect(finalBearing, closeTo(230, delta));
  });

  test('mid point', () {
    final finalBearing = greatCircle.midpoint(istCoordinates, jfkCoordinates);
    expect(finalBearing.latitude, closeTo(54, delta));
    expect(finalBearing.longitude, closeTo(-22, delta));
  });
  test('intermediate', () {
    const fraction = 1.0;
    final intermediate = greatCircle.intermediate(startPoint: istCoordinates, endPoint: jfkCoordinates, fraction: fraction);
    expect(intermediate.latitude, closeTo(40, delta));
    expect(intermediate.longitude, closeTo(-73, delta));
  });

  test('destination', () {
    const bearingFromIstanbulToWest = 270.0;
    const distanceInKm = 168.0; //apprx 100 nm
    final destination = greatCircle.destination(
      startPoint: istCoordinates,
      bearing: bearingFromIstanbulToWest,
      distance: distanceInKm,
    );
    expect(destination.latitude, closeTo(41, delta));
    expect(destination.longitude, closeTo(26, delta));
  });

  test('intersection', () {
    const bearingFromIstanbulToWest = 270.0;
    var bearingFromRomeToNorthEast = 45.0;
    var intersection = greatCircle.intersection(
        firstPoint: istCoordinates, firstBearing: bearingFromIstanbulToWest, secondPoint: fcoCoordinates, secondBearing: bearingFromRomeToNorthEast);
    expect(intersection, null);
    bearingFromRomeToNorthEast = 90.0;
    intersection = greatCircle.intersection(
        firstPoint: istCoordinates, firstBearing: bearingFromIstanbulToWest, secondPoint: fcoCoordinates, secondBearing: bearingFromRomeToNorthEast);
    expect(intersection!.latitude, closeTo(41, delta));
    expect(intersection.longitude, closeTo(24, delta));
  });

  test('cross track', () {
    var crossTrackDistance = greatCircle.crossTrackDistance(
      currentPoint: fcoCoordinates,
      startPoint: istCoordinates,
      endPoint: jfkCoordinates,
    );
    expect(crossTrackDistance, closeTo(-704, delta));
    crossTrackDistance = greatCircle.crossTrackDistance(
      currentPoint: fcoCoordinates,
      startPoint: fcoCoordinates,
      endPoint: jfkCoordinates,
    );
    expect(crossTrackDistance, 0);
  });

  test('along cross track', () {
    var alongTrackDistanceTo = greatCircle.alongTrackDistanceTo(
      currentPoint: fcoCoordinates,
      startPoint: istCoordinates,
      endPoint: jfkCoordinates,
    );
    expect(alongTrackDistanceTo, closeTo(1182, delta));
    alongTrackDistanceTo = greatCircle.alongTrackDistanceTo(
      currentPoint: fcoCoordinates,
      startPoint: fcoCoordinates,
      endPoint: jfkCoordinates,
    );
    expect(alongTrackDistanceTo, 0);
  });

  test('max latitudes', () {
    const bearingFromIstanbulToWest = 270.0;
    final maxLatitude = greatCircle.maxLatitude(
      startPoint: istCoordinates,
      bearing: bearingFromIstanbulToWest,
    );
    expect(maxLatitude, closeTo(138, delta));
  });

  test('crossing parallels', () {
    var latitude = 80.0; // means 60 degrees north
    var crossingParallels = greatCircle.crossingParallels(
      startPoint: istCoordinates,
      endPoint: sfoCoordinates,
      latitude: latitude,
    );
    expect(crossingParallels.length, 0);
    latitude = 70.0; // means 60 degrees north
    crossingParallels = greatCircle.crossingParallels(
      startPoint: istCoordinates,
      endPoint: sfoCoordinates,
      latitude: latitude,
    );
    expect(crossingParallels.length, 2);
    expect(crossingParallels[0], closeTo(-12, delta));
    expect(crossingParallels[1], closeTo(-67, delta));
  });
}
