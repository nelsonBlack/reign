<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Reign

A lightweight yet powerful state management solution for Flutter applications. Reign combines simple syntax with robust
functionality inspired by popular state management patterns, optimized for Flutter's widget tree.

## Features

- 🌀 **Lifecycle-aware controllers** - Automatic init/ready/dispose states
- 🔗 **Dependency injection** - Effortless controller access anywhere
- ⚡ **Reactive state management** - Smart widget rebuilds on updates
- 🛡️ **Error handling** - Clear exception hierarchy for common issues
- 🧪 **Test utilities** - Built-in mocks and widget test helpers

## Getting Started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  reign: ^0.1.0
```

## Usage

### Basic Counter Example

```dart
// Create controller
class CounterController extends ReignController {
  int count = 0;

  void increment() {
    count++;
    update(); // Trigger UI rebuild
  }
}

// In widget tree
ControllerProvider(
  create: () => CounterController(),
  child: ControllerConsumer<CounterController>(
    builder: (context, controller) => Text(
      'Count: ${controller.count}',
      style: Theme.of(context).textTheme.headline4,
    ),
  ),
)
```

### Advanced Usage: Dependent Controllers

```dart
class AuthController extends ReignController {
  final userService = dependOn<UserService>();
  // ...
}

class UserService extends ReignController {
  Future<User> getUser() async {
    // API call implementation
  }
}

// Setup
ReignMultiProvider(
  controllers: [UserService(), AuthController()],
  child: MyApp(),
)
```

## Advanced Patterns

### Shared State Management Across Screens

```dart
// services/app_config.dart
class AppConfigController extends ReignController {
  ThemeMode _theme = ThemeMode.light;
  Locale _locale = const Locale('en');

  ThemeMode get theme => _theme;
  Locale get locale => _locale;

  void updateTheme(ThemeMode newTheme) {
    _theme = newTheme;
    update();
  }

  void updateLocale(Locale newLocale) {
    _locale = newLocale;
    update();
  }
}

// screens/settings_screen.dart
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final config = ControllerProvider.of<AppConfigController>(context);
    return Column(
      children: [
        SwitchListTile(
          title: Text('Dark Mode'),
          value: config.theme == ThemeMode.dark,
          onChanged: (val) => config.updateTheme(
            val ? ThemeMode.dark : ThemeMode.light
          ),
        ),
        DropdownButton<Locale>(
          value: config.locale,
          items: [Locale('en'), Locale('es')].map((locale) {
            return DropdownMenuItem(
              value: locale,
              child: Text(locale.languageCode.toUpperCase()),
            );
          }).toList(),
          onChanged: (loc) => loc != null ? config.updateLocale(loc) : null,
        ),
      ],
    );
  }
}
```

### Service Layer Architecture

```dart
// services/api_client.dart
class ApiClient extends ReignController {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));

  Future<User> fetchUser(int id) async {
    final response = await _dio.get('/users/$id');
    return User.fromJson(response.data);
  }

  Future<List<Post>> fetchPosts() async {
    final response = await _dio.get('/posts');
    return (response.data as List).map((e) => Post.fromJson(e)).toList();
  }
}

// controllers/user_controller.dart
class UserController extends ReignController {
  final ApiClient _api = dependOn<ApiClient>();
  User? _currentUser;
  List<Post> _posts = [];

  User? get user => _currentUser;
  List<Post> get posts => _posts;

  Future<void> loadUserData(int userId) async {
    _currentUser = await _api.fetchUser(userId);
    _posts = await _api.fetchPosts();
    update();
  }
}

// main.dart
void main() {
  runApp(
    ReignMultiProvider(
      controllers: [
        ApiClient(),
        UserController(),
        AppConfigController(),
      ],
      child: MyApp(),
    ),
  );
}
```

### Angular-like Dependency Injection

```dart
// services/analytics_service.dart
class AnalyticsService extends ReignController {
  void trackEvent(String event) {
    // Implementation details
  }
}

// controllers/cart_controller.dart
class CartController extends ReignController {
  final AnalyticsService _analytics = dependOn<AnalyticsService>();
  final List<Product> _items = [];

  List<Product> get items => _items;

  void addToCart(Product product) {
    _items.add(product);
    _analytics.trackEvent('cart_add');
    update();
  }
}
```

Key Features:

1. 🏗️ Service Layer Pattern - Business logic separated from UI
2. 🌐 Global State Management - Shared across entire app
3. 🔄 Reactive Updates - Automatic UI refresh on data changes
4. 💉 Dependency Injection - Hierarchical service resolution
5. 🔒 Type-Safe Access - Compile-time checked dependencies

## Testing

Validate your state management with our test utilities:

```bash
# Run all tests
flutter test

# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Run specific test groups
flutter test test/unit/    # Unit tests
flutter test test/widget/   # Widget tests
```

### Test Configuration

```yaml
dev_dependencies:
  test_cov_console: ^2.2.0
  mocktail: ^0.3.0
```

### Linux Requirements

```bash
sudo apt-get install lcov
```

## Error Handling Examples

```dart
try {
  final controller = ControllerStore.instance.get<NonExistentController>();
} on ControllerNotFoundError catch (e) {
  print('Error: ${e.message}');
}

try {
  ControllerStore.instance.register(alreadyRegisteredController);
} on ControllerAlreadyRegisteredError catch (e) {
  print('Conflict: ${e.message}');
}
```

## Additional Information

- **Documentation**: [View API Reference](https://github.com/yourusername/reign/docs)
- **Contributing**: Open an issue or PR on [GitHub](https://github.com/yourusername/reign)
- **Support**: Email support@reign.dev or join our Discord community

Made with ❤️ by Flutter developers, for Flutter developers.

## Shining Examples ✨

### 🌓 Theme Switcher Example

```dart
class ThemeController extends ReignController {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get currentTheme => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    update();
  }
}

class ThemeSwitcherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ControllerProvider(
      create: () => ThemeController(),
      child: ControllerConsumer<ThemeController>(
        builder: (context, themeCtrl) => MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeCtrl.currentTheme,
          home: Scaffold(
            appBar: AppBar(title: Text('Theme Demo')),
            floatingActionButton: FloatingActionButton(
              onPressed: themeCtrl.toggleTheme,
              child: Icon(Icons.color_lens),
            ),
          ),
        ),
      ),
    );
  }
}
```

### 🛒 Todo List Manager

```dart
class TodoController extends ReignController {
  final List<Todo> _todos = [];
  final TodoService _service = dependOn<TodoService>();

  List<Todo> get todos => _todos;

  Future<void> loadTodos() async {
    _todos = await _service.fetchTodos();
    update();
  }

  void addTodo(String text) {
    _todos.add(Todo(text));
    update();
  }
}

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final todoCtrl = ControllerProvider.of<TodoController>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Todos')),
      body: ControllerConsumer<TodoController>(
        builder: (context, controller) => ListView.builder(
          itemCount: controller.todos.length,
          itemBuilder: (ctx, i) => ListTile(
            title: Text(controller.todos[i].text),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTodoDialog(context, todoCtrl),
        child: Icon(Icons.add),
      ),
    );
  }
}
```

### 🌐 API Data Loader

```dart
class UserController extends ReignController {
  User? _user;
  bool _loading = false;

  User? get user => _user;
  bool get isLoading => _loading;

  Future<void> fetchUser() async {
    _loading = true;
    update();

    try {
      _user = await dependOn<UserService>().getUser();
    } finally {
      _loading = false;
      update();
    }
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userCtrl = ControllerProvider.of<UserController>(context);

    return ControllerConsumer<UserController>(
      builder: (context, controller) => Scaffold(
        body: Center(
          child: controller.isLoading
              ? CircularProgressIndicator()
              : controller.user != null
                  ? Text('Welcome ${controller.user!.name}!')
                  : Text('No user data'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.fetchUser,
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
```

### 🧪 Testing Made Easy

```dart
void main() {
  test('Counter increments', () {
    final controller = CounterController();
    expect(controller.count, 0);

    controller.increment();
    expect(controller.count, 1);
  });

  testWidgets('UI reflects counter state', (tester) async {
    await tester.pumpWidget(
      ControllerProvider(
        create: () => CounterController(),
        child: MaterialApp(home: CounterScreen()),
      ),
    );

    expect(find.text('0'), findsOneWidget);
    ControllerStore.instance.get<CounterController>().increment();
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });
}
```

Key Features Showcased:

1. 🎨 Theming System - App-wide theme management
2. 📝 List Management - Complex data handling
3. ⏳ Loading States - Async operation tracking
4. 🔄 Data Refresh - Easy state updates
5. 🧪 Test Integration - Full test coverage

## Versioning Policy

Reign follows [Semantic Versioning 2.0.0](https://semver.org/):

- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible functionality additions
- **PATCH** version for backwards-compatible bug fixes

Pre-1.0 versions (current 0.x.y) may contain experimental changes. Check the [CHANGELOG.md](CHANGELOG.md) for detailed release notes.

### Version Compatibility Guide

| Reign Version | Flutter SDK | Status         |
| ------------- | ----------- | -------------- |
| ^0.2.0        | >=3.0.0     | Current Stable |
| ^0.1.0        | >=2.10.0    | Legacy Support |
