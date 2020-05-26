import 'dart:async';

import 'package:blaze_test/bloc/bloc/users_bloc.dart';
import 'package:blaze_test/model/user.dart';
import 'package:blaze_test/repository/user_api_client.dart';
import 'package:meta/meta.dart';



class UsersRepository {
  final UsersApiClient usersApiClient;

  UsersRepository({@required this.usersApiClient})
      : assert(usersApiClient != null);

  Future<List<User>> fetchUsers(lastId,sort) async {
    return await usersApiClient.fetchUsers(lastId,sort);
  }

   Future<void> addUsers(AddUsers event) async {
    return await usersApiClient.addUsers(event);
  }

  Future<void> deleteUsers(DeleteUsers event) async {
    return await usersApiClient.deleteUsers(event);
  }

   Future<void> updateUsers(UpdateUsers event) async {
    return await usersApiClient.updateUsers(event);
  }

  Future<List<User>> fetchQuery(String query) async {
    return await usersApiClient.fetchUserQuery(query);
  }
}