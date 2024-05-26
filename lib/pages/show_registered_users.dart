import 'package:flutter/material.dart';
import '../database_helper.dart';

class ShowRegisteredUsersPage extends StatefulWidget {
  @override
  _ShowRegisteredUsersPageState createState() => _ShowRegisteredUsersPageState();
}

class _ShowRegisteredUsersPageState extends State<ShowRegisteredUsersPage> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    List<Map<String, dynamic>> users = await dbHelper.getUsers();
    setState(() {
      _users = users;
    });
  }

  Future<void> _deleteUser(int id) async {
    await dbHelper.deleteUser(id);
    _loadUsers(); // Refresh the user list
  }

  Future<bool> _showConfirmationDialog(BuildContext context, String username) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete the user "$username"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    // If the dialog returns null, we consider it as false (i.e., the user did not confirm the deletion)
    return result ?? false;
  }

  Future<void> _showEncryptedPasswordDialog(BuildContext context, String username, String encryptedPassword) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Encrypted Password'),
          content: Text('The encrypted password for "$username" is:\n\n$encryptedPassword'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 14, 33),
        title: Text(
          'Registered Users',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Set back button color to white
      ),
      backgroundColor: Color.fromARGB(255, 10, 14, 33),
      body: _users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _users[index]['username'],
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _showEncryptedPasswordDialog(context, _users[index]['username'], _users[index]['password']);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      bool confirmed = await _showConfirmationDialog(context, _users[index]['username']);
                      if (confirmed) {
                        _deleteUser(_users[index]['id']);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
