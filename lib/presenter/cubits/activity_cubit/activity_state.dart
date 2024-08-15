import '../../../domain/atividade_entity.dart';

abstract class ActivityState {}

class ActivityInitialState extends ActivityState {
  final String mensagem = 'Nenhuma atividade registrada';
  final List<AtividadeEntity>? activities;
  ActivityInitialState({this.activities});
}

class ActivityLoadingState extends ActivityState {}

class ActivityLoadedState extends ActivityState {
  final List<AtividadeEntity> activities;
  ActivityLoadedState({required this.activities});
}

class ActivityErrorState extends ActivityState {
  final String message;
  ActivityErrorState({required this.message});
}
