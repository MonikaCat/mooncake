import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:mooncake/entities/entities.dart';
import 'package:mooncake/sources/sources.dart';
import 'package:mooncake/utils/logger.dart';

/// Contains all the data needed to perform a transaction.
@visibleForTesting
class TxData extends Equatable {
  final List<StdMsg> messages;
  final Wallet wallet;

  TxData(this.messages, this.wallet);

  @override
  List<Object> get props => [messages, wallet];
}

/// Allows to easily perform chain-related actions such as querying the
/// chain state or sending transactions to it.
class ChainHelper {
  final String _lcdEndpoint;

  ChainHelper({
    @required String lcdEndpoint,
  })  : assert(lcdEndpoint != null && lcdEndpoint.isNotEmpty),
        _lcdEndpoint = lcdEndpoint {
    // This code is duplicated here due to the fact that [sendTxBackground]
    // will be run on a different isolate and Dart singletons are not
    // cross-threads so this Codec is another instance from the one
    // used inside the sendTxBackground method.
    Codec.registerMsgType("desmos/MsgCreatePost", MsgCreatePost);
    Codec.registerMsgType("desmos/MsgAddPostReaction", MsgAddPostReaction);
    Codec.registerMsgType(
      "desmos/MsgRemovePostReaction",
      MsgRemovePostReaction,
    );
  }

  @visibleForTesting
  static Future<TransactionResult> sendTxBackground(TxData txData) async {
    // Register custom messages
    // This needs to be done here as this method can run on different isolates.
    // We cannot rely on the initialization done inside the constructor as
    // this Codec instance will not be the same as that one.
    Codec.registerMsgType("desmos/MsgCreatePost", MsgCreatePost);
    Codec.registerMsgType("desmos/MsgAddPostReaction", MsgAddPostReaction);
    Codec.registerMsgType(
      "desmos/MsgRemovePostReaction",
      MsgRemovePostReaction,
    );

    return TxHelper.sendTx(txData.messages, txData.wallet);
  }

  /// Queries the chain status using the given endpoint and returns
  /// the raw body response.
  /// If an exception is thrown, returns `null`.
  Future<Map<String, dynamic>> queryChainRaw(String endpoint) async {
    final result = await compute(
      QueryHelper.queryChain,
      _lcdEndpoint + endpoint,
    );
    if (!result.isSuccessful) {
      print(result.error);
      return null;
    }
    return result.value;
  }

  /// Utility method to easily query any chain endpoint and
  /// read the response as an [LcdResponse] object instance.
  /// If any exception is thrown, returns `null`.
  Future<LcdResponse> queryChain(String endpoint) async {
    try {
      final result = await queryChainRaw(endpoint);
      return result == null ? result : LcdResponse.fromJson(result);
    } catch (e) {
      print("LcdResponse parsing exception: $e");
      return null;
    }
  }

  /// Creates, sings and sends a transaction having the given [messages]
  /// and using the given [wallet].
  Future<TransactionResult> sendTx(List<StdMsg> messages, Wallet wallet) async {
    final data = TxData(messages, wallet);
    return compute(sendTxBackground, data);
  }

  Future<List<Transaction>> getTxsByHeight(String height) async {
    try {
      return await QueryHelper.getTxsByHeight(_lcdEndpoint, height);
    } catch (e) {
      Logger.log(e);
      return null;
    }
  }
}
