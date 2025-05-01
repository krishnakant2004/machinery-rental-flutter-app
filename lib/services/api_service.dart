import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';
import '../models/machinery_model.dart';
import '../models/booking_model.dart';

class ApiService extends GetConnect {
  final _storage = GetStorage();
  final String baseUrl = 'http://192.168.137.223:3000/api'; // For Android emulator

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = const Duration(seconds: 10);
    
    // Add auth token to all requests
    httpClient.addRequestModifier<dynamic>((request) async {
      final token = _storage.read('token');
      if (kDebugMode) {
        print('Current token: $token');
        print('Request URL: ${request.url}');
      }
      if (token != null) {
        // Make sure to add 'Bearer ' prefix
        request.headers['Authorization'] = 'Bearer $token';
        request.headers['Content-Type'] = 'application/json';
        request.headers['Accept'] = 'application/json';

        if (kDebugMode) {
          print('Request headers: ${request.headers}');
        }
      }
      return request;
    });

    // Handle response errors
    httpClient.addResponseModifier((request, response) {
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        print('Response headers: ${response.headers}');
      }

      if (response.statusCode == 401) {
        _storage.remove('token');
        throw 'Session expired. Please login again.';
      }
      return response;
    });
    
    super.onInit();
  }

  // Authentication
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await post(
        '/auth/login',
        {
          'email': email,
          'password': password,
        },
      );
      
      if (!response.status.isOk) {
        throw response.body?['message'] ?? 'Failed to login';
      }
      
      final token = response.body['token'];
      await _storage.write('token', token);
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await post(
        '/auth/register',
        userData,
      );
      
      if (!response.status.isOk) {
        throw response.body?['message'] ?? 'Failed to register';
      }
      
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  // Machinery
  Future<List<Machinery>> getMachinery({String? type, Map<String, dynamic>? location, double? radius, bool? available,}) async {
    try {
      final response = await get(
        '/machinery',
        query: {
          if (type != null) 'type': type,
          if (location != null) 'location': '${location['longitude']},${location['latitude']}',
          if (radius != null) 'radius': radius.toString(),
          if (available != null) 'available': available.toString(),
        },
      );
      
      if (!response.status.isOk) {
        throw response.body?['message'] ?? 'Failed to fetch machinery';
      }
      
      return (response.body as List)
          .map((json) => Machinery.fromJson(json))
          .toList();
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<Machinery> getMachineryById(String id) async {
    try {
      final response = await get('/machinery/$id');
      
      if (!response.status.isOk) {
        throw response.body?['message'] ?? 'Failed to fetch machinery';
      }
      
      return Machinery.fromJson(response.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> createMachinery(Map<String, dynamic> machineryData) async {
    try {
      if (kDebugMode) {
        print('Creating machinery with data: $machineryData');
        print('Current token: ${_storage.read('token')}');
      }

      final formData = FormData({
        'name': machineryData['name'],
        'type': machineryData['type'],
        'description': machineryData['description'],
        'hourlyRate': machineryData['hourlyRate'].toString(),
        'dailyRate': machineryData['dailyRate'].toString(),
        'operatorAvailable': machineryData['operatorAvailable'].toString(),
        'operatorCharges': machineryData['operatorCharges'].toString(),
        'specifications': jsonEncode(machineryData['specifications']),
        'location': jsonEncode(machineryData['location']),
      });

      // ✅ Fix: Properly add images
      if (machineryData['images'] != null && machineryData['images'].isNotEmpty) {
        for (var imagePath in machineryData['images']) {
          File file = File(imagePath);
          formData.files.add(MapEntry(
            'images',
            MultipartFile(file.readAsBytesSync(), filename: file.path.split('/').last),
          ));
        }
      }

      final response = await post(
        '/machinery',
        formData,
        headers: {
          'Authorization': 'Bearer ${_storage.read('token')}',
          'Accept': 'application/json',
        },
      );

      if (kDebugMode) {
        print('Create machinery response: ${response.body}');
        print('Status code: ${response.statusCode}');
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw response.body?['message'] ?? 'Failed to create machinery';
      }

      return response.body;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating machinery: $e');
      }
      throw e.toString();
    }
  }


  // Bookings
  Future<List<dynamic>> getBookings() async {
    try {
      if (kDebugMode) {
        print('Fetching bookings...');
        print('Token: ${_storage.read('token')}');
      }

      final response = await get(
        '/bookings',
        headers: {
          'Authorization': 'Bearer ${_storage.read('token')}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (kDebugMode) {
        print('Bookings response: ${response.body}');
        print('Status code: ${response.statusCode}');
        print('Response headers: ${response.headers}');
      }

      if (!response.status.isOk) {
        throw response.body?['message'] ?? 'Failed to fetch bookings';
      }

      return response.body;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching bookings: $e');
      }
      throw e.toString();
    }
  }

  Future<Booking> createBooking(Map<String, dynamic> bookingData) async {
    try {
      if(kDebugMode){
        print(bookingData);
        print(_storage.read('token'));
      }
      Map<String,dynamic> data={"name":"krishnakant"};
      final response = await post(
        '/bookings',
        data,
        headers: {
          'Authorization': 'Bearer ${_storage.read('token')}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (!response.status.isOk) {
        print(response.status.code);
        print(response.body);
        throw response.body?['message'] ?? 'Failed to create booking';
      }
      print(response.status.code);
      print(response.body);
      return Booking.fromJson(response.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Booking> updateBookingStatus(String bookingId, String status) async {
    try {
      final response = await put(
        '/bookings/$bookingId/status',
        {'status': status},
      );
      
      if (!response.status.isOk) {
        throw response.body?['message'] ?? 'Failed to update booking status';
      }
      
      return Booking.fromJson(response.body);
    } catch (e) {
      throw e.toString();
    }
  }

  // User Profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await get('/auth/profile');
      
      if (!response.status.isOk) {
        throw response.body?['message'] ?? 'Failed to fetch user profile';
      }
      
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> profileData) async {
    try {
      if (kDebugMode) {
        print('Updating profile with data: $profileData');
        print('Token: ${_storage.read('token')}');
      }

      final response = await put(
        '/users/profile',
        profileData,
        headers: {
          'Authorization': 'Bearer ${_storage.read('token')}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (kDebugMode) {
        print('Update profile response: ${response.body}');
        print('Status code: ${response.statusCode}');
      }

      if (!response.status.isOk) {
        throw response.body?['message'] ?? 'Failed to update profile';
      }

      return response.body;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile: $e');
      }
      throw e.toString();
    }
  }

  Future<User> addRole(String role, Map<String, dynamic>? roleDetails) async {
    try {
      final response = await post(
        '/auth/roles/add',
        {
          'role': role,
          if (roleDetails != null) 'roleDetails': roleDetails,
        },
      );
      
      if (!response.status.isOk) {
        throw response.body?['message'] ?? 'Failed to add role';
      }
      
      return User.fromJson(response.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<User> updateLabourAvailability(bool availability, List<Map<String, dynamic>>? seasonalAvailability) async {
    try {
      final response = await put(
        '/auth/labour/availability',
        {
          'availability': availability,
          if (seasonalAvailability != null)
            'seasonalAvailability': seasonalAvailability,
        },
      );
      
      if (!response.status.isOk) {
        throw response.body?['message'] ?? 'Failed to update labour availability';
      }
      
      return User.fromJson(response.body);
    } catch (e) {
      throw e.toString();
    }
  }

  // Token Management
  bool get isAuthenticated => _storage.hasData('token');
  
  void clearToken() {
    _storage.remove('token');
  }
}
