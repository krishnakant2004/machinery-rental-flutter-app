import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/services/api.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';
import '../screens/auth/login_screen.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../utils/snack_bar_helper.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final HttpService service = HttpService();
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  final _storage = GetStorage();

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _storage.hasData('token');

  //text fields
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //get foam key
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  Future<bool> checkAuthStatus() async {
    if (isAuthenticated) {
      try {
        await fetchUserProfile();
        return true;
      } catch (e) {
        if (kDebugMode) {
          print('Auth check failed: $e');
        }
        await logOutUser();
      }
    }
    return false;
  }

  Future<void> login() async {
    try {
      Map<String, dynamic> loginData ={
      'email': _emailController.text,
      'password': _passwordController.text,
      };

      final response = await service.login(
          endpointUrl: 'auth/login', itemData: loginData);

      if (response.statusCode == 408) {
        throw TimeoutException(
            response.body?['message'] ?? 'Connection timeout');
      }

      if (response.isOk) {
        final ApiResponse<User> apiResponse = ApiResponse<User>.fromJson(
            response.body,
                (json) => User.fromJson(json as Map<String, dynamic>));
        if (apiResponse.success == true) {

          _user = apiResponse.data;  //Ensure _user is updated
          await saveLoginInfo(_user!);  //  Store user info
          await _storage.write('token', response.body['token']);
          notifyListeners();  //  Notify listeners immediately

          SnackBarHelper.showSuccessSnackBar(apiResponse.message);


        } else {
          SnackBarHelper.showErrorSnackBar('Failed to Login: ${apiResponse.message}');
        }
      } else {
        final errorMessage = 'Error ${response.body?['message'] ?? response.statusText}';
        SnackBarHelper.showErrorSnackBar(errorMessage);
      }
    } on TimeoutException {
      final message = 'Connection timeout. Please check your internet connection.';
      SnackBarHelper.showErrorSnackBar(message);
    } catch (e) {
      final message =  '$e';
      SnackBarHelper.showErrorSnackBar(message);
    }
  }


  Future<void> register(Map<String, dynamic> userData) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _apiService.register(userData);
    } catch (e) {
      throw e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await _apiService.getUserProfile();
      _user = User.fromJson(response);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching profile: $e');
      }
      throw e.toString();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.updateUserProfile(profileData);
      _user = User.fromJson(response);
      saveLoginInfo(_user);
      if (kDebugMode) {
        print('Profile updated successfully');
        print('Updated user data: ${_user?.toJson()}');
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile: $e');
      }
      throw e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String,dynamic>?> saveLoginInfo(User? loginUser) async {
    await _storage.write(USER_INFO_BOX, loginUser?.toJson());
    Map<String, dynamic>? userJson = _storage.read(USER_INFO_BOX);
    return userJson;
  }

  User? getLoginUsr() {
    Map<String, dynamic>? userJson = _storage.read(USER_INFO_BOX);
    if(userJson == null) return null; 
    User? userLogged = User.fromJson(userJson);
    _user = userLogged;
    return userLogged;
  }

  Map<String, dynamic>? getJsonUserData() {
    Map<String, dynamic>? userJson = _storage.read(USER_INFO_BOX);
    return userJson;
  }

  logOutUser() {
    _storage.remove(USER_INFO_BOX);
    _storage.remove('token');
    Get.offAll(()=>const LoginScreen());
  }


void uIUpdate(){
    notifyListeners();
}


  String? getToken() {
    return _storage.read('token');
  }
}
