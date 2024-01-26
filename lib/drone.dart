import 'package:isar/isar.dart';
part "drone.g.dart";
@collection
class Drone {
  Id id = Isar.autoIncrement;
  String name;
  double price;
  String color;
  int velocity;
  int flightDuration;
  int camResolution;
  String imgUrl;
  Drone(
      {
      required this.name,
      required this.price,
      required this.color,
      required this.velocity,
      required this.flightDuration,
      required this.camResolution,
      required this.imgUrl});
}












