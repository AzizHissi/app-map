import 'package:flutter/cupertino.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, WeekdayFormat;

class CarouselCalenderWidget extends StatefulWidget {
  const CarouselCalenderWidget({super.key, required this.onDateSelect});
  final ValueChanged<DateTime> onDateSelect;

  @override
  State<CarouselCalenderWidget> createState() => _CarouselCalenderWidgetState();
}

class _CarouselCalenderWidgetState extends State<CarouselCalenderWidget> {
  DateTime _currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return CalendarCarousel<Event>(
      customWeekDayBuilder: (weekday, weekdayName) {
        return Text(weekdayName.toUpperCase(),
            style: const TextStyle(
                color: CupertinoColors.darkBackgroundGray,
                fontSize: 17,
                fontWeight: FontWeight.bold));
      },

      inactiveDaysTextStyle: TextStyle(
          color: CupertinoColors.black.withOpacity(.2),
          fontSize: 18,
          fontWeight: FontWeight.bold),
      todayButtonColor: CupertinoColors.systemGrey2,
      todayBorderColor: CupertinoColors.systemGrey2,
      todayTextStyle: TextStyle(
          color: CupertinoColors.black.withOpacity(.6),
          fontSize: 18,
          fontWeight: FontWeight.bold),
      selectedDayBorderColor: CupertinoColors.activeBlue,
      selectedDayButtonColor: CupertinoColors.activeBlue,
      daysHaveCircularBorder: true,
      leftButtonIcon: const Icon(CupertinoIcons.arrow_left,
          color: CupertinoColors.activeBlue),
      rightButtonIcon: const Icon(CupertinoIcons.arrow_right,
          color: CupertinoColors.activeBlue),

      weekdayTextStyle: TextStyle(
          color: CupertinoColors.black.withOpacity(.6),
          fontSize: 18,
          fontWeight: FontWeight.bold),
      daysTextStyle: TextStyle(
          color: CupertinoColors.black.withOpacity(.6),
          fontSize: 18,
          fontWeight: FontWeight.bold),

      onDayPressed: (DateTime date, List<Event> events) {
        setState(() => _currentDate = date);
        widget.onDateSelect(_currentDate);
      },
      weekendTextStyle: TextStyle(
          color: CupertinoColors.black.withOpacity(.6),
          fontSize: 18,
          fontWeight: FontWeight.bold),

      weekFormat: false,

      height: 400.0,
      selectedDateTime: _currentDate,

      /// null for not rendering any border, true for circular border, false for rectangular border
    );
  }
}
