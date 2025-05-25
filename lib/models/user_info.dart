import 'package:histocr_app/models/occupation.dart';

class UserInfo {
  final String id;
  final String name;
  final String email;
  Occupation? job;
  String? customJobName;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
    this.job,
    this.customJobName,
  });

  String get jobName {
    if (job == null) {
      return 'Você ainda não cadastrou uma profissão';
    } else if (job?.name == "Outro") {
      return customJobName ?? '';
    }
    return job!.name;
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      job: json['jobs'] != null ? Occupation.fromJson(json['jobs']) : null,
      customJobName: json['custom_job_name'],
    );
  }
}
