part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();
   @override
  List<Object> get props => [];
}

class UsersInitial extends UsersState {
  @override
  List<Object> get props => [];
}

class UsersEmpty extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;

  const UsersLoaded({@required this.users}) : assert(users != null);

  @override
  List<Object> get props => [users];
}

class UsersSearch extends UsersState {
  final List<User> users;

  const UsersSearch({@required this.users}) : assert(users != null);

  @override
  List<Object> get props => [users];
}

class UsersError extends UsersState {}

class UsersAdded extends UsersState {}

class UsersDeleted extends UsersState {}

class UserUpdated  extends UsersState {}
