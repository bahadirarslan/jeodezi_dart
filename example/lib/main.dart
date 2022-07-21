import 'package:flutter/material.dart';
import 'package:jeodezi/coordinates.dart';
import 'package:jeodezi/jeodezi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExampleHomeScreen(),
    );
  }
}

class ExampleHomeScreen extends StatefulWidget {
  const ExampleHomeScreen({Key? key}) : super(key: key);

  @override
  State<ExampleHomeScreen> createState() => _ExampleHomeScreenState();
}

class _ExampleHomeScreenState extends State<ExampleHomeScreen> {
  final greatCircle = GreatCircle();
  final istCoordinates = Coordinate(41.28111111, 28.75333333); // The coordinates of Istanbul Airport
  final jfkCoordinates = Coordinate(40.63980103, -73.77890015); // The coordinates of New York JFK Airport
  final fcoCoordinates = Coordinate(41.8002778, 12.2388889); // The coordinates of Roma Fiumicino Airport
  final sfoCoordinates = Coordinate(37.615223, -122.389977); // The coordinates of San Francisco SFO Airport
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Center(
              child: Text(
                "Jeodezi Functions",
                style: TextStyle(fontSize: 40),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  final distance = greatCircle.distance(istCoordinates, jfkCoordinates);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Great Circle distance between Istanbul Airport and JFK Airport is ${distance.toStringAsFixed(2)} km"),
                  ));
                },
                child: const Text("Calculate Distance")),
            ElevatedButton(
                onPressed: () {
                  final distance = greatCircle.distanceInNm(istCoordinates, jfkCoordinates);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Great Circle distance between Istanbul Airport and JFK Airport is ${distance.toStringAsFixed(2)} nm"),
                  ));
                },
                child: const Text("Calculate Distance (Nm)")),
            ElevatedButton(
                onPressed: () {
                  final bearing = greatCircle.bearing(istCoordinates, jfkCoordinates);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("Initial bearing for great circle between Istanbul Airport and JFK Airport is ${bearing.toStringAsFixed(2)} degrees"),
                  ));
                },
                child: const Text("Bearing")),
            ElevatedButton(
                onPressed: () {
                  final bearing = greatCircle.finalBearing(istCoordinates, jfkCoordinates);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Final bearing for great circle between Istanbul Airport and JFK Airport is ${bearing.toStringAsFixed(2)} degrees"),
                  ));
                },
                child: const Text("Final Bearing")),
            ElevatedButton(
                onPressed: () {
                  final midpoint = greatCircle.midpoint(istCoordinates, jfkCoordinates);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Midpoint's coordinates of great circle between Istanbul Airport and JFK Airport are $midpoint "),
                  ));
                },
                child: const Text("Midpoint")),
            ElevatedButton(
                onPressed: () {
                  const fraction = 1.0;
                  final intermediate = greatCircle.intermediate(startPoint: istCoordinates, endPoint: jfkCoordinates, fraction: fraction);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "For $fraction fraction, intermediate point's coordinates of great circle between Istanbul Airport and JFK Airport are $intermediate "),
                  ));
                },
                child: const Text("Intermediate")),
            ElevatedButton(
                onPressed: () {
                  const bearingFromIstanbulToWest = 270.0;
                  const bearingFromRomeToNorthEast = 45.0;
                  final intersection = greatCircle.intersection(
                      firstPoint: istCoordinates,
                      firstBearing: bearingFromIstanbulToWest,
                      secondPoint: fcoCoordinates,
                      secondBearing: bearingFromRomeToNorthEast);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Intersection coordinates of from Istanbul Airport with bearing $bearingFromIstanbulToWest and from Roma Fiumicino Airport with bearing $bearingFromRomeToNorthEast is $intersection "),
                  ));
                },
                child: const Text("Intersection")),
            ElevatedButton(
                onPressed: () {
                  const bearingFromIstanbulToWest = 270.0;
                  const distanceInKm = 168.0; //apprx 100 nm
                  final destination = greatCircle.destination(
                    startPoint: istCoordinates,
                    bearing: bearingFromIstanbulToWest,
                    distance: distanceInKm,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "The destination coordinates of $distanceInKm km away from Istanbul Airport on bearing $bearingFromIstanbulToWest is $destination"),
                  ));
                },
                child: const Text("Destination")),
            ElevatedButton(
                onPressed: () {
                  final crossTrackDistance = greatCircle.crossTrackDistance(
                    currentPoint: fcoCoordinates,
                    startPoint: istCoordinates,
                    endPoint: jfkCoordinates,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Distance from Rome Fiumicino Airport to great circle between Istanbul Airport and JFK Airport is ${crossTrackDistance.toStringAsFixed(2)} km "),
                  ));
                },
                child: const Text("Cross Track")),
            ElevatedButton(
                onPressed: () {
                  final alongTrackDistanceTo = greatCircle.alongTrackDistanceTo(
                    currentPoint: fcoCoordinates,
                    startPoint: istCoordinates,
                    endPoint: jfkCoordinates,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Distance from Istanbul Airport to the point where Roma Fiumicino Airport crosses great circle between Istanbul Airport and JFK Airport is ${alongTrackDistanceTo.toStringAsFixed(2)} km "),
                  ));
                },
                child: const Text("Along Track")),
            ElevatedButton(
                onPressed: () {
                  const bearingFromIstanbulToWest = 270.0;
                  final maxLatitude = greatCircle.maxLatitude(
                    startPoint: istCoordinates,
                    bearing: bearingFromIstanbulToWest,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("The maximum latitude of the path from Istanbul Airport on bearing $bearingFromIstanbulToWest is $maxLatitude degrees"),
                  ));
                },
                child: const Text("Max Latitudes")),
            ElevatedButton(
                onPressed: () {
                  const latitude = 70.0; // means 70 degrees north
                  final crossingParallels = greatCircle.crossingParallels(
                    startPoint: istCoordinates,
                    endPoint: sfoCoordinates,
                    latitude: latitude,
                  );
                  if (crossingParallels.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("The great circle between Istanbul Airport and SFO Airport does not cross latitude $latitude"),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "The great circle between Istanbul Airport and SFO Airport crosses latitude $latitude at longitudes ${crossingParallels[0]} and ${crossingParallels[1]}"),
                    ));
                  }
                },
                child: const Text("Crossing Parallels")),
          ],
        ),
      ),
    );
  }
}
