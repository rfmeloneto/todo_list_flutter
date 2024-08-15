import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presenter/cubits/activity_cubit/activity_cubit.dart';
import 'presenter/pages/todo_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoCubit>(create: (BuildContext context) => TodoCubit()),
      ],
      child: const MaterialApp(
        home: TodoPage(),
        // home: Scaffold(
        //   body: Center(
        //     child: Text("teste"),
        //   ),
        // ),
      ),
    );
  }
}
