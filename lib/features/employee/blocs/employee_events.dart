part of 'bloc.dart';

abstract class EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final Employee employee;

  AddEmployee(this.employee);
}

class UpdateEmployee extends EmployeeEvent {
  final Employee employee;

  UpdateEmployee(this.employee);
}

class DeleteEmployee extends EmployeeEvent {
  final String employeeName;

  DeleteEmployee(this.employeeName);
}

class LoadEmployee extends EmployeeEvent {}
