import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_app/components/carousel_calender_widget.dart';

class SelectDateWidget extends StatefulWidget {
  const SelectDateWidget({
    super.key,
    required this.onDateSelected,
  });
  final ValueChanged<DateTime?> onDateSelected;
  @override
  State<SelectDateWidget> createState() => _SelectDateWidgetState();
}

class _SelectDateWidgetState extends State<SelectDateWidget> {
  DateTime? _date;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      // height: size.height * 0.35,
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
           SizedBox(
              // height: size.height * 0.07 * 6,
              child: CarouselCalenderWidget(
            onDateSelect: (value) {
              _date = value;
            },
          )),
          SizedBox(
            height: size.height * 0.07,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      CupertinoColors.activeBlue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ))),
              onPressed: () {
                widget.onDateSelected(_date);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                      child: Text(
                    'Select',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
