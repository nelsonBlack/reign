import 'package:reign/reign.dart';

class UserController extends ReignController {
  String? _user;
  bool _loading = false;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  String? currentUser() => _user;
  bool isLoading() => _loading;

  Future<void> fetchUser() async {
    _loading = true;
    update();

    await Future.delayed(const Duration(seconds: 1));
    _user = 'Reign User';
    _loading = false;
    update();
  }
}
