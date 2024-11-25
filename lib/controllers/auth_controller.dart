import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:travel_management/apis/auth.dart';

class AuthController extends GetxController {
  final storage = GetStorage();

  final _isLogin = false.obs;
  final _accessToken = ''.obs;
  final _email = ''.obs;
  final _password = ''.obs;
  final _user = {}.obs;

  // Getters
  bool get isLogin => _isLogin.value;
  String get accessToken => _accessToken.value;
  dynamic get user => _user;
  String get email => _email.value;
  String get password => _password.value;

  // Setters
  set isLogin(bool value) {
    _isLogin.value = value;
    storage.write('isLogin', value);
  }

  set accessToken(String value) {
    _accessToken.value = value;
    storage.write('accessToken', value);
  }

  set user(dynamic value) {
    _user.value = value;
    storage.write('user', value);
  }

  set email(String value) => _email.value = value;

  set password(String value) => _password.value = value;

  @override
  void onInit() {
    super.onInit();
    _isLogin.value = storage.read('isLogin') ?? false;
    _accessToken.value = storage.read('accessToken') ?? '';
    _user.value = storage.read('user') ?? {};
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await GetConnect().post(AuthEnpoints.login, {
        'email': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.body['metadata'];
        accessToken = data['accessToken'];
        user = data['user'];
        isLogin = true;

        return Future.value(user);
      } else {
        return Future.error(response.body['message']);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  void logout() {
    accessToken = '';
    user = {};
    isLogin = false;
    storage.erase();
  }
}
