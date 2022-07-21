![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)

# Jeodezi

Jeodezi is Dart version of [Jeodezi (which is Kotlin version)](https://github.com/bahadirarslan/Jeodezi) which is based of [Chris Veness](https://github.com/chrisveness)'s amazing work [Geodesy Functions](https://github.com/chrisveness/geodesy). [Geodesy Functions](https://github.com/chrisveness/geodesy) is written in JavaScript and contains dozens of functions to make calculations about:

> - Geodesic calculations (distances, bearings, etc) covering both spherical earth and ellipsoidal earth models, and both trigonometry-based and vector-based approaches.
> - Ellipsoidal-earth coordinate systems covering both historical datums and modern terrestrial reference frames (TRFs).
> - Mapping functions including UTM/MGRS and UK OS Grid References.

## Quick Links

- [Installation](#installation)
- [Usage](#usage)
- [Example](#example)
- [Contributing](#contributing)
- [Licence](#licence)

## Installation

Run the code below at terminal

```
dart pub add jeodezi
```

Or add the code below to your pubspec.yaml

```
dependencies:
    jeodezi: ^latest_version

```

## Usage

### Great Circle Calculations

#### Distance

To calculate distance between two geographical coordinate, distance method can be used. This method will calculate the distance between two points with [Haversine formula](https://en.wikipedia.org/wiki/Haversine_formula#:~:text=The%20haversine%20formula%20determines%20the,and%20angles%20of%20spherical%20triangles.). The result will be great circle distance in kilometers.

```dart
final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
final greatCircle = GreatCircle();
final distance = greatCircle.distance(istCoordinates, jfkCoordinates);
```

If you want to get distance in nautical miles you can use `distanceInNm` method with the same parameters

#### Bearing

This method is for the initial bearing (sometimes referred to as forward azimuth) which if followed in a straight line along a great-circle arc will take you from the start point to the end point. Bearing is in degrees 0° to 360°

```dart
final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
final greatCircle = GreatCircle();
final bearing = greatCircle.bearing(istCoordinates, jfkCoordinates);
```

#### Midpoint

This method calculates the midpoint between startPoint and endPoint on the great circle. Result type is Coordinate

```dart
final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
final greatCircle = GreatCircle();
final midpoint = greatCircle.midpoint(istCoordinates, jfkCoordinates);
```

#### Destination

This method calculates the destination point and final bearing travelling along a (shortest distance) great circle arc for a given start point, initial bearing and distance. Result type is Coordinate

```dart
final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
final greatCircle = GreatCircle();
final bearing = greatCircle.bearing(istCoordinates, jfkCoordinates);
final distance = 1000; // km
final destination = greatCircle.destination(istCoordinates, distance, bearing); // The coordinates of point which is at 1000th km great circle between Istanbul Airport and JFK Airport
```

#### Intermediate

This function returns the point at given fraction between startPoint and endPoint

```dart
final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
final fraction = 0.25;
final intermediate = greatCircle.intermediate(istCoordinates, jfkCoordinates, fraction);
```

#### Intersection

This function returns the point of intersection of two paths which one starts from firstPoint with firstBearing and the other one starts from secondPoint with secondBearing

```dart
final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
final fcoCoordinates = Coordinate(41.8002778,12.2388889); // The coordinates of Roma Fiumicino Airport
final bearingFromIstanbulToWest = 270.0;
final bearingFromRomeToNorthEast = 45.0;
final intersection = greatCircle.intersection(istCoordinates, bearingFromIstanbulToWest, fcoCoordinates, bearingFromRomeToNorthEast);
```

#### Cross Track

This function returns distance from currentPoint to great circle between startPoint and endPoint

```dart
final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
final fcoCoordinates = Coordinate(41.8002778,12.2388889); // The coordinates of Roma Fiumicino Airport
final crossTrackDistanceInKm = greatCircle.crossTrackDistance(fcoCoordinates, istCoordinates, jfkCoordinates);
```

#### Along Track

This function returns how far currentPoint is along a path from from startPoint, heading towards endPoint. That is, if a perpendicular is drawn from currentPoint point to the (great circle) path, the along-track distance is the distance from the start point to where the perpendicular crosses the path.

```dart
final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
final fcoCoordinates = Coordinate(41.8002778,12.2388889); // The coordinates of Roma Fiumicino Airport
final alongTrackDistanceTo = greatCircle.alongTrackDistanceTo(fcoCoordinates, istCoordinates, jfkCoordinates);
```

#### Max Latitudes

This function returns maximum latitude reached when travelling on a great circle on given bearing from startPoint point (‘Clairaut’s formula’). Negate the result for the minimum latitude (in the southern hemisphere)

```dart
final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
final bearingFromIstanbulToWest = 270.0;
final maxLatitude = greatCircle.maxLatitude(istCoordinates, bearingFromIstanbulToWest);
```

#### Crossing Parallels

This function returns the pair of meridians at which a great circle defined by two points crosses the given latitude. If the great circle doesn't reach the given latitude, null is returned.

```dart
final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
final latitude = 60.0; // means 60 degrees north
final crossingParallels = greatCircle.crossingParallels(istCoordinates, jfkCoordinates, latitude);
```

## Example

You can find an example application which uses Jeodezi library in the repo.

## Contributing

Jeodezi is a work in progress. Currently only a little part of functions of [Geodesy Functions](https://github.com/chrisveness/geodesy) are ported to Dart. There are lots to do and your contributions are most welcome. Feel free to fork the repo and submit Pull Request's.
You can help about

- Unit testing
- Better example
- Code refactoring and optimization
- Issues/bugs

## License

Jeodezi is released under the [MIT License](LICENSE.md).
