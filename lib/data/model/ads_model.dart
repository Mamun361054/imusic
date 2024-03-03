
class AdModel{
  final int? id;
  final String? name;
  final String? image;

  AdModel({this.id, this.name, this.image});

  factory AdModel.fromJson(Map<String,dynamic> json){
    return AdModel(
      id: json['id'],
      name: json['name'],
      image: json['thumbnail']
    );
  }
}