import 'package:flutter/material.dart';
import 'package:realtime_innovations/data/local/tables/employee.dart';
import 'package:realtime_innovations/theme/custom_text_theme.dart';
import 'package:realtime_innovations/utils/custom_date_utils.dart';

class CurrentEmployeeWidget extends StatelessWidget {
  const CurrentEmployeeWidget({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  final Employee employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(employee.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: InkWell(
        onTap: onEdit,
        child: EmployeeWidget(employee: employee),
      ),
    );
  }
}

class EmployeeWidget extends StatelessWidget {
  const EmployeeWidget({
    super.key,
    required this.employee,
    this.isPastEmployee = false,
  });

  final Employee employee;
  final bool isPastEmployee;

  String _getDateString() {
    final startDate = CustomDateUtils.format(employee.startDate);
    final endDate = CustomDateUtils.format(employee.endDate);

    String dateString = startDate;

    if (isPastEmployee && endDate.isNotEmpty) {
      dateString += ' - $endDate';
    }

    return dateString;
  }

  @override
  Widget build(BuildContext context) {
    final date = _getDateString();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employee.name,
            style: CustomTextTheme.roboto().copyWith(
              color: const Color(0xFF323238),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            employee.role,
            style: CustomTextTheme.roboto().copyWith(
              color: const Color(0xFF949C9E),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: CustomTextTheme.roboto().copyWith(
              color: const Color(0xFF949C9E),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
