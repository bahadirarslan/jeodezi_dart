import 'package:flutter/material.dart';
import 'extensions.dart';

class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate(this.latitude, this.longitude);

  Coordinate.fromString(String coordinate)
      : assert(coordinate.isNotEmpty),
        assert(coordinate.contains(',')),
        latitude = double.parse(coordinate.split(',')[0]),
        longitude = double.parse(coordinate.split(',')[1]);

  double get latitudeInRadians => latitude.toRadians();
  double get longitudeInRadians => longitude.toRadians();

  @override
  bool operator ==(Object other) =>
      other is Coordinate &&
      other.runtimeType == runtimeType &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => hashValues(latitude, longitude);

  @override
  String toString() {
    return "${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}";
  }
}
