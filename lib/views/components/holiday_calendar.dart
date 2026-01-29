import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shrachi/models/holiday.dart';
import 'package:table_calendar/table_calendar.dart';

class HolidayCalendar extends StatefulWidget {
  final List<Holiday> holidays;

  const HolidayCalendar({super.key, required this.holidays});

  @override
  State<HolidayCalendar> createState() => _HolidayCalendarState();
}

class _HolidayCalendarState extends State<HolidayCalendar> {
  late Map<DateTime, List<Holiday>> _holidayEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _holidayEvents = _groupHolidays(widget.holidays);
    _selectedDay = _focusedDay;
  }

  Map<DateTime, List<Holiday>> _groupHolidays(List<Holiday> holidays) {
    Map<DateTime, List<Holiday>> data = {};
    for (var h in holidays) {
      final key = DateTime.utc(
        h.holidayDate.year,
        h.holidayDate.month,
        h.holidayDate.day,
      );
      data.putIfAbsent(key, () => []);
      data[key]!.add(h);
    }
    return data;
  }

  List<Holiday> _getEventsForDay(DateTime day) {
    return _holidayEvents[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final holidaysForSelectedDay = _getEventsForDay(_selectedDay!);

    return Column(
      children: [
        TableCalendar<Holiday>(
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: _getEventsForDay,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final hasHoliday = _holidayEvents.containsKey(
                DateTime.utc(day.year, day.month, day.day),
              );
              if (hasHoliday) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
              return null;
            },
            todayBuilder: (context, day, focusedDay) {
              final hasHoliday = _holidayEvents.containsKey(
                DateTime.utc(day.year, day.month, day.day),
              );
              if (hasHoliday) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text('${day.day}'),
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              final hasHoliday = _holidayEvents.containsKey(
                DateTime.utc(day.year, day.month, day.day),
              );
              if (hasHoliday) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue, // selected non-holiday
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
            },
            markerBuilder: (context, day, events) => const SizedBox.shrink(),
          ),
        ),

        const SizedBox(height: 16),
        Divider(color: Colors.black.withValues(alpha: 0.3)),
        Expanded(
          child:
              holidaysForSelectedDay.isNotEmpty
                  ? ListView.builder(
                    itemCount: holidaysForSelectedDay.length,
                    itemBuilder: (ctx, index) {
                      final h = holidaysForSelectedDay[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Text(
                            h.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          h.name,
                          style: const TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                          DateFormat('dd-MM-yyyy').format(h.holidayDate),
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      );
                    },
                  )
                  : const Center(
                    child: Text(
                      'No holidays on this day',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
        ),
      ],
    );
  }
}
