import 'package:employee_app/models/employee.dart';

abstract class EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> currentEmployees;
  final List<Employee> previousEmployees;

  EmployeeLoaded(this.currentEmployees, this.previousEmployees);
}

class EmployeeError extends EmployeeState {
  final String message;

  EmployeeError(this.message);
}
