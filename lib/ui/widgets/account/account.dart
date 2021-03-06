import 'package:alan/models/cosmos-sdk/query/account_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/blocs/account/account_bloc.dart';
import 'package:mooncake/ui/ui.dart';
import 'package:url_launcher/url_launcher.dart';

/// Represents the widget inside which all the users' account data
/// are displayed.
class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      bloc: AccountBloc.create()..add(LoadAccount()),
      builder: (context, state) {
        if (state is UninitializedAccount) {
          return Container();
        } else if (state is LoadingAccount) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LoadingIndicator(),
            ],
          );
        }

        final currentState = state as AccountLoaded;

        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          PostsLocalizations.of(context).accountTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      PostsLocalizations.of(context).yourAddress,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(currentState.account.address),
                    const SizedBox(height: 16),
                    Text(
                      PostsLocalizations.of(context).yourFunds,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Flexible(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: currentState.account.coins.length,
                        itemBuilder: (context, index) {
                          final coin = currentState.account.coins[index];
                          return Text("${coin.amount} ${coin.denom}");
                        },
                      ),
                    )
                  ],
                ),
              ),
              RaisedButton(
                child: Text(PostsLocalizations.of(context).openInExplorer),
                onPressed: () => _openInExplorer(currentState.account),
              )
            ],
          ),
        );
      },
    );
  }

  _openInExplorer(AccountData account) async {
    final url = "https://morpheus.desmos.network/account/${account.address}";
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
