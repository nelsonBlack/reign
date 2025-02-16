import 'package:flutter/material.dart';
import 'package:reign/reign.dart';
import '../controllers/user_controller.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userCtrl = ControllerProvider.of<UserController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: ControllerConsumer<UserController>(
        builder: (context, controller) => Center(
          child: controller.isLoading()
              ? const CircularProgressIndicator()
              : Text('Welcome ${controller.currentUser()}!'),
        ),
      ),
    );
  }
}
