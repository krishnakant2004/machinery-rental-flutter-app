import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:get_storage/get_storage.dart';

import '../utils/constants.dart';

class HttpService extends GetConnect {
  final _storage = GetStorage();

  @override
  void onInit() {
    httpClient.timeout = const Duration(
      seconds: 10,
    );
    httpClient.baseUrl = BASE_URL;
    if(kDebugMode){
      print("${httpClient.baseUrl}");
    }

    super.onInit();
  }

  Future<Response> getItems({required String endpointUrl}) async {
    try {
      return await get('$BASE_URL/$endpointUrl',
        headers: {
          'Authorization': 'Bearer ${_storage.read('token')}',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('request timed out');
        },
      );
    } on TimeoutException {
      throw TimeoutException('request timed out');
    } on Exception catch (e) {
      return Response(
          body: json.encode({'error': e.toString()}), statusCode: 500);
    }
  }
  Future<Response> getItemsById({required String endpointUrl,required String itemId}) async {
    try {
      return await get('$BASE_URL/$endpointUrl/$itemId',
        headers: {
          'Authorization': 'Bearer ${_storage.read('token')}',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('request timed out');
        },
      );
    } on TimeoutException {
      throw TimeoutException('request timed out');
    } on Exception catch (e) {
      return Response(
          body: json.encode({'error': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> addItem({required String endpointUrl, required dynamic itemData, String content_type = 'application/json'}) async {
    try {
      final response = await post(
        '$BASE_URL/$endpointUrl',
        itemData,
        headers: {
          'Authorization': 'Bearer ${_storage.read('token')}',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('request timed out');
        },
      );
      if (kDebugMode) {
        print(response.body);
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> updateItem({required String endpointUrl, required String itemId, required dynamic itemData}) async {
    try {
      final connect = GetConnect(timeout: const Duration(seconds: 10));
      return await connect.put(
        '$BASE_URL/$endpointUrl/$itemId',
        itemData,
        headers: {
          'Authorization': 'Bearer ${_storage.read('token')}',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('request timed out');
        },
      );
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> deleteItem({required String endpointUrl, required String itemId}) async {
    try {
      String url = '$baseUrl/$endpointUrl/$itemId';
      if (kDebugMode) {
        print(url);
      }
      final response = await delete(
        '$BASE_URL/$endpointUrl/$itemId',
        headers: {
          'Authorization': 'Bearer ${_storage.read('token')}',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('request timed out');
        },
      );
      return response;
    } catch (e) {
      if(kDebugMode){
        print(e);
      }
      return Response(
          body: json.encode({'success':false,'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> filterProduct({required String endpointUrl, required dynamic key}) async {
    try {
      if (kDebugMode) {
        print('$baseUrl/$endpointUrl');
      }
      final payload = {'name': key};
      return await post(
        '$BASE_URL/$endpointUrl',
        payload,
        headers: {
          'Authorization': 'Bearer ${_storage.read('token')}',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('request timed out');
        },
      );
    } catch (e) {
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> login({required String endpointUrl, required dynamic itemData, String content_type = 'application/json'}) async {
    try {
      final response = await post(
        '$BASE_URL/$endpointUrl',
        itemData,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('request timed out');
        },
      );
      if (kDebugMode) {
        print(response.body);
      }
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return Response(
          body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

}
