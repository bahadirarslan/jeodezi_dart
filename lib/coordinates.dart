import 'package:flutter/material.dart';
import 'package:jeodezi/extensions.dart';

class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate(this.latitude, this.longitude);

  double get latitudeInRadians => latitude.toRadians();
  double get longitudeInRadians => longitude.toRadians();

  @override
  bool operator ==(Object other) =>
      other is Coordinate && other.runtimeType == runtimeType && other.latitude == latitude && other.longitude == longitude;

  @override
  int get hashCode => hashValues(latitude, longitude);

  @override
  String toString() {
    // TODO: implement toString
    return "${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}";
  }
}
