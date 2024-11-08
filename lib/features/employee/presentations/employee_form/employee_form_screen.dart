import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_innovations/constants/index.dart';
import 'package:realtime_innovations/data/local/tables/employee.dart';
import 'package:realtime_innovations/features/employee/blocs/bloc.dart';
import 'package:realtime_innovations/features/employee/presentations/employee_form/widgets/custom_date_picker.dart';
import 'package:realtime_innovations/features/employee/presentations/employee_form/widgets/role_modal_sheet.dart';
import 'package:realtime_innovations/theme/app_colors.dart';
import 'package:realtime_innovations/theme/custom_text_theme.dart';
import 'package:realtime_innovations/utils/custom_date_utils.dart';
import 'package:realtime_innovations/utils/snack_utils.dart';

class EmployeeFormScreen extends StatefulWidget {
  const EmployeeFormScreen({
    super.key,
    this.employee,
  });

  final Employee? employee;

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  final TextEditingController _roleController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  bool get _isEditing => widget.employee != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    final employee = widget.employee;

    if (employee != null) {
      _nameController.text = employee.name;
      _roleController.text = employee.role;
      _startDate = employee.startDate;
      _endDate = employee.endDate;
    }
  }

  void _showRoleBottomSheet(BuildContext context) {
    FocusScope.of(context).unfocus();
    RoleModalSheet.show(
      context,
      (String role) {
        _roleController.text = role;
      },
    );
  }

  void _selectStartDate() {
    CustomDatePicker.show(
      context,
      (DateTime date) {
        setState(() {
          _startDate = date;
        });
      },
    );
  }

  void _selectEndDate() {
    CustomDatePicker.show(
      context,
      (DateTime date) {
        setState(() {
          _endDate = date;
        });
      },
    );
  }

  void _deleteEmployee() {
    context.read<EmployeeCubit>().deleteEmployee(widget.employee!);
    Navigator.of(context).pop(true);
  }

  void _onSave() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final role = _roleController.text;

    if (role.isEmpty) {
      SnackUtils.error(context, 'Please select a role');

      return;
    }

    if (_startDate == null) {
      SnackUtils.error(context, 'Please select start date');

      return;
    }

    final employee = Employee(
      id: _isEditing ? widget.employee!.id : 0,
      name: _nameController.text,
      role: role,
      startDate: _startDate!,
      endDate: _endDate,
    );

    if (_isEditing) {
      context.read<EmployeeCubit>().updateEmployee(employee);
    } else {
      context.read<EmployeeCubit>().addEmployee(employee);
    }

    Navigator.of(context).pop(employee);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
        title: Text('${_isEditing ? 'Edit' : 'Add'} Employee Details'),
        actions: [
          if (_isEditing) ...[
            IconButton(
              onPressed: _deleteEmployee,
              icon: const Icon(Icons.delete),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        decoration: CustomTextTheme.decorationIcon(Assets.iconProfile).copyWith(
                          labelText: 'Employee Name',
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _showRoleBottomSheet(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _roleController,
                            decoration: CustomTextTheme.decorationIcon(Assets.iconProfile).copyWith(
                              labelText: 'Select role',
                              suffixIcon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1DA1F2)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: _selectStartDate,
                              child: InputDecorator(
                                decoration: CustomTextTheme.decorationIcon(Assets.iconDate).copyWith(
                                  labelText: 'Start Date',
                                ),
                                child: Text(
                                  CustomDateUtils.formatOrNull(_startDate) ?? 'No date',
                                  style: TextStyle(
                                    color: _startDate != null ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          const ImageIcon(
                            Assets.iconArrow,
                            color: Color(0xFF1DA1F2),
                            size: 14,
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: InkWell(
                              onTap: _selectEndDate,
                              child: InputDecorator(
                                decoration: CustomTextTheme.decorationIcon(Assets.iconDate).copyWith(
                                  labelText: 'End Date',
                                ),
                                child: Text(
                                  CustomDateUtils.formatOrNull(_endDate) ?? 'No date',
                                  style: TextStyle(
                                    color: _endDate != null ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEDF8FF),
                    foregroundColor: const Color(0xFF1DA1F2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DA1F2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: _onSave,
                  child: const Text('Save'),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
