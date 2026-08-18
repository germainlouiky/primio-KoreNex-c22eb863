import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../theme/theme.dart';

class DeadlineCalendarScreen extends StatefulWidget {
  const DeadlineCalendarScreen({super.key});

  @override
  State<DeadlineCalendarScreen> createState() => _DeadlineCalendarScreenState();
}

class _DeadlineCalendarScreenState extends State<DeadlineCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final Map<DateTime, List<_Deadline>> _events = {
    DateTime.utc(2026, 8, 22): [_Deadline('Gold Team Review — Data Analytics', 'HHS / CDC', const Color(0xFF8B5CF6), 'Final Review')],
    DateTime.utc(2026, 8, 25): [_Deadline('Q&A Period Closes — Cyber Assessment', 'DHS / CISA', const Color(0xFFEF4444), 'Q&A Deadline')],
    DateTime.utc(2026, 8, 28): [_Deadline('Proposal Due — Cyber Assessment', 'DHS / CISA', const Color(0xFFEF4444), 'Submission')],
    DateTime.utc(2026, 9, 1): [_Deadline('Site Visit — Facilities Maintenance', 'GSA', const Color(0xFF10B981), 'Site Visit')],
    DateTime.utc(2026, 9, 5): [_Deadline('ISO 9001 Internal Audit', 'Internal', const Color(0xFFF59E0B), 'Compliance')],
    DateTime.utc(2026, 9, 12): [_Deadline('Proposal Due — Cloud Migration', 'DoD / DISA', const Color(0xFF3B82F6), 'Submission')],
    DateTime.utc(2026, 9, 15): [
      _Deadline('Pink Team Review — IT Staffing', 'VA', const Color(0xFFEC4899), 'Review'),
      _Deadline('SAM.gov registration renewal check', 'Internal', const Color(0xFF06B6D4), 'Compliance'),
    ],
    DateTime.utc(2026, 10, 1): [_Deadline('ISO 9001 Recertification Deadline', 'ISO', const Color(0xFFF59E0B), 'Compliance')],
    DateTime.utc(2026, 10, 3): [_Deadline('Proposal Due — IT Helpdesk Support', 'VA', const Color(0xFF3B82F6), 'Submission')],
  };

  List<_Deadline> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final appColors = Theme.of(context).extension<AppColorsExtension>()!;
    const accent = Color(0xFFEF4444);
    final selectedEvents = _selectedDay != null ? _getEventsForDay(_selectedDay!) : <_Deadline>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Deadline Calendar')),
      body: Column(
        children: [
          TableCalendar<_Deadline>(
            firstDay: DateTime.utc(2026, 1, 1),
            lastDay: DateTime.utc(2027, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            onDaySelected: (selected, focused) => setState(() {
              _selectedDay = selected;
              _focusedDay = focused;
            }),
            onFormatChanged: (format) => setState(() => _calendarFormat = format),
            onPageChanged: (focused) => _focusedDay = focused,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(color: accent.withOpacity(0.3), shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              markerDecoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
              markerSize: 6,
              markersMaxCount: 2,
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonDecoration: BoxDecoration(border: Border.all(color: colors.outline), borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
              formatButtonTextStyle: text.labelSmall ?? const TextStyle(),
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Expanded(
            child: selectedEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_available_rounded, size: 48, color: appColors.subtleText),
                        const SizedBox(height: AppTheme.spacingSm),
                        Text('Tap a date to see deadlines', style: text.bodyMedium?.copyWith(color: appColors.subtleText)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                    itemCount: selectedEvents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingSm),
                    itemBuilder: (context, i) {
                      final e = selectedEvents[i];
                      return Container(
                        padding: const EdgeInsets.all(AppTheme.spacingMd),
                        decoration: BoxDecoration(
                          color: appColors.toolCardBg,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          border: Border(left: BorderSide(color: e.color, width: 3)),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(e.title, style: text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: AppTheme.spacingXs),
                              Text(e.agency, style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                            ])),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingSm, vertical: AppTheme.spacingXs),
                              decoration: BoxDecoration(color: e.color.withOpacity(0.15), borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
                              child: Text(e.type, style: text.labelSmall?.copyWith(color: e.color)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: accent.withOpacity(0.2)),
              ),
              child: Row(children: [
                Icon(Icons.upcoming_rounded, color: accent, size: AppTheme.iconMd),
                const SizedBox(width: AppTheme.spacingSm),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Next deadline in 4 days', style: text.titleSmall),
                  Text('Gold Team Review — Data Analytics (Aug 22)', style: text.bodySmall?.copyWith(color: appColors.subtleText)),
                ])),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Deadline {
  final String title, agency, type;
  final Color color;
  _Deadline(this.title, this.agency, this.color, this.type);
}
