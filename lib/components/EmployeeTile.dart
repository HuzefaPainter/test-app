import 'package:employee_app/employee_bloc_components/employee_bloc.dart';
import 'package:employee_app/employee_bloc_components/employee_events.dart';
import 'package:employee_app/models/employee.dart';
import 'package:employee_app/screens/employee_form.dart';
import 'package:employee_app/ui_helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class EmployeeTile extends StatelessWidget {
  final Employee employee;
  final Function showToast;
  const EmployeeTile(
      {super.key, required this.employee, required this.showToast});

  @override
  Widget build(BuildContext context) {
    bool isPrev = employee.endDate != null;
    return Dismissible(
        key: Key(employee.id.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          context.read<EmployeeBloc>().lastDeletedEmployee = employee;
          context.read<EmployeeBloc>().add(DeleteEmployee(employee.id));
          showToast();
        },
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SvgPicture.asset('images/icons/delete.svg'),
            ],
          ),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EmployeeForm(
                        employee: employee,
                      ))),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name ?? "",
                  style: const TextStyle(
                      fontSize: 16,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                      color: ALMOST_BLACK),
                ),
                const SizedBox(height: 6),
                Text(
                  employee.role ?? "",
                  style: const TextStyle(height: 1.42, color: HINT_TEXT_COLOR),
                ),
                const SizedBox(height: 6),
                Text(
                  "${!isPrev ? "From " : ""}${formatDate(employee.startDate!)}${isPrev ? " - ${formatDate(employee.endDate!)}" : ""}",
                  style: const TextStyle(height: 1.42, color: HINT_TEXT_COLOR),
                ),
              ],
            ),
          ),
        ));
  }

  String formatDate(DateTime date) {
    return DateFormat('d, MMM y').format(date);
  }
}
