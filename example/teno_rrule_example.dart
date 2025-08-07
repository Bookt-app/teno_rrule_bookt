import 'package:teno_rrule/teno_rrule.dart';
import 'package:timezone/standalone.dart';
import 'package:teno_datetime/teno_datetime.dart';
import 'package:timezone/data/latest_10y.dart';

void main() {
  initializeTimeZones();

  // Create rrule instance programmatically
  final rrule = RecurrenceRule(
      frequency: Frequency.weekly,
      startDate: DateTime(1997, 9, 2, 9),
      byWeekDays: {WeekDay.monday, WeekDay.wednesday, WeekDay.friday});
  for (var instance
      in rrule.between(DateTime(1997, 9, 2, 9), DateTime(1997, 10, 2, 9))) {
    print(instance);
  }

  // Example: Add RDATE (includedDates)
  final rruleWithRDate = RecurrenceRule(
    frequency: Frequency.monthly,
    byMonthDays: {13},
    byWeekDays: {WeekDay.friday},
    isLocal: false,
    startDate: TZDateTime(getLocation('America/New_York'), 1997, 9, 2, 9),
    includedDates: {
      TZDateTime(getLocation('America/New_York'), 1997, 9, 2, 9),
      TZDateTime(getLocation('America/New_York'), 1998, 2, 13, 9),
    },
  );
  print('Instances with RDATE:');
  print(rruleWithRDate.allInstances.take(10).toList());
  print(rruleWithRDate.toString());

  // Parse from string
  final rruleString = 'DTSTART;TZID=America/New_York:19970902T090000\n'
      'RRULE:FREQ=DAILY;INTERVAL=2';
  final rruleFromString = RecurrenceRule.from(rruleString);

  // Get all instances
  // if there is no UNTIL nor COUNT, then this will return all instances before 2100-12-31
  print(rruleFromString!.allInstances);

  // Parse from string with RDATE
  final rruleStringWithRDate = 'DTSTART;TZID=America/New_York:19970902T090000\n'
      'RDATE;TZID=America/New_York:19970902T090000,19980213T090000\n'
      'RRULE:FREQ=MONTHLY;BYDAY=FR;BYMONTHDAY=13;COUNT=5';
  final rruleFromStringWithRDate = RecurrenceRule.from(rruleStringWithRDate);
  print('Instances from string with RDATE:');
  print(rruleFromStringWithRDate!.allInstances.take(10).toList());
}
