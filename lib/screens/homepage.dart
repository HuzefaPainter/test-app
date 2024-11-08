import 'dart:math';

import 'package:employee_app/components/EmployeesList.dart';
import 'package:employee_app/employee_bloc_components/employee_bloc.dart';
import 'package:employee_app/employee_bloc_components/employee_events.dart';
import 'package:employee_app/employee_bloc_components/employee_states.dart';
import 'package:employee_app/models/employee.dart';
import 'package:employee_app/screens/employee_form.dart';
import 'package:employee_app/services/employee_services.dart';
import 'package:employee_app/ui_helpers/constants.dart';
import 'package:employee_app/ui_helpers/custom_toast.dart';
import 'package:employee_app/ui_helpers/test_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: GestureDetector(
                onLongPress: () async {
                  // testing feature for a long list without manually adding employees
                  Random r = Random();
                  List<Employee> testEmps = names.map((name) {
                    Employee e = Employee()
                      ..name = name
                      ..role = roles[r.nextInt(4)]
                      ..startDate = startDates[r.nextInt(19)]
                      ..endDate = endDates[r.nextInt(19)]
                      ..id = 0;
                    return e;
                  }).toList();
                  await EmployeeServices().addManyEmployees(testEmps);
                  context.read<EmployeeBloc>().add(LoadEmployees());
                },
                child: Text(widget.title)),
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            onPressed: () {
              Navigator.push(
                  context,
                  // ignore: prefer_const_constructors
                  MaterialPageRoute(builder: (context) => EmployeeForm()));
            },
            tooltip: 'Add Employee',
            child: SizedBox(
                height: 18,
                width: 18,
                child: SvgPicture.asset('images/icons/plus.svg')),
          ),
          body: state is EmployeeLoading
              ? const Center(child: CircularProgressIndicator())
              : state is EmployeeLoaded
                  ? EmployeesList(state: state, showToast: showToast)
                  : state is EmployeeError
                      ? Center(child: Text(state.message))
                      : Container(),
        );
      },
    );
  }

  showToast() {
    CustomToast.showToast(
      context,
      "Employee data has been deleted",
      3,
      endWidget: GestureDetector(
        onTap: () {
          context.read<EmployeeBloc>().add(RestoreLastEmployee());
        },
        child: const Text(
          "Undo",
          style: TextStyle(color: APP_BLUE, fontSize: 15),
        ),
      ),
    );
  }
}
