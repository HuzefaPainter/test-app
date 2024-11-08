import 'dart:math';

import 'package:employee_app/components/EmployeeTile.dart';
import 'package:employee_app/components/HomepageHeading.dart';
import 'package:employee_app/employee_bloc_components/employee_states.dart';
import 'package:employee_app/ui_helpers/NoGlowConfiguration.dart';
import 'package:employee_app/ui_helpers/constants.dart';
import 'package:flutter/material.dart';

class EmployeesList extends StatelessWidget {
  final EmployeeLoaded state;
  final Function showSnackBar;
  const EmployeesList(
      {super.key, required this.state, required this.showSnackBar});

  @override
  Widget build(BuildContext context) {
    if (state.currentEmployees.isEmpty && state.previousEmployees.isEmpty) {
      return const NoEmployeesState();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: NoGlowConfiguration(
                child: SingleChildScrollView(
              child: Column(children: [
                state.currentEmployees.isNotEmpty
                    ? const HomepageHeading(text: "Current employees")
                    : const SizedBox.shrink(),
                ...ListTile.divideTiles(
                    context: context,
                    tiles: state.currentEmployees.map((e) =>
                        EmployeeTile(employee: e, showToast: showSnackBar))),
                state.previousEmployees.isNotEmpty
                    ? const HomepageHeading(text: "Previous employees")
                    : const SizedBox.shrink(),
                ...ListTile.divideTiles(
                    context: context,
                    tiles: state.previousEmployees.map((e) => EmployeeTile(
                          employee: e,
                          showToast: showSnackBar,
                        )))
              ]),
            )),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 76,
            color: const Color(0xfff2f2f2),
            padding: const EdgeInsets.only(left: 16, top: 12),
            child: const Text(
              "Swipe left to delete",
              style:
                  TextStyle(color: HINT_TEXT_COLOR, fontSize: 15, height: 1.33),
            ),
          ),
        ],
      );
    }
  }
}

class NoEmployeesState extends StatelessWidget {
  const NoEmployeesState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            //unsure what was meant 'pixel-perfect' in the asgn. Whether to scale spacing acc. to resolution or not.
            // Responsiveness wasn't mentioned hence proceeding by making it look same sized image, regardless of phone size.
            // else would've used 'sizer' package and set everything accordingly.
            //Bad example below, but would've used sizer here and compared stuff accordingly like so:
            width: min(262, MediaQuery.of(context).size.width),
            height: 244,
            child: Image.asset('images/no-employees.png'),
          ),
        )
      ],
    );
  }
}
