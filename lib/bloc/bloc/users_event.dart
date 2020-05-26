part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();
}

class FetchUsers extends UsersEvent {
  final sort;
  final lastId;
  const FetchUsers({@required this.sort,this.lastId});

  @override
  List<Object> get props => [sort,lastId];
}

class FetchUsersQuery extends UsersEvent {
  final query;
  const FetchUsersQuery({@required this.query});

  @override
  List<Object> get props => [query];
}


class AddUsers extends UsersEvent {
  final User user;
  
  AddUsers({@required this.user});

  @override
  List<Object> get props => [user];
}

class DeleteUsers extends UsersEvent {
  final User user;
  
  DeleteUsers({@required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateUsers extends UsersEvent {
  final User user;
  
  UpdateUsers({@required this.user});

  @override
  List<Object> get props => [user];
}