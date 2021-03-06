import 'package:flutter/material.dart';
import 'package:mooncake/entities/entities.dart';

/// Contains the info that are shown on top of a [PostItem]. The following
/// data are :
/// - the owner o the post
/// - the block height at which the post has been created
///
/// TODO: Add the username (maybe using Starnames?)
class PostItemHeader extends StatelessWidget {
  final Post post;

  PostItemHeader({
    @required this.post,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(
            post.owner,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey[500],
            ),
          ),
        ),
      ],
    );
  }
}
