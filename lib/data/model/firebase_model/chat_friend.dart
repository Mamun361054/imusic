class ChatProfile {
  final String? name;
  final String? email;
  final String? uid;
  final String? status;
  final String? image;
  final String? identity;
  final String? token;

  ChatProfile(
      {this.uid,
      this.name,
      this.email,
      this.status,
      this.image,
      this.identity,
      this.token});

  factory ChatProfile.fromJson(Map<dynamic, dynamic> json) {
    return ChatProfile(
        uid: json['uid'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        status: json['status'] ?? 'welcome to aeroMeet',
        image: json['image'],
        token: json['token'],
        identity: json['identity'] ?? '');
  }

  Map<dynamic, dynamic> toJson() {
    final data = {
      'uid': uid,
      'name': name,
      'email': email,
      'status': status,
      'image': image,
      'token': token,
      'identity': identity,
    };
    return data;
  }
}
