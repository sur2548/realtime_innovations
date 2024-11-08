part of 'bloc.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  EmployeeCubit() : super(EmployeesLoading());

  final _objectBoxStore =  locator<AppDatabase>();
  Employee? _recentlyDeletedEmployee;

  void loadEmployees() {
    emit(EmployeesLoading());
    try {
      final employees = _objectBoxStore.getEmployees();
      emit(EmployeesLoaded(employees));
    } catch (e) {
      emit(EmployeeLoadingFailure('Error loading employees: $e'));
    }
  }

  void addEmployee(Employee employee) {
    try {
      _objectBoxStore.addEmployee(employee);
      emit(EmployeeOperationSuccess());
      loadEmployees();
    } catch (e) {
      emit(EmployeeOperationFailure('Error adding employee: $e'));
    }
  }

  void updateEmployee(Employee employee) {
    try {
      _objectBoxStore.updateEmployee(employee);
      loadEmployees();
      emit(EmployeeEditOperationSuccess());
    } catch (e) {
      emit(EmployeeOperationFailure('Error updating employee: $e'));
    }
  }

  void deleteEmployee(Employee employee) {
    try {
      _recentlyDeletedEmployee = employee;
      _objectBoxStore.deleteEmployee(employee);
      emit(EmployeeDeleteOperationSuccess());
      loadEmployees();
    } catch (e) {
      emit(EmployeeOperationFailure('Error deleting employee: $e'));
    }
  }

  void undoDelete() {
    if (_recentlyDeletedEmployee != null) {
      addEmployee(_recentlyDeletedEmployee!);
      _recentlyDeletedEmployee = null; // Clear the temporary storage
    }
  }

  @override
  Future<void> close() async {
    _objectBoxStore.close();
    return super.close();
  }
}
