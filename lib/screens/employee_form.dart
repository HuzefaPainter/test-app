// ignore_for_file: use_build_context_synchronously

import 'package:employee_app/components/custom_calendar_components/CustomCalendarWidget.dart';
import 'package:employee_app/components/custom_calendar_components/shared/utils.dart';
import 'package:employee_app/components/form_field_components.dart';
import 'package:employee_app/employee_bloc_components/employee_bloc.dart';
import 'package:employee_app/employee_bloc_components/employee_events.dart';
import 'package:employee_app/models/employee.dart';
import 'package:employee_app/services/employee_services.dart';
import 'package:employee_app/ui_helpers/constants.dart';
import 'package:employee_app/ui_helpers/custom_toast.dart';
import 'package:employee_app/ui_helpers/test_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class EmployeeForm extends StatefulWidget {
  final Employee? employee;
  const EmployeeForm({super.key, this.employee});

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  late TextEditingController nameController;
  String? role;
  DateTime startDate = DateTime.now();
  DateTime? endDate;
  List<Widget> tiles = [];

  @override
  void initState() {
    initFormFields();
    initRoleTiles();
    super.initState();
  }

  initRoleTiles() {
    //I assume somewhere down the line we'll fetch roles remotely here.
    //Currently fetching from a test list of strings.
    for (String r in roles) {
      tiles.add(GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            role = r;
          });
          Navigator.pop(context);
        },
        child: Container(
          height: 52,
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(r),
          ),
        ),
      ));
    }
  }

  initFormFields() {
    //In case its an edit we want to fill pre-existing values
    nameController = TextEditingController(text: widget.employee?.name ?? "");
    role = widget.employee?.role;
    startDate = widget.employee?.startDate ?? DateTime.now();
    endDate = widget.employee?.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const SizedBox.shrink(),
          leadingWidth: 0,
          title: Text(
              "${widget.employee == null ? "Add" : "Edit"} Employee Details"),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            //So that user can tap outside the form field to remove keyboard
            FocusScopeNode node = FocusScope.of(context);
            if (!node.hasPrimaryFocus) {
              node.unfocus();
              setState(() {});
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                          controller: nameController,
                          cursorColor: FIELD_BORDER_COLOR,
                          textAlignVertical: TextAlignVertical.center,
                          textCapitalization: TextCapitalization.words,
                          style: FORM_TEXT_STYLE,
                          decoration: nameInputDecoration()),
                    ),
                    const SizedBox(height: 23),
                    EmployeeRoleSelector(tiles: tiles, role: role),
                    const SizedBox(height: 23),
                    Row(
                      children: [
                        EmployeeDateField(
                          isStart: true,
                          date: startDate,
                          openCalendar: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    insetPadding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.05),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: CustomCalendarWidget(
                                      isStart: true,
                                      selectedDate: startDate,
                                      otherDate: endDate,
                                    ));
                              },
                            ).then((val) {
                              if (val != null) {
                                setState(() {
                                  startDate = val;
                                  if (endDate != null &&
                                      endDate!.isBefore(startDate)) {
                                    endDate = null;
                                  }
                                });
                              }
                            });
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset(
                              'images/icons/arrow_right_alt.svg'),
                        ),
                        EmployeeDateField(
                          isStart: false,
                          date: endDate,
                          openCalendar: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    insetPadding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.05),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: CustomCalendarWidget(
                                      isStart: false,
                                      selectedDate: endDate,
                                      otherDate: startDate,
                                    ));
                              },
                            ).then((val) {
                              setState(() {
                                if (val != null) endDate = val['date'];
                              });
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              FormBottomBar(
                onSave: () {
                  if (!validForm()) {
                    return;
                  }
                  Employee e = Employee()
                    ..name = nameController.text.trim()
                    ..role = role!
                    ..startDate = startDate
                    ..endDate = endDate
                    ..id = widget.employee?.id ?? 0;
                  bool success = EmployeeServices().addOrUpdateEmployee(e);
                  if (success) {
                    if (mounted) {
                      CustomSnackBar.showSnackBar(
                          context,
                          "Employee was successfully ${widget.employee == null ? "added" : "edited"}!",
                          3);
                      context.read<EmployeeBloc>().add(LoadEmployees());
                      Navigator.pop(context);
                    }
                  } else {
                    if (mounted) {
                      CustomSnackBar.showSnackBar(
                          context, "Error, please try again.", 3);
                    }
                  }
                },
              )
            ],
          ),
        ));
  }

  bool validForm() {
    if (nameController.text.trim().isEmpty) {
      CustomSnackBar.showSnackBar(context, "Please enter a name", 3);
      return false;
    }
    if (!regexCheckForName(nameController.text.trim()) ||
        !regexCheckForName(nameController.text.trim())) {
      CustomSnackBar.showSnackBar(context,
          "*Only alphabets or some special characters (. , - ') allowed", 3);
      return false;
    }

    if ((role ?? "").isEmpty) {
      CustomSnackBar.showSnackBar(context, "Please select a role", 3);
      return false;
    }

    return true;
  }

  bool regexCheckForName(String text) {
    RegExp rex = RegExp(r"^[a-zA-Z]+[a-zA-Z ,.\-']*$");
    return rex.hasMatch(text);
  }

  InputDecoration nameInputDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.zero,
      prefixIcon: Container(
          height: 24,
          width: 24,
          padding: const EdgeInsets.fromLTRB(0, 8, 6, 8),
          child: SvgPicture.asset(
            'images/icons/person.svg',
            colorFilter: const ColorFilter.mode(APP_BLUE, BlendMode.srcIn),
          )),
      hintText: "Employee name",
      hintStyle: HINT_TEXT_STYLE,
      focusedBorder: BORDER_DECORATION,
      enabledBorder: BORDER_DECORATION,
      border: BORDER_DECORATION,
    );
  }
}

class EmployeeDateField extends StatelessWidget {
  const EmployeeDateField({
    super.key,
    required this.date,
    required this.openCalendar,
    required this.isStart,
  });

  final bool isStart;
  final DateTime? date;
  final Function openCalendar;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => openCalendar(),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: FIELD_BORDER_COLOR)),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 14, 8),
                child: SvgPicture.asset('images/icons/event.svg'),
              ),
              Expanded(
                  child: Text(
                      date == null || isSameDay(date, DateTime.now())
                          ? isStart
                              ? "Today"
                              : "No date"
                          : DateFormat('d MMM y').format(date!),
                      style: date == null ? HINT_TEXT_STYLE : FORM_TEXT_STYLE)),
            ],
          ),
        ),
      ),
    );
  }
}
