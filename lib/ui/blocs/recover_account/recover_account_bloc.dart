import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/dependency_injection/dependency_injection.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:mooncake/usecases/usecases.dart';
import 'package:mooncake/utils/utils.dart';

/// Bloc that allows to properly handle the recovering account events
/// and emits the correct states.
class RecoverAccountBloc
    extends Bloc<RecoverAccountEvent, RecoverAccountState> {
  final LoginUseCase _loginUseCase;
  final FirebaseAnalytics _analytics;

  MnemonicInputBloc _mnemonicInputBloc;
  LoginBloc _loginBloc;

  StreamSubscription _mnemonicBlocSubscription;

  RecoverAccountBloc({
    @required MnemonicInputBloc mnemonicInputBloc,
    @required LoginBloc loginBloc,
    @required LoginUseCase loginUseCase,
    @required FirebaseAnalytics analytics,
  })  : assert(mnemonicInputBloc != null),
        _mnemonicInputBloc = mnemonicInputBloc,
        assert(loginBloc != null),
        _loginBloc = loginBloc,
        assert(loginUseCase != null),
        this._loginUseCase = loginUseCase,
        assert(analytics != null),
        _analytics = analytics {
    // Observe the mnemonic changes to react tot them
    _mnemonicBlocSubscription = mnemonicInputBloc.listen((mnemonicState) {
      add(MnemonicInputChanged(mnemonicState));
    });
  }

  factory RecoverAccountBloc.create(BuildContext context) {
    return RecoverAccountBloc(
      mnemonicInputBloc: BlocProvider.of(context),
      loginBloc: BlocProvider.of(context),
      loginUseCase: Injector.get(),
      analytics: Injector.get(),
    );
  }

  @override
  RecoverAccountState get initialState =>
      TypingMnemonic(_mnemonicInputBloc.state);

  @override
  Stream<RecoverAccountState> mapEventToState(
    RecoverAccountEvent event,
  ) async* {
    if (event is MnemonicInputChanged) {
      yield TypingMnemonic(event.mnemonicInputState);
    } else if (event is RecoverAccount) {
      yield* _mapRecoverAccountToState(event);
    } else if (event is CloseErrorPopup) {
      yield* _mapCloseErrorPopupToState();
    }
  }

  Stream<RecoverAccountState> _mapRecoverAccountToState(
    RecoverAccount event,
  ) async* {
    final state = _mnemonicInputBloc.state;
    if (state.isValid) {
      yield RecoveringAccount();
      try {
        await _loginUseCase.login(state.mnemonic);
        _analytics.logEvent(name: Constants.EVENT_ACCOUNT_RECOVERED);
        yield RecoveredAccount(state.mnemonic);
        _loginBloc.add(LogIn(state.mnemonic));
      } catch (error) {
        Logger.log(error);
        yield RecoverError(error);
      }
    }
  }

  Stream<RecoverAccountState> _mapCloseErrorPopupToState() async* {
    final state = _mnemonicInputBloc.state;
    if (state.isValid) {
      add(MnemonicInputChanged(MnemonicInputState(
        mnemonic: state.mnemonic,
        verificationMnemonic: state.verificationMnemonic,
      )));
    }
  }

  @override
  Future<void> close() {
    _mnemonicBlocSubscription.cancel();
    return super.close();
  }
}
