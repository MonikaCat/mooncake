import 'package:equatable/equatable.dart';
import 'package:mooncake/entities/entities.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class UpdateTab extends HomeEvent {
  final AppTab tab;

  const UpdateTab(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'UpdateTab { tab: $tab }';
}

class SignOut extends HomeEvent {
  @override
  String toString() => 'SignOut';
}
