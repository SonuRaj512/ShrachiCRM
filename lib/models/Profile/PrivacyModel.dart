class PrivacyPolicyModel {
  final String title;
  final String content;

  PrivacyPolicyModel({
    required this.title,
    required this.content,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      title: json['data']['title'],
      content: json['data']['content'],
    );
  }
}
class PolicyModel {
  final String title;
  final String content;

  PolicyModel({
    required this.title,
    required this.content,
  });

  factory PolicyModel.fromJson(Map<String, dynamic> json) {
    return PolicyModel(
      title: json['data']['title'],
      content: json['data']['content'],
    );
  }
}
