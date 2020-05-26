import 'dart:convert';

import 'package:blaze_test/bloc/bloc/users_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'package:blaze_test/model/user.dart';

class UsersApiClient {
  final _baseUrl = 'http://192.168.1.2:5000/api';
  final http.Client httpClient;
  Map<String, String>  headerMix = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };

  UsersApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<List<User>> fetchUsers(lastId,sort) async {
    final url = '$_baseUrl/user/';
    final response = await this.httpClient.get(url+lastId+"/"+sort);
    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }
    final json = jsonDecode(response.body);
    print(json);
    return User.fromJsonList(json['data']);
  }

  Future<List<User>> fetchUserQuery(String query) async {
    final url = '$_baseUrl/query/';
    final response = await this.httpClient.get(url+query);

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }
  
    final json = jsonDecode(response.body);
    print(json);
    return User.fromJsonList(json['data']);
  }


  Future<void> deleteUsers(DeleteUsers event) async {
    final url = '$_baseUrl/delete/';
    final response = await this.httpClient.delete(url+event.user.id);

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    
    return;
  }

  Future<void> updateUsers(UpdateUsers event) async {
    final url = '$_baseUrl/update/';
    var json = jsonEncode(event.user.toJson());
    final response = await this.httpClient.put(url + event.user.id , body: json ,headers: headerMix);

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    return ;
  }
  
  
  Future<List<User>> queryUsers() async {
    final url = '$_baseUrl/5ecaff403000004e00ddd487';
    final response = await this.httpClient.get(url);

    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    final json = jsonDecode(response.body);
    return User.fromJsonList(json);
  }

  Future<void> addUsers(AddUsers event) async {
    final url = '$_baseUrl/add';
    var json = jsonEncode(event.user.toJson());
    final response = await this.httpClient.post(url,body: json,headers: headerMix);
    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }

    return ;
  }

}