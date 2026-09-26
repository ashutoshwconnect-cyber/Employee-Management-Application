import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String country;
  final String state;
  final String district;
  final String avatar;

  const Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.country,
    required this.state,
    required this.district,
    required this.avatar,
  });

  @override
  List<Object?> get props => [id, name, email, mobile, country, state, district, avatar];
}
