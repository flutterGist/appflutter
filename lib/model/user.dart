import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User
{
  String id;
  String name;
  String lastName;
  String email;
  String phoneNumber;
  bool selected = false;

  User({
    this.id,
    this.name,
    this.lastName,
    this.email,
    this.phoneNumber}
  );

  List<Object> get props => [id,name, lastName, email,phoneNumber];

  static User fromJson(dynamic json) {
    return User(
      id : json['_id'],
      name: json['name'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

static List<User> fromJsonList(List<dynamic> jsonList){
  List<User> items = new List();
    if(jsonList==null){
      return items;
    }else{
      for (var item in jsonList) {
        final user = fromJson(item);
        items.add(user);
      }
    }
    return items;
  }

Map<String, dynamic> toJson() =>
    {
      "name": name,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "email":email
    };

}