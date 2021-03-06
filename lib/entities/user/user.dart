import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user.g.dart';

/// Contains the data of a user.
@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  @JsonKey(name: "address")
  final String address;

  @JsonKey(name: "username")
  final String username;

  @JsonKey(name: "avatar_url")
  final String avatarUrl;

  bool get hasUsername => username != null && username.isNotEmpty;
  bool get hasAvatar => avatarUrl != null && avatarUrl.isNotEmpty;

  User({
    @required this.address,
    this.username,
    this.avatarUrl,
  })  : assert(address != null),
        assert(address.isNotEmpty);

  @override
  List<Object> get props => [address, username, avatarUrl];

  // DONT COVER
  @override
  String toString() => 'User { '
      'address: $address, '
      'username: $username, '
      'avatarUrl : $avatarUrl '
      '}';

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
