import '../../domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    required super.id,
    required super.name,
    required super.email,
    required super.mobile,
    required super.country,
    required super.state,
    required super.district,
    required super.avatar,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'No Name',
      email: (json['email'] ?? json['emailId'])?.toString() ?? 'No Email',
      mobile: json['mobile']?.toString() ?? 'No Mobile',
      country: json['country']?.toString() ?? 'Unknown',
      state: json['state']?.toString() ?? 'Unknown',
      district: json['district']?.toString() ?? 'Unknown',
      avatar: json['avatar']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'country': country,
      'state': state,
      'district': district,
      'avatar': avatar,
    };
  }

  factory EmployeeModel.fromEntity(Employee entity) {
    return EmployeeModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      mobile: entity.mobile,
      country: entity.country,
      state: entity.state,
      district: entity.district,
      avatar: entity.avatar,
    );
  }
}
