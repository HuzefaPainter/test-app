import 'package:employee_app/ui_helpers/constants.dart';
import 'package:employee_app/ui_helpers/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmployeeRoleSelector extends StatelessWidget {
  const EmployeeRoleSelector({
    super.key,
    required this.tiles,
    required this.role,
  });

  final List<Widget> tiles;
  final String? role;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              CustomBottomSheet().showBottomSheet(context, tiles);
            },
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: FIELD_BORDER_COLOR)),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 14, 8),
                    child: SvgPicture.asset('images/icons/work.svg'),
                  ),
                  Expanded(
                      child: Text(role ?? "Select role",
                          style: role == null
                              ? HINT_TEXT_STYLE
                              : FORM_TEXT_STYLE)),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 14, 8),
                      child:
                          SvgPicture.asset('images/icons/arrow_drop_down.svg')),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class FormBottomBar extends StatelessWidget {
  final Function onSave;
  const FormBottomBar({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Divider(height: 0),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                    height: 40,
                    width: 73,
                    decoration: BoxDecoration(
                        color: const Color(0xffedf8ff),
                        borderRadius: BorderRadius.circular(6)),
                    child: const Center(
                        child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: APP_BLUE,
                          fontWeight: FontWeight.w500,
                          height: 1.14),
                    ))),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => onSave(),
                child: Container(
                    height: 40,
                    width: 73,
                    decoration: BoxDecoration(
                        color: APP_BLUE,
                        borderRadius: BorderRadius.circular(6)),
                    child: const Center(
                        child: Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          height: 1.14),
                    ))),
              ),
              const SizedBox(width: 16)
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
