import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:realtime_innovations/constants/index.dart';
import 'package:realtime_innovations/theme/app_colors.dart';
import 'package:realtime_innovations/theme/custom_text_theme.dart';
import 'package:realtime_innovations/utils/custom_date_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    super.key,
    required this.onSelect,
  });

  final ValueChanged<DateTime> onSelect;

  @override
  CustomDatePickerState createState() => CustomDatePickerState();

  static Future show(BuildContext context, ValueChanged<DateTime> onSelect) async {
    return await showDialog(
      context: context,
      builder: (x) {
        return CustomDatePicker(onSelect: onSelect);
      },
    );
  }
}

class CustomDatePickerState extends State<CustomDatePicker> {
  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String _selectedTitle = 'Today';

  DateTime _getNextWeekday(int targetWeekday) {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    int daysToAdd = (targetWeekday - currentWeekday + 7) % 7;
    if (daysToAdd == 0 && targetWeekday == now.weekday) {
      daysToAdd = 7;
    }
    return now.add(Duration(days: daysToAdd));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDate, selectedDay)) {
      setState(() {
        _selectedDate = selectedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWeb = width >= 600;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: isWeb ? width * 0.5 : double.infinity),
          width: width * 0.95,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomDateButton(
                      title: 'Today',
                      selectedTitle: _selectedTitle,
                      onPressed: (String value) {
                        setState(() {
                          _selectedTitle = value;
                          _selectedDate = DateTime.now();
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    CustomDateButton(
                      title: 'Next Monday',
                      selectedTitle: _selectedTitle,
                      onPressed: (String value) {
                        setState(() {
                          _selectedTitle = value;
                          _selectedDate = _getNextWeekday(DateTime.monday);
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomDateButton(
                      title: 'Next Tuesday',
                      selectedTitle: _selectedTitle,
                      onPressed: (String value) {
                        setState(() {
                          _selectedTitle = value;
                          _selectedDate = _getNextWeekday(DateTime.tuesday);
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    CustomDateButton(
                      title: 'After 1 week',
                      selectedTitle: _selectedTitle,
                      onPressed: (String value) {
                        setState(() {
                          _selectedTitle = value;
                          _selectedDate = DateTime.now().add(const Duration(days: 7));
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _selectedDate,
                calendarFormat: _calendarFormat,
                calendarStyle: CalendarStyle(
                    todayTextStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF1DA1F2),
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF1DA1F2)),
                    ),
                    selectedDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1DA1F2),
                    )),
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDate, day);
                },
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No page change action needed in this example.
                },
              ),
              const SizedBox(height: 20),
              Divider(height: 0, color: Colors.grey.shade200),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const ImageIcon(
                      Assets.iconDate,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      CustomDateUtils.format(_selectedDate),
                      style: CustomTextTheme.roboto().copyWith(
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF323238),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEDF8FF),
                        foregroundColor: const Color(0xFF1DA1F2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      onPressed: () {
                        widget.onSelect(_selectedDate);
                        Navigator.of(context).pop(_selectedDate);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDateButton extends StatelessWidget {
  const CustomDateButton({
    super.key,
    required this.title,
    required this.selectedTitle,
    required this.onPressed,
  });

  final String title;
  final String selectedTitle;
  final ValueChanged<String> onPressed;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedTitle == title;

    final foregroundColor = isSelected ? Colors.white : const Color(0xFF1DA1F2);
    final backgroundColor = isSelected ? const Color(0xFF1DA1F2) : const Color(0xFFEDF8FF);

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          onPressed(title);
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        child: Text(title),
      ),
    );
  }
}
