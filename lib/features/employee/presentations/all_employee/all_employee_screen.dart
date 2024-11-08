import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_innovations/data/local/tables/employee.dart';
import 'package:realtime_innovations/features/employee/blocs/bloc.dart';
import 'package:realtime_innovations/features/employee/presentations/employee_form/employee_form_screen.dart';
import 'package:realtime_innovations/theme/app_colors.dart';
import 'package:realtime_innovations/utils/snack_utils.dart';

import 'widgets/employee_type_title.dart';
import 'widgets/employee_widget.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  void _openEmployeeFormScreen(BuildContext context, {Employee? employee}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<EmployeeCubit>(),
          child: EmployeeFormScreen(employee: employee),
        ),
      ),
    );

    if (result == null) return;

    context.read<EmployeeCubit>().loadEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.primary,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
        title: const Text('Employee List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEmployeeFormScreen(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<EmployeeCubit, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeEditOperationSuccess) {
            SnackUtils.success(context, 'Employee data has been updated');
          }

          if (state is EmployeeDeleteOperationSuccess) {
            SnackUtils.action(
              context,
              'Employee data has been deleted',
              'Undo',
              () {
                context.read<EmployeeCubit>().undoDelete();
              },
            );
          }

          if (state is EmployeeOperationFailure) {
            SnackUtils.error(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is EmployeesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EmployeeLoadingFailure) {
            return Center(child: Text(state.error));
          }

          if (state is EmployeesLoaded) {
            final currentEmployee = state.employees.where((e) => e.endDate == null).toList();
            final previousEmployee = state.employees.where((e) => e.endDate != null).toList();

            if (currentEmployee.isEmpty && previousEmployee.isEmpty) {
              return SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                child: Center(
                  child: Image.asset(
                    'assets/images/no_data.png',
                    height: 200,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentEmployee.isNotEmpty) ...[
                    const EmployeeTypeTitle(
                      type: 'Current employees',
                    ),
                    ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: currentEmployee.length,
                      separatorBuilder: (_, __) => Divider(height: 0, color: Colors.grey.shade200),
                      itemBuilder: (_, int index) {
                        final employee = currentEmployee[index];

                        return CurrentEmployeeWidget(
                          employee: employee,
                          onEdit: () => _openEmployeeFormScreen(context, employee: employee),
                          onDelete: () {
                            context.read<EmployeeCubit>().deleteEmployee(employee);
                          },
                        );
                      },
                    ),
                  ],
                  if (previousEmployee.isNotEmpty) ...[
                    const EmployeeTypeTitle(
                      type: 'Previous employees',
                    ),
                    ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: previousEmployee.length,
                      separatorBuilder: (_, __) => Divider(height: 0, color: Colors.grey.shade200),
                      itemBuilder: (_, int index) {
                        final employee = previousEmployee[index];

                        return EmployeeWidget(
                          employee: employee,
                          isPastEmployee: true,
                        );
                      },
                    ),
                  ],
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Swipe left to delete', style: TextStyle(color: Colors.grey)), // Adds the message
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
