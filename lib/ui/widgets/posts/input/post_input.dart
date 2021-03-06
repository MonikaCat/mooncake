import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mooncake/ui/ui.dart';

/// Form that is used while creating a new post, or a comment for the
/// given [postId].
class PostForm extends StatefulWidget {
  final String hint;
  final bool expanded;
  final String postId;

  const PostForm({
    Key key,
    @required this.hint,
    this.postId,
    this.expanded = false,
  }) : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  TextEditingController _messageController = TextEditingController();

  PostInputBloc _bloc;

  bool isCommentButtonEnabled(PostInputState state) {
    return state.isValid;
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _messageController.addListener(_onMessageChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostInputBloc, PostInputState>(
      builder: (context, state) {
        if (state == PostInputState.empty()) {
          _reset();
        }

        final textInput = TextFormField(
          expands: widget.expanded,
          maxLines: widget.expanded ? null : 1,
          minLines: widget.expanded ? null : 1,
          controller: _messageController,
          key: PostsKeys.postMessageField,
          autofocus: false,
          decoration: InputDecoration(
            hintText: widget.hint,
          ),
          autocorrect: false,
        );

        return Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (widget.expanded) Expanded(child: textInput) else textInput
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  /// Called when the comment button has been clicked.
  void _reset() {
    // Reset the form and close the keyboard
    _messageController.clear();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  /// Called when the message has changed.
  void _onMessageChanged() {
    _bloc.add(MessageChanged(_messageController.text));
  }
}
