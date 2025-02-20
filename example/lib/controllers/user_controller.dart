import 'package:reign/reign.dart';
import '../models/user.dart';

class UserController extends ReignController<User?> {
  User? _user;
  bool _loading = false;
  Object? _error;

  UserController({required User? initialValue}) : super(initialValue);

  User? get user => _user;
  bool get isLoading => _loading;
  @override
  Object? get error => _error;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    await handleAsync<void>(() async {
      try {
        _loading = true;
        update();

        await Future.delayed(Duration(seconds: 1)); // Simulate API call
        _user = User('Reign User');
      } catch (e) {
        _error = e;
      } finally {
        _loading = false;
        update();
      }
    });
  }
}
