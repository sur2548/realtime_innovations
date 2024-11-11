import 'package:hive_flutter/adapters.dart';

import 'tables/employee.dart';

class AppDatabase {
  static const String _boxName = 'employeeBox';
  late final Box<Employee> _employeeBox;

  AppDatabase._create(this._employeeBox);

  static Future<AppDatabase> create() async {
    await Hive.initFlutter(); // Initialize Hive for Flutter
    Hive.registerAdapter(EmployeeAdapter()); // Register the Employee adapter
    final employeeBox = await Hive.openBox<Employee>(_boxName);

    return AppDatabase._create(employeeBox);
  }

  List<Employee> getEmployees() => _employeeBox.values.toList();

  int addEmployee(Employee employee) {
    employee.id = _employeeBox.length + 1; // Assign a unique ID
    _employeeBox.put(employee.id, employee);
    return employee.id;
  }

  void updateEmployee(Employee employee) => _employeeBox.put(employee.id, employee);

  void deleteEmployee(Employee employee) => _employeeBox.delete(employee.id);

  void close() => _employeeBox.close();
}
