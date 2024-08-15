import 'package:fazer/data/datasource.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/activity_cubit/activity_state.dart';

import '../../../domain/atividade_entity.dart';

class TodoCubit extends Cubit<ActivityState> {
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  final List<AtividadeEntity> _activities = [];

  List<AtividadeEntity> get activities => _activities;

  TodoCubit() : super(ActivityInitialState());

  Future<List<AtividadeEntity>> getAll() async {
    List<AtividadeEntity> activities = await databaseHelper.getAll();
    return activities;
  }

  Future<void> addActivity(String activity) async {
    emit(ActivityLoadingState());
    await databaseHelper.insert(activity);
    List<AtividadeEntity> activities = await databaseHelper.getAll();
    emit(ActivityLoadedState(activities: activities));
  }

  Future<void> removeActivity(int id) async {
    await databaseHelper.delete(id);
    List<AtividadeEntity> activities = await databaseHelper.getAll();
    emit(ActivityLoadedState(activities: activities));
  }

  Future<void> showInit() async {
    List<AtividadeEntity> activities = await databaseHelper.getAll();
    if (activities.isEmpty) {
      emit(ActivityInitialState());
    } else {
      emit(ActivityInitialState(activities: activities));
    }
  }
}
