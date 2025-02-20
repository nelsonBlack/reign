import 'package:flutter/material.dart';
import 'package:reign/reign.dart';
import 'package:reign/widgets/reign_builder.dart';
import '../controllers/user_controller.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ReignBuilder<UserController>(
      create: () => UserController(initialValue: null),
      loading: const Center(child: CircularProgressIndicator()),
      error: (error) => Center(child: Text('Error: $error')),
      builder: (context, controller) => Scaffold(
        appBar: AppBar(title: const Text('User Profile')),
        body: Center(
          child: controller.user != null
              ? Text('Welcome ${controller.user!.name}')
              : const Text('No user data'),
        ),
      ),
    );
  }
}
