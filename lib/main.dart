import 'package:blaze_test/bloc/bloc/users_bloc.dart';
import 'package:blaze_test/model/user.dart';
import 'package:blaze_test/repository/user_api_client.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';

import 'content.dart';
import 'repository/user_repository.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UsersRepository repository = UsersRepository(
      usersApiClient: UsersApiClient(
        httpClient: http.Client(),
      ),
    );
    return MaterialApp(
      title: 'Blaze Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => UsersBloc(repository: repository),
        child: MyHomePage(title: 'Blaze Test'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<User> users = [];

  int tag = 0;
  List<String> options = [
    'Name',
    'Last name',
    'Email',
    'Phone number',
  ];
  ScrollController _scrollController = ScrollController();
  TextEditingController editingController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List<TextEditingController> _controllersName = new List();
  List<TextEditingController> _controllersEmail = new List();
  List<TextEditingController> _controllersPhone = new List();
  List<bool> _isEnabledName = new List();
  List<bool> _isEnabledPhone = new List();
  List<bool> _isEnabledEmail = new List();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  User newUser = new User();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UsersBloc>(context)
        .add(FetchUsers(lastId: "0", sort: options[tag]));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(screenHeight * .05), // here the desired height
          child: AppBar(
            title: Text(widget.title),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            searchInput(screenWidth, screenHeight),
            sortBy(screenWidth, screenHeight),
            addUser(),
            Expanded(
                child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!isLoading &&
                    _scrollController.offset ==
                        scrollInfo.metrics.maxScrollExtent) {
                  BlocProvider.of<UsersBloc>(context).add(FetchUsers(
                      lastId: users[users.length - 1].id, sort: options[tag]));
                  setState(() {
                    isLoading = true;
                  });
                }
                return true;
              },
              child: usersList(screenWidth, screenHeight, users),
            )),
            loading()
          ],
        ),
      ),
    );
  }

  Widget sortBy(screenWidth, screenHeight) {
    return Container(
        height: screenHeight * .2,
        padding: EdgeInsets.all(0),
        child: ListView(padding: EdgeInsets.all(5), children: <Widget>[
          Content(
            title: 'Sort by',
            child: ChipsChoice<int>.single(
              value: tag,
              options: ChipsChoiceOption.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
              onChanged: (val) => setState(() => tag = val),
            ),
          )
        ]));
  }

  Widget searchInput(screenWidth, screenHeight) {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
        child: TextField(
          textAlign: TextAlign.center,
          onChanged: (value) {},
          onSubmitted: (value) {
            if (editingController.text != null &&
                editingController.text != "") {
              handleQuery(editingController.text);
            }
          },
          controller: editingController,
          decoration: InputDecoration(
              labelText: "Search",
              hintText: "Search",
              suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (editingController.text != null &&
                        editingController.text != "") {
                      handleQuery(editingController.text);
                    }
                  }),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
        ));
  }

  Widget usersList(screenWidth, screenHeight, users) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        _controllersName.add(new TextEditingController());
        _controllersEmail.add(new TextEditingController());
        _controllersPhone.add(new TextEditingController());
        _isEnabledName.add(false);
        _isEnabledEmail.add(false);
        _isEnabledPhone.add(false);
        return Container(
          child: _buildCard(screenWidth, screenHeight, users[index], index),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _buildCard(screenWidth, screenHeight, User user, int index) =>
      Container(
        height: screenHeight *
            .3278, //(screenHeight * .3245 < 224) ? 224 : screenHeight * .3245,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: TextField(
                    controller: _controllersName[index],
                    enabled: _isEnabledName[index],
                    decoration: InputDecoration(
                      hintText: user.name + ' ' + user.lastName,
                    ),
                    style: TextStyle(fontWeight: FontWeight.w500)),
                leading: Icon(
                  Icons.people,
                  color: Colors.blue[500],
                ),
                trailing: InkWell(
                  child: Icon(Icons.edit),
                  onTap: () {
                    setState(() {
                      _isEnabledName[index] = !_isEnabledName[index];
                    });
                  },
                ),
              ),
              ListTile(
                title: TextField(
                    controller: _controllersPhone[index],
                    enabled: _isEnabledPhone[index],
                    decoration: InputDecoration(
                      hintText: user.phoneNumber,
                    ),
                    style: TextStyle(fontWeight: FontWeight.w500)),
                leading: Icon(
                  Icons.phone,
                  color: Colors.blue[500],
                ),
                trailing: InkWell(
                  child: Icon(Icons.edit),
                  onTap: () {
                    setState(() {
                      _isEnabledPhone[index] = !_isEnabledPhone[index];
                    });
                  },
                ),
              ),
              ListTile(
                title: TextField(
                    controller: _controllersEmail[index],
                    enabled: _isEnabledEmail[index],
                    decoration: InputDecoration(
                      hintText: user.email,
                    ),
                    style: TextStyle(fontWeight: FontWeight.w500)),
                leading: Icon(
                  Icons.mail,
                  color: Colors.blue[500],
                ),
                trailing: InkWell(
                  child: Icon(Icons.edit),
                  onTap: () {
                    setState(() {
                      _isEnabledEmail[index] = !_isEnabledEmail[index];
                    });
                  },
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: FlatButton(
                      child: const Text('Erase',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        handleErase(user, index);
                      },
                    )),
                (_isEnabledEmail[index] ||
                        _isEnabledName[index] ||
                        _isEnabledPhone[index])
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: FlatButton(
                          child: const Text('Save',
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.blue)),
                          onPressed: () {
                            handleSave(user, index);
                          },
                        ))
                    : Container()
              ])
            ],
          ),
        ),
      );

  handleSave(User user, int index) {
    setState(() {
      user.name = (_controllersName[index].text.contains(" ") &&
              _controllersName[index].text.split(" ")[0] != null &&
              _controllersName[index].text.split(" ")[0] != "")
          ? _controllersName[index].text.split(" ")[0]
          : user.name;
      user.lastName = (_controllersName[index].text.contains(" ") &&
              _controllersName[index].text.split(" ")[1] != null &&
              _controllersName[index].text.split(" ")[1] != "")
          ? _controllersName[index].text.split(" ")[1]
          : user.lastName;
      user.phoneNumber = (_controllersPhone[index].text != null &&
              _controllersPhone[index].text != "")
          ? _controllersPhone[index].text
          : user.phoneNumber;
      user.email = (_controllersEmail[index].text != null &&
              _controllersEmail[index].text != "")
          ? _controllersEmail[index].text
          : user.email;
      _isEnabledEmail[index] = false;
      _isEnabledName[index] = false;
      _isEnabledPhone[index] = false;
    });
    BlocProvider.of<UsersBloc>(context).add(UpdateUsers(user: user));
  }

  handleErase(user, index) {
    setState(() {
      BlocProvider.of<UsersBloc>(context).add(DeleteUsers(user: user));
      _controllersName.removeAt(index);
      _controllersEmail.removeAt(index);
      _controllersPhone.removeAt(index);
      _isEnabledName.removeAt(index);
      _isEnabledEmail.removeAt(index);
      _isEnabledPhone.removeAt(index);
      users.removeAt(index);
    });
  }

  handleQuery(value) {
    BlocProvider.of<UsersBloc>(context).add(FetchUsersQuery(query: value));
  }

  handleAdd(User user) {
    BlocProvider.of<UsersBloc>(context).add(AddUsers(user: user));
  }

  void setLoading(bool load) {
    setState(() {
      isLoading = load;
    });
  }

  loading() {
    return BlocListener<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state is UsersEmpty) {
          BlocProvider.of<UsersBloc>(context).add(
              FetchUsers(lastId: users[users.length].id, sort: options[tag]));
        }
        if (state is UsersError) {
          setLoading(false);
        }
        if (state is UsersLoading) {
          setLoading(true);
        }

        if (state is UsersSearch) {
          _scrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
          setState(() {
            users = state.users;
          });
          setLoading(false);
          BlocProvider.of<UsersBloc>(context)
              .add(FetchUsers(lastId: "0", sort: options[tag]));
        }
        if (state is UsersAdded) {
          Toast.show("User Added", context, duration: 3, gravity: Toast.CENTER);
          setLoading(false);
        }

        if (state is UsersDeleted) {
          Toast.show("User Deleted", context,
              duration: 3, gravity: Toast.CENTER);
          setLoading(false);
        }

        if (state is UsersLoaded) {
          setState(() {
            if (users == null) {
              users = state.users;
            } else {
              users.addAll(state.users);
            }
          });
          setLoading(false);
        }

        if (state is UserUpdated) {
          Toast.show("User Updated", context,
              duration: 3, gravity: Toast.CENTER);
          setLoading(false);
        }
      },
      child: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          return (isLoading) ? CircularProgressIndicator() : Container();
        },
      ),
    );
  }

  Widget addUser() {
    return FlatButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      right: -40.0,
                      top: -40.0,
                      child: InkResponse(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: CircleAvatar(
                          child: Icon(Icons.close),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    newUser.name = value;
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Name",
                                      hintText: "Name",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0))))),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    newUser.lastName = value;
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Last Name",
                                      hintText: "Last Name",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0))))),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    newUser.phoneNumber = value;
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Phone Number",
                                      hintText: "Phone Number",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0))))),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    newUser.email = value;
                                  },
                                  decoration: InputDecoration(
                                      labelText: "Email",
                                      hintText: "Email",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25.0))))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FlatButton(
                                child: const Text('Add User',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Colors.blue)),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    handleAdd(newUser);
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      },
      child: Text("Add User", style: TextStyle(color: Colors.blue)),
    );
  }
}
