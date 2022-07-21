library jeodezi;

import 'dart:math';

import 'extensions.dart';
import 'coordinates.dart';

/// Earth radius in kilometers.
const double earthRadiusKm = 6372.8;
const double kmToNm = 1 / 1.852;

/// A great circle, also known as an orthodrome, of a sphere is the intersection of the sphere and
/// a plane that passes through the center point of the sphere. A great circle is the largest circle
/// that can be drawn on any given sphere. (Wikipedia)
/// This library contains functions about great circle for calculation, bearings, distances or midpoints.
/// All these functions are taken from Chris Veness(https://github.com/chrisveness)'s amazing work
/// Geodesy Functions(https://github.com/chrisveness/geodesy) and ported to Kotlin.
/// Some of comments are copied from original library
class GreatCircle {
  /// Haversine formula. Giving great-circle distances between two points on a sphere from their longitudes and latitudes.
  /// It is a special case of a more general formula in spherical trigonometry, the law of haversines, relating the
  /// sides and angles of spherical "triangles".
  ///
  /// [ref link]: https://rosettacode.org/wiki/Haversine_formula#Java
  /// Based on [ref link]: https://gist.github.com/jferrao/cb44d09da234698a7feee68ca895f491
  ///  startPoint Initial coordinates
  ///  endPoint Final coordinates
  /// @return Distance in kilometers
  ///
  /// ```dart
  /// final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
  /// final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
  /// final greatCircle = GreatCircle();
  /// final distance = greatCircle.distance(istCoordinates, jfkCoordinates);
  /// ```
  double distance(Coordinate startPoint, Coordinate endPoint) {
    final double lat1 = startPoint.latitude;
    final double lat2 = endPoint.latitude;
    final double lon1 = startPoint.longitude;
    final double lon2 = endPoint.longitude;
    final double dLat = (lat2 - lat1).toRadians();
    final double dLon = (lon2 - lon1).toRadians();
    final double a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) * cos(lat1.toRadians()) * cos(lat2.toRadians());
    final double c = 2 * asin(sqrt(a));
    return earthRadiusKm * c;
  }

  /// Haversine formula. Giving great-circle distances between two points on a sphere from their longitudes and latitudes.
  /// It is a special case of a more general formula in spherical trigonometry, the law of haversines, relating the
  /// sides and angles of spherical "triangles".
  ///
  /// [ref link]: https://rosettacode.org/wiki/Haversine_formula#Java
  ///
  /// [startPoint] Initial coordinates
  /// [endPoint] Final coordinates
  /// Returns distance in nautical miles
  ///
  /// ```dart
  /// final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
  /// final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
  /// final greatCircle = GreatCircle();
  /// final distance = greatCircle.distanceInNm(istCoordinates, jfkCoordinates);
  /// ```
  double distanceInNm(Coordinate startPoint, Coordinate endPoint) {
    return distance(startPoint, endPoint) * kmToNm;
  }

  /// This function is for the initial bearing (sometimes referred to as forward azimuth) which if
  /// followed in a straight line along a great-circle arc will take you from the start point to the end point
  ///
  ///
  /// [startPoint] Initial coordinates
  /// [endPoint] Final coordinates
  /// Returns Bearing in degrees from North, 0° ... 360°
  ///
  /// ```dart
  /// final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
  /// final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
  /// final greatCircle = GreatCircle();
  /// final bearing = greatCircle.bearing(istCoordinates, jfkCoordinates);
  /// ```
  double bearing(Coordinate startPoint, Coordinate endPoint) {
    if (startPoint == endPoint) return 0.0;
    final double lat1 = startPoint.latitude.toRadians();
    final double lat2 = endPoint.latitude.toRadians();
    final double lon1 = startPoint.longitude.toRadians();
    final double lon2 = endPoint.longitude.toRadians();
    final double dLon = lon2 - lon1;
    final double y = sin(dLon) * cos(lat2);
    final double x =
        (cos(lat1) * sin(lat2)) - (sin(lat1) * cos(lat2) * cos(dLon));
    final double bearing = atan2(y, x).toDegrees().wrap360();
    return bearing;
  }

  /// This function returns final bearing arriving at destination point from startPoint; the final
  /// bearing will differ from the initial bearing by varying degrees according to distance and latitude
  ///
  ///
  /// [startPoint] Initial coordinates
  /// [endPoint] Final coordinates
  /// Returns Bearing in degrees from North, 0° ... 360°
  double finalBearing(Coordinate startPoint, Coordinate endPoint) {
    final bearingValue = bearing(endPoint, startPoint) + 180;
    return bearingValue.wrap360();
  }

  /// This function calculates the midpoint between startPoint and endPoint
  ///
  /// [startPoint] Initial coordinates
  /// [endPoint] Final coordinates
  /// Returns Midpoint coordinates
  ///
  /// ```dart
  /// final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
  /// final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
  /// final greatCircle = GreatCircle();
  /// final midpoint = greatCircle.midpoint(istCoordinates, jfkCoordinates);
  /// ```
  Coordinate midpoint(Coordinate startPoint, Coordinate endPoint) {
    final double lat1 = startPoint.latitude.toRadians();
    final double lat2 = endPoint.latitude.toRadians();
    final double lon1 = startPoint.longitude.toRadians();
    final double lon2 = endPoint.longitude.toRadians();
    final double dLon = lon2 - lon1;
    final double bX = cos(lat2) * cos(dLon);
    final double bY = cos(lat2) * sin(dLon);

    final double lat = atan2((sin(lat1) + sin(lat2)),
        sqrt((cos(lat1) + bX) * (cos(lat1) + bX) + bY * bY));
    final double lon = lon1 + atan2(bY, cos(lat1) + bX);
    return Coordinate(lat.toDegrees(), lon.toDegrees());
  }

  /// This function returns the point at given fraction between startPoint and endPoint
  ///
  /// [startPoint] Initial coordinates
  /// [endPoint] Final coordinates
  /// [fraction] Fraction between coordinates
  /// Returns Intermediate coordinates between startPoint and endPoint
  ///
  /// ```dart
  /// final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
  /// final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
  /// final fraction = 0.25;
  /// final intermediate = greatCircle.intermediate(istCoordinates, jfkCoordinates, fraction);
  /// ```
  Coordinate intermediate(
      {required Coordinate startPoint,
      required Coordinate endPoint,
      required double fraction}) {
    if (startPoint == endPoint) return startPoint;

    final double lat1 = startPoint.latitude.toRadians();
    final double lat2 = endPoint.latitude.toRadians();
    final double lon1 = startPoint.longitude.toRadians();
    final double lon2 = endPoint.longitude.toRadians();

    final double dLon = lon2 - lon1;
    final double dLat = lat2 - lat1;
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final double A = sin((1 - fraction) * c) / sin(c);
    final double B = sin(fraction * c) / sin(c);
    final double x = A * cos(lat1) * cos(lon1) + B * cos(lat2) * cos(lon2);
    final double y = A * cos(lat1) * sin(lon1) + B * cos(lat2) * sin(lon2);
    final double z = A * sin(lat1) + B * sin(lat2);

    final double lat = atan2(z, sqrt(x * x + y * y));
    final double lon = atan2(y, x);

    return Coordinate(lat.toDegrees(), lon.toDegrees());
  }

  /// This function returns the point of intersection of two paths which one starts from firstPoint
  /// with firstBearing and the other one starts from secondPoint with secondBearing
  ///
  /// [firstPoint] First point coordinates
  /// [firstBearing] First path's bearing
  /// [secondPoint] Second point coordinates
  /// [secondBearing] Second path's bearing
  /// Returns Intersections coordinates of two paths or return null if there is no intersection
  ///
  /// ```dart
  /// final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
  /// final fcoCoordinates = Coordinate(41.8002778,12.2388889); // The coordinates of Roma Fiumicino Airport
  /// final bearingFromIstanbulToWest = 270.0;
  /// final bearingFromRomeToNorthEast = 45.0;
  /// final intersection = greatCircle.intersection(istCoordinates, bearingFromIstanbulToWest, fcoCoordinates, bearingFromRomeToNorthEast);
  /// ```
  Coordinate? intersection(
      {required Coordinate firstPoint,
      required double firstBearing,
      required Coordinate secondPoint,
      required double secondBearing}) {
    final double lat1 = firstPoint.latitude.toRadians();
    final double lon1 = firstPoint.longitude.toRadians();
    final double lat2 = secondPoint.latitude.toRadians();
    final double lon2 = secondPoint.longitude.toRadians();

    final double dLon = lon2 - lon1;
    final double dLat = lat2 - lat1;

    final double delta12 = 2 *
        asin(sqrt(sin(dLat / 2) * sin(dLat / 2) +
            cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2)));

    final double cosTetaa =
        (sin(lat2) - sin(lat1) * cos(delta12)) / (sin(delta12) * cos(lat1));
    final double cosTetab =
        (sin(lat1) - sin(lat2) * cos(delta12)) / (sin(delta12) * cos(lat2));
    final double tetaa = acos(cosTetaa);
    final double tetab = acos(cosTetab);

    final double teta12 = sin(lon2 - lon1) > 0 ? tetaa : (2 * pi - tetaa);
    final double teta21 = sin(lon2 - lon1) > 0 ? (2 * pi - tetab) : tetab;

    final double alpha1 = firstBearing.toRadians() - teta12;
    final double alpha2 = teta21 - secondBearing.toRadians();

    if (sin(alpha1) == 0.0 && sin(alpha2) == 0.0) return null;
    if (sin(alpha1) * sin(alpha2) < 0) return null;

    final double cosAlpha3 =
        -cos(alpha1) * cos(alpha2) + sin(alpha1) * sin(alpha2) * cos(delta12);
    final double delta13 = atan2(sin(delta12) * sin(alpha1) * sin(alpha2),
        cos(alpha2) + cos(alpha1) * cosAlpha3);

    final double lat = asin(min(
        max(
            sin(lat1) * cos(delta13) +
                cos(lat1) * sin(delta13) * cos(firstBearing.toRadians()),
            -1),
        1));
    final double deltaLon13 = atan2(
        sin(firstBearing.toRadians()) * sin(delta13) * cos(lat1),
        cos(delta13) - sin(lat1) * sin(lat));
    final double lon = lon1 + deltaLon13;

    return Coordinate(lat.toDegrees(), lon.toDegrees());
  }

  /// This function calculates the destination point and final bearing travelling along a
  /// (shortest distance) great circle arc for a given start point, initial bearing and distance
  ///
  ///
  /// [startPoint] Initial coordinates
  /// [distance] Distance on great circle
  /// [bearing] Bearing
  /// Returns Destination coordinates
  ///
  /// ```dart
  /// final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
  /// final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
  /// final greatCircle = GreatCircle();
  /// final bearing = greatCircle.bearing(istCoordinates, jfkCoordinates);
  ///
  /// final distance = 1000; // km
  /// final destination = greatCircle.destination(istCoordinates, distance, bearing); // The coordinates of point which is at 1000th km great circle between Istanbul Airport and JFK Airport
  /// ```
  Coordinate destination(
      {required Coordinate startPoint,
      required double bearing,
      required double distance}) {
    final double lat1 = startPoint.latitude.toRadians();
    final double lon1 = startPoint.longitude.toRadians();

    final double sinLat = sin(lat1) * cos(distance / earthRadiusKm) +
        cos(lat1) * sin(distance / earthRadiusKm) * cos(bearing.toRadians());
    final double lat = asin(sinLat);

    final double y =
        sin(bearing.toRadians()) * sin(distance / earthRadiusKm) * cos(lat1);
    final double x = cos(distance / earthRadiusKm) - sin(lat1) * sin(lat);

    final lon = lon1 + atan2(y, x);
    return Coordinate(lat.toDegrees(), lon.toDegrees());
  }

  ///
  /// This function returns distance from currentPoint to great circle between startPoint and endPoint
  ///
  /// [currentPoint] The point whose distance is wondering to great circle
  /// [startPoint] Start of the great circle
  /// [endPoint] End of the great circle
  /// Returns Distance to the great circle. If returns positive this means right of the path, otherwise it means left of the path.
  ///
  /// ```dart
  /// final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
  /// final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
  /// final fcoCoordinates = Coordinate(41.8002778,12.2388889); // The coordinates of Roma Fiumicino Airport
  /// final crossTrackDistanceInKm = greatCircle.crossTrackDistance(fcoCoordinates, istCoordinates, jfkCoordinates);
  /// ```
  double crossTrackDistance(
      {required Coordinate currentPoint,
      required Coordinate startPoint,
      required Coordinate endPoint}) {
    if (currentPoint == startPoint) return 0;

    final double delta13 = distance(startPoint, currentPoint) / earthRadiusKm;
    final double teta13 = bearing(startPoint, currentPoint).toRadians();
    final double teta12 = bearing(startPoint, endPoint).toRadians();

    final double deltaCrossTrack = asin(sin(delta13) * sin(teta13 - teta12));

    return deltaCrossTrack * earthRadiusKm;
  }

  /// This function returns how far currentPoint is along a path from from startPoint, heading towards endPoint.
  /// That is, if a perpendicular is drawn from currentPoint point to the (great circle) path, the
  /// along-track distance is the distance from the start point to where the perpendicular crosses the path.
  ///
  ///
  /// [currentPoint] The point whose distance is wondering to great circle
  /// [startPoint] Start of the great circle
  /// [endPoint] End of the great circle
  /// Returns Distance along great circle to point nearest currentPoint point.
  ///
  /// ```dart
  /// final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
  /// final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
  /// final fcoCoordinates = Coordinate(41.8002778,12.2388889); // The coordinates of Roma Fiumicino Airport
  /// final alongTrackDistanceTo = greatCircle.alongTrackDistanceTo(fcoCoordinates, istCoordinates, jfkCoordinates);
  /// ```
  double alongTrackDistanceTo(
      {required Coordinate currentPoint,
      required Coordinate startPoint,
      required Coordinate endPoint}) {
    if (currentPoint == startPoint) return 0;

    final double delta13 = distance(startPoint, currentPoint) / earthRadiusKm;
    final double teta13 = bearing(startPoint, currentPoint).toRadians();
    final double teta12 = bearing(startPoint, endPoint).toRadians();

    final double deltaCrossTrack = asin(sin(delta13) * sin(teta12 - teta13));
    final double deltaAlongTrack =
        acos(cos(delta13) / cos(deltaCrossTrack).abs());

    return deltaAlongTrack * cos(teta12 - teta13).sign * earthRadiusKm;
  }

  /// This function returns maximum latitude reached when travelling on a great circle on given bearing from
  /// startPoint point (‘Clairaut’s formula’). Negate the result for the minimum latitude (in the
  /// southern hemisphere).
  ///
  /// The maximum latitude is independent of longitude; it will be the same for all points on a
  /// given latitude.
  ///
  /// [startPoint] Initial coordinates
  /// [bearing] Bearing
  /// Returns Destination coordinates
  ///
  /// ```dart
  /// final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
  /// final bearingFromIstanbulToWest = 270.0;
  /// final maxLatitude = greatCircle.maxLatitude(istCoordinates, bearingFromIstanbulToWest);
  /// ```
  double maxLatitude(
      {required Coordinate startPoint, required double bearing}) {
    return acos(sin(bearing.toRadians()) * cos(startPoint.latitude.toRadians()))
        .toDegrees();
  }

  /// This function returns the pair of meridians at which a great circle defined by two points crosses the given
  /// latitude. If the great circle doesn't reach the given latitude, empty list is returned.
  ///
  /// The maximum latitude is independent of longitude; it will be the same for all points on a
  /// given latitude.
  ///
  /// [startPoint] Initial coordinates
  /// [endPoint] Final coordinates
  /// [latitude] Latitude crossings are to be determined for.
  /// Returns Array containing { lon1, lon2 } or null if given latitude not reached.
  ///
  /// ```dart
  /// final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
  /// final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
  /// final latitude = 60.0; // means 60 degrees north
  /// final crossingParallels = greatCircle.crossingParallels(istCoordinates, jfkCoordinates, latitude);
  /// ```
  List<double> crossingParallels(
      {required Coordinate startPoint,
      required Coordinate endPoint,
      required double latitude}) {
    if (startPoint == endPoint) return [];
    final latInRads = latitude.toRadians();
    final lat1 = startPoint.latitude.toRadians();
    final lat2 = endPoint.latitude.toRadians();
    final lon1 = startPoint.longitude.toRadians();
    final lon2 = endPoint.longitude.toRadians();

    final double deltaLon = lon2 - lon1;
    final double x = sin(lat1) * cos(lat2) * cos(latInRads) * sin(deltaLon);
    final double y = sin(lat1) * cos(lat2) * cos(latInRads) * cos(deltaLon) -
        cos(lat1) * sin(lat2) * cos(latInRads);
    final double z = cos(lat1) * cos(lat2) * sin(latInRads) * sin(deltaLon);

    if (z * z > x * x + y * y) return [];

    final double deltaM = atan2(-y, x);
    final double deltaLoni = acos(z / sqrt(x * x + y * y));

    final double deltaI1 = lon1 + deltaM - deltaLoni;
    final double deltaI2 = lat1 + deltaM + deltaLoni;

    return [deltaI1.toDegrees().wrap180(), deltaI2.toDegrees().wrap180()];
  }
}
