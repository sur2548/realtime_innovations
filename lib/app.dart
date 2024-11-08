import 'package:flutter/material.dart';

import 'features/employee/presentations/all_employee/all_employee_screen.dart';

class RealtimeInnovation extends StatelessWidget {
  const RealtimeInnovation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realtime Innovations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EmployeeListScreen(),
    );
  }
}
