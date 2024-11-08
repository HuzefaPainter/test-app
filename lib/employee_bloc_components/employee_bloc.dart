import 'package:employee_app/employee_bloc_components/employee_events.dart';
import 'package:employee_app/employee_bloc_components/employee_states.dart';
import 'package:bloc/bloc.dart';
import 'package:employee_app/models/employee.dart';
import 'package:employee_app/services/employee_services.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  Employee? lastDeletedEmployee;

  EmployeeBloc() : super(EmployeeLoading()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<DeleteEmployee>(_onDeleteEmployee);
    on<RestoreLastEmployee>(_onRestoreLastEmployee);
  }

  void _onLoadEmployees(LoadEmployees event, Emitter<EmployeeState> emit) {
    try {
      EmployeeServices services = EmployeeServices();
      final currentEmployees = services.getCurrentEmployees();
      final previousEmployees = services.getPastEmployees();
      emit(EmployeeLoaded(currentEmployees, previousEmployees));
    } catch (e) {
      emit(EmployeeError("Failed to load employees"));
    }
  }

  void _onRestoreLastEmployee(
      RestoreLastEmployee event, Emitter<EmployeeState> emit) {
    try {
      if (lastDeletedEmployee != null) {
        EmployeeServices().addOrUpdateEmployee(lastDeletedEmployee!);
        lastDeletedEmployee = null;
        add(LoadEmployees());
      }
    } catch (e) {
      emit(EmployeeError("Failed to delete employee"));
    }
  }

  void _onDeleteEmployee(DeleteEmployee event, Emitter<EmployeeState> emit) {
    try {
      EmployeeServices().deleteEmployee(event.employeeId);
      add(LoadEmployees());
    } catch (e) {
      emit(EmployeeError("Failed to delete employee"));
    }
  }
}
