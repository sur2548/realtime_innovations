import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'features/employee/blocs/bloc.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<EmployeeCubit>()..loadEmployees()),
        // Add other providers here if needed
      ],
      child: const RealtimeInnovation(),
    ),
  );
}
