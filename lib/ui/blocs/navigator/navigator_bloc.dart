import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// BloC that controls the navigation to the different screens of the app.
class NavigatorBloc extends Bloc<NavigatorEvent, void> {
  final _navigatorKey = PostsKeys.navigatorKey;

  NavigatorBloc();

  factory NavigatorBloc.create() {
    return NavigatorBloc();
  }

  @override
  void get initialState => null;

  @override
  Stream<void> mapEventToState(NavigatorEvent event) async* {
    if (event is NavigateToHome) {
      _mapNavigateToHomeEventToState();
    } else if (event is NavigateToRecoverAccount) {
      _mapNavigateToRecoverAccountEventToState(event);
    } else if (event is NavigateToCreateAccount) {
      _mapNavigateToCreateAccountEventToState();
    }
  }

  void _mapNavigateToHomeEventToState() {
    _navigatorKey.currentState.pushNamedAndRemoveUntil(
      PostsRoutes.home,
      (_) => false,
    );
  }

  void _mapNavigateToRecoverAccountEventToState(
    NavigateToRecoverAccount event,
  ) {
    _navigatorKey.currentState.pushNamed(
      PostsRoutes.recoverAccount,
      arguments: event.args,
    );
  }

  void _mapNavigateToCreateAccountEventToState() {
    _navigatorKey.currentState.pushNamed(PostsRoutes.createAccount);
  }
}
