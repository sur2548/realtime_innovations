import 'package:objectbox/objectbox.dart';

@Entity()
class Employee {
  @Id()
  int id = 0;
  String name;
  String role;
  DateTime startDate;
  DateTime? endDate;

  Employee({
    this.id = 0,
    required this.name,
    required this.role,
    required this.startDate,
    this.endDate,
  });
}
