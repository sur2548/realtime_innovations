part of 'bloc.dart';

abstract class EmployeeState {}

class EmployeesLoading extends EmployeeState {}

class EmployeesLoaded extends EmployeeState {
  final List<Employee> employees;

  EmployeesLoaded(this.employees);
}

class EmployeeLoadingFailure extends EmployeeState {
  final String error;

  EmployeeLoadingFailure(this.error);
}

class EmployeeOperationSuccess extends EmployeeState {}

class EmployeeEditOperationSuccess extends EmployeeState {}


class EmployeeDeleteOperationSuccess extends EmployeeState {}

class EmployeeOperationFailure extends EmployeeState {
  final String error;

  EmployeeOperationFailure(this.error);
}
