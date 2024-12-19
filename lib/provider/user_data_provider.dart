import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider extends ChangeNotifier {
  var _userProfileImageUrl = '';
  var _username = '';
  var _email = '';
  var _phone = '';
  var _hash = '';
  var _fullname = '';

  String get userProfileImageUrl => _userProfileImageUrl;

  String get username => _username;

  String get email => _email;

  String get phone => _phone;

  String get password => _hash;

  String get fullname => _fullname;

  Future<void> loadAsync() async {
    final sharedPref = await SharedPreferences.getInstance();

    _username = sharedPref.getString("firstName") ?? '';
    _userProfileImageUrl = sharedPref.getString("imageUrl") ?? '';
    _email = sharedPref.getString("email") ?? '';
    _phone = sharedPref.getString("phone") ?? '';
    _hash = sharedPref.getString("password") ?? '';
    _fullname = sharedPref.getString("fullname") ?? '';

    notifyListeners();
  }

  Future<void> setUserDataAsync({
    String? userProfileImageUrl,
    String? username,
    String? email,
    String? phone,
    String? hash,
    String? fullname,
  }) async {
    final sharedPref = await SharedPreferences.getInstance();
    var shouldNotify = false;

    if (userProfileImageUrl != null &&
        userProfileImageUrl != _userProfileImageUrl) {
      _userProfileImageUrl = userProfileImageUrl;

      await sharedPref.setString("imageUrl", _userProfileImageUrl);

      shouldNotify = true;
    }

    if (username != null && username != _username) {
      _username = username;

      await sharedPref.setString("firstName", _username);

      shouldNotify = true;
    }

    if (email != null && email != _email) {
      _email = email;

      await sharedPref.setString("email", _email);

      shouldNotify = true;
    }

    if (phone != null && phone != _phone) {
      _phone = phone;

      await sharedPref.setString("phone", _phone);

      shouldNotify = true;
    }

    if (hash != null && hash != _hash) {
      _hash = hash;

      await sharedPref.setString("password", _hash);

      shouldNotify = true;
    }

    if (fullname != null && fullname != _fullname) {
      _fullname = fullname;

      await sharedPref.setString("fullname", _fullname);

      shouldNotify = true;
    }

    if (shouldNotify) {
      notifyListeners();
    }
  }

  Future<void> clearUserDataAsync() async {
    final sharedPref = await SharedPreferences.getInstance();

    await sharedPref.remove("firstName");
    await sharedPref.remove("imageUrl");

    _username = '';
    _userProfileImageUrl = '';

    notifyListeners();
  }

  bool isUserLoggedIn() {
    return _username.isNotEmpty;
  }
}
