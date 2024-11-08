import 'package:employee_app/models/employee.dart';
import 'package:employee_app/objectbox.g.dart';
import 'package:employee_app/services/db_service.dart';

class EmployeeServices {
  final Box<Employee> _empBox = ObjectBox.instance.store.box<Employee>();

  List<Employee> getAllEmployees() {
    try {
      return _empBox.getAll();
    } catch (e) {
      return [];
    }
  }

  Employee? getEmployee(int id) {
    try {
      return _empBox.get(id);
    } catch (e) {
      return null;
    }
  }

  bool deleteEmployee(int id) {
    try {
      return _empBox.remove(id);
    } catch (e) {
      return false;
    }
  }

  bool addOrUpdateEmployee(Employee e) {
    try {
      _empBox.put(e);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool addManyEmployees(List<Employee> e) {
    try {
      _empBox.putMany(e);
      return true;
    } catch (e) {
      return false;
    }
  }
  /* 
    Here its unclear as to current employees are ones without end date or
    ones with end dates but in the future. If its the latter its just a matter of changing 
    both methods below by comparing employees like:

    final query2 = _empBox.query(Employee_.endDate.isNull().or(Employee_.endDate
        .betweenDate(DateTime.now(), DateTime.now().add(Duration(days: 730)))))
      ..order(Employee_.startDate).build();

    And the reverse for past where I can check for any between now to millisecondsSinceEpoch(0)
    */

  List<Employee> getCurrentEmployees() {
    final query = (_empBox.query(Employee_.endDate.isNull())
          ..order(Employee_.startDate))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  List<Employee> getPastEmployees() {
    final query = (_empBox.query(Employee_.endDate.notNull())
          ..order(Employee_.startDate))
        .build();
    final results = query.find();
    query.close();
    return results;
  }
}
