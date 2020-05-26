import 'dart:async';

import 'package:blaze_test/model/user.dart';
import 'package:blaze_test/repository/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {

  final UsersRepository repository;

  UsersBloc({@required this.repository}) : assert(repository != null);

  @override
  UsersState get initialState => UsersInitial();

  @override
  Stream<UsersState> mapEventToState(
    UsersEvent event,
  ) async* {
    if (event is FetchUsers) {
      yield UsersLoading();
      try {
        final List<User> users = await repository.fetchUsers(event.lastId,event.sort);
        yield UsersLoaded(users: users);
      } catch (_) {
        yield UsersError();
      }
    }
    else if(event is AddUsers)
    {
        yield UsersLoading();
      try {
        await repository.addUsers(event);
        yield UsersAdded();
      } catch (_) {
        yield UsersError();
      }
    }
    else if(event is DeleteUsers)
    {
        yield UsersLoading();
      try {
        await repository.deleteUsers(event);
        yield UsersDeleted();
      } catch (_) {
        yield UsersError();
      }
    }
    else if(event is UpdateUsers)
    {
        yield UsersLoading();
      try {
        await repository.updateUsers(event);
        yield UserUpdated();
      } catch (_) {
        yield UsersError();
      }
    }
    else if(event is FetchUsersQuery)
    {
        yield UsersLoading();
      try {
        final List<User> users = await repository.fetchQuery(event.query);
        yield UsersSearch(users: users);
      } catch (_) {
        yield UsersError();
      }
    }
  }
}