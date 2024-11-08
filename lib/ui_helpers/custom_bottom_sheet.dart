import 'package:flutter/material.dart';

class CustomBottomSheet {
  showBottomSheet(BuildContext context, List<Widget> tiles) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        context: context,
        builder: (BuildContext sheetContext) {
          return Wrap(children: [
            Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        children: ListTile.divideTiles(
                                context: context,
                                tiles: tiles,
                                color: const Color(0xffE0E0E0))
                            .toList())
                  ],
                )),
          ]);
        });
  }
}
