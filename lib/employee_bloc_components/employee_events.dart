abstract class EmployeeEvent {}

class LoadEmployees extends EmployeeEvent {}

class RestoreLastEmployee extends EmployeeEvent {}

class DeleteEmployee extends EmployeeEvent {
  final int employeeId; // or any unique identifier

  DeleteEmployee(this.employeeId);
}
