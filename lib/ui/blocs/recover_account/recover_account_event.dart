import 'package:equatable/equatable.dart';
import 'package:mooncake/ui/ui.dart';

/// Represents a generic event that is emitted when recovering an existing
/// account using a mnemonic phrase.
abstract class RecoverAccountEvent extends Equatable {
  const RecoverAccountEvent();

  @override
  List<Object> get props => [];
}

/// Event that tells the bloc that the user has changed the input mnemonic
/// which should be verified.
class MnemonicInputChanged extends RecoverAccountEvent {
  final MnemonicInputState mnemonicInputState;

  MnemonicInputChanged(this.mnemonicInputState);

  @override
  List<Object> get props => [mnemonicInputState];

  @override
  String toString() {
    return 'MnemonicInputChanged';
  }
}

/// Event that tells the bloc that the user has clicked the button to recover
/// the account using the mnemonic phrase inserted.
class RecoverAccount extends RecoverAccountEvent {
  @override
  String toString() => 'RecoverAccount';
}

/// Event that is emitted when the user wants to close the error popup.
class CloseErrorPopup extends RecoverAccountEvent {
  @override
  String toString() => 'CloseErrorPopup';
}
