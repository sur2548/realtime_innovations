import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)  // Assign a unique typeId
class Employee extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String role;

  @HiveField(3)
  DateTime startDate;

  @HiveField(4)
  DateTime? endDate;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.startDate,
    this.endDate,
  });
}