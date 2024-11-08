import 'objectbox.g.dart';
import 'tables/employee.dart';

class AppDatabase {
  late final Store _store;
  late final Box<Employee> _employeeBox;

  AppDatabase._create(this._store) {
    _employeeBox = Box<Employee>(_store);
  }

  static Future<AppDatabase> create() async {
    final store = await openStore();

    return AppDatabase._create(store);
  }

  List<Employee> getEmployees() => _employeeBox.getAll();

  int addEmployee(Employee employee) => _employeeBox.put(employee);

  void updateEmployee(Employee employee) => _employeeBox.put(employee);

  void deleteEmployee(Employee employee) => _employeeBox.remove(employee.id);

  void close() => _store.close();
}
