import 'package:employee_app/components/custom_calendar_components/customization/calendar_style.dart';
import 'package:employee_app/components/custom_calendar_components/customization/header_style.dart';
import 'package:employee_app/components/custom_calendar_components/shared/utils.dart';
import 'package:employee_app/components/custom_calendar_components/table_calendar.dart';
import 'package:employee_app/ui_helpers/constants.dart';
import 'package:employee_app/ui_helpers/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CustomCalendarWidget extends StatefulWidget {
  final bool isStart;
  final DateTime? selectedDate;
  final DateTime? otherDate;

  const CustomCalendarWidget(
      {super.key,
      required this.isStart,
      this.selectedDate,
      required this.otherDate});
  @override
  CustomCalendarWidgetState createState() => CustomCalendarWidgetState();
}

class CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  DateTime? _selectedDate;
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    _selectedDate = widget.selectedDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, widget.isStart ? 16 : 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.isStart
                    ? topButton(
                        onTap: () => _selectToday(),
                        text: "Today",
                        selected: _isTodaySelected(),
                      )
                    : topButton(
                        text: "No date",
                        onTap: () => setState(() {
                              _selectedDate = null;
                            }),
                        selected: _selectedDate == null),
                const SizedBox(width: 16),
                widget.isStart
                    ? topButton(
                        onTap: () => _selectNextMonday(),
                        text: "Next Monday",
                        selected: _isNextMondaySelected(),
                      )
                    : topButton(
                        onTap: () => _selectToday(),
                        text: "Today",
                        selected: _isTodaySelected(),
                      )
              ],
            ),
          ),
          widget.isStart
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      topButton(
                        onTap: () => _selectNextTuesday(),
                        text: "Next Tuesday",
                        selected: _isNextTuesdaySelected(),
                      ),
                      const SizedBox(width: 16),
                      topButton(
                        onTap: () => _selectAfterOneWeek(),
                        text: "After 1 week",
                        selected: _isAfterOneWeekSelected(),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          // Calendar Widget customized from Table Calendar on pub dev
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TableCalendar(
              calendarStyle: CalendarStyle(
                  rangeHighlightColor: APP_BLUE,
                  todayTextStyle: const TextStyle(color: APP_BLUE),
                  selectedDecoration: const BoxDecoration(
                    color: APP_BLUE,
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: false,
                  todayDecoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: APP_BLUE))),
              headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  rightChevronMargin: const EdgeInsets.only(left: 8),
                  leftChevronMargin: const EdgeInsets.only(right: 8),
                  rightChevronIcon:
                      SvgPicture.asset('images/icons/arrow_right.svg'),
                  leftChevronIcon:
                      SvgPicture.asset('images/icons/arrow_left.svg'),
                  titleTextStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: ALMOST_BLACK,
                      height: 1.16)),
              onFormatChanged: (format) {},
              firstDay:
                  widget.isStart ? DateTime.utc(2022, 1, 1) : afterStartTime(),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _selectedDate ??
                  (widget.isStart ? DateTime.now() : afterStartTime()),
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
              },
            ),
          ),

          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                        height: 23,
                        width: 20,
                        child:
                            SvgPicture.asset('images/icons/calendar_icon.svg')),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('d MMM y')
                          .format(_selectedDate ?? DateTime.now()),
                      style: const TextStyle(fontSize: 16, height: 1.25),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    bottomButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        text: "Cancel"),
                    const SizedBox(width: 16),
                    bottomButton(
                        onTap: () {
                          if (widget.isStart) {
                            Navigator.pop(context, _selectedDate);
                          } else {
                            if (_selectedDate != null &&
                                widget.otherDate!.isAfter(_selectedDate!)) {
                              CustomToast.showToast(
                                  context,
                                  "Please select an end date later than the start date.",
                                  3);
                              return;
                            }
                            Navigator.pop(context, {"date": _selectedDate});
                          }
                        },
                        text: "Save"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectToday() {
    setState(() {
      _selectedDate = DateTime.now();
    });
  }

  bool _isTodaySelected() {
    DateTime now = DateTime.now();
    return isSameDay(now, _selectedDate);
  }

  void _selectNextMonday() {
    int daysToAdd = (8 - DateTime.now().weekday) % 7;
    if (daysToAdd == 0) daysToAdd += 7;
    setState(() {
      _selectedDate = DateTime.now().add(Duration(days: daysToAdd));
    });
  }

  bool _isNextMondaySelected() {
    int daysToMondaySinceToday = (8 - DateTime.now().weekday) % 7;
    if (daysToMondaySinceToday == 0) daysToMondaySinceToday += 7;
    DateTime nextMonday =
        DateTime.now().add(Duration(days: daysToMondaySinceToday));
    return isSameDay(nextMonday, _selectedDate);
  }

  void _selectNextTuesday() {
    int daysToAdd = (9 - DateTime.now().weekday) % 7;
    if (daysToAdd == 0) daysToAdd += 7;
    setState(() {
      _selectedDate = DateTime.now().add(Duration(days: daysToAdd));
    });
  }

  bool _isNextTuesdaySelected() {
    int daysToTuesdaySinceToday = (9 - DateTime.now().weekday) % 7;
    if (daysToTuesdaySinceToday == 0) daysToTuesdaySinceToday += 7;
    DateTime nextTuesday =
        DateTime.now().add(Duration(days: daysToTuesdaySinceToday));
    return isSameDay(nextTuesday, _selectedDate);
  }

  void _selectAfterOneWeek() {
    setState(() {
      _selectedDate = DateTime.now().add(const Duration(days: 7));
    });
  }

  bool _isAfterOneWeekSelected() {
    DateTime nextWeek = DateTime.now().add(const Duration(days: 7));
    return isSameDay(nextWeek, _selectedDate);
  }

  Widget bottomButton({required String text, required onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 40,
        width: 73,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: text == "Save" ? APP_BLUE : const Color(0xffEDF8FF),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                height: 1.14, color: text == "Save" ? Colors.white : APP_BLUE),
          ),
        ),
      ),
    );
  }

  Widget topButton(
      {required String text, required onTap, required bool selected}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: selected ? APP_BLUE : const Color(0xffEDF8FF),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  height: 1.14, color: selected ? Colors.white : APP_BLUE),
            ),
          ),
        ),
      ),
    );
  }

  DateTime afterStartTime() => widget.otherDate!.add(const Duration(days: 1));
}
