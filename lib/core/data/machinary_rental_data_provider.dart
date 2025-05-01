import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:my_app/models/api_response.dart';
import 'package:my_app/models/booking_model.dart';
import 'package:my_app/models/machinery_model.dart';
import 'package:my_app/services/api.dart';

import '../../utils/snack_bar_helper.dart';

class MachineryDataProvider extends ChangeNotifier {
  HttpService service = HttpService();
  List<Machinery> _allMachinery = [];
  List<Machinery> _filteredMachinery = [];
  List<Machinery> get filteredMachinery => _filteredMachinery;

  List<Booking> _allBooking = [];
  List<Booking> _filteredBooking = [];
  List<Booking> get filteredBooking => _filteredBooking;

  bool _fetchingData = false;
  bool get fetchingData => _fetchingData;

  String? _error;
  String? get error => _error;

  Future<void> fetchAllData() async {
    try{
      _fetchingData = true;
      _error = null;
      notifyListeners();
      await Future.wait([
        fetchMachinery(showSnack: false),
        fetchBookings(showSnack: false),
      ]).timeout(const Duration(seconds:  10),
          onTimeout: (){
            _fetchingData = false;
            _error = 'fetching data timed out';
            throw TimeoutException('fetching data timed out');
          }
      );
    }catch (e){
      if (kDebugMode) {
        print("exception: $e}");
      }
      _error = e.toString();
      SnackBarHelper.showErrorSnackBar("Something went wrong");
    } finally {
      _fetchingData = false;
      if (kDebugMode) {
        print(
            'isFetching set to false, products count: ${_allMachinery.length}');
      }
      notifyListeners();
    }
  }


  bool machineryLoading = false;
  String? machineryError ;
  // machinery
  Future<List<Machinery>> fetchMachinery({bool showSnack = false}) async {
    try {
      machineryLoading =true;
      notifyListeners();
      Response response = await service.getItems(endpointUrl: 'machinery');
      if (response.isOk) {
        machineryLoading = false;
        ApiResponse<List<Machinery>> apiResponse = ApiResponse.fromJson(
          response.body,
          (json) =>
              (json as List).map((item) => Machinery.fromJson(item)).toList(),
        );

        _allMachinery = apiResponse.data ?? [];
        _filteredMachinery = List.from(_allMachinery);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      machineryError = e.toString();
      if (kDebugMode) {
        print(e);
      }
      if (showSnack) {
        SnackBarHelper.showErrorSnackBar(e.toString());
      }
      rethrow;
    }finally{
      notifyListeners();
      return _filteredMachinery;
    }

  }

  void filterAllMachinery(String keyword) {
    if (keyword.isEmpty || keyword == 'All') {
      _filteredMachinery = List.from(_allMachinery);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredMachinery = _allMachinery.where((machinery) {
        final manchineryContainsKeyword = (machinery.name ?? '').toLowerCase().contains(lowerKeyword);
        final typeContainingKeyword = (machinery.type ?? '').toLowerCase().contains(lowerKeyword);
        final descriptionContainingKeyword = (machinery.description ?? '').toLowerCase().contains(lowerKeyword);
        return manchineryContainsKeyword || typeContainingKeyword || descriptionContainingKeyword;
      }).toList();
    }
    notifyListeners();
  }

  void filterAllMachineryByType(String keyword){
    if (keyword.isEmpty || keyword == 'All') {
      _filteredMachinery = List.from(_allMachinery);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredMachinery = _allMachinery.where((machinery) {
        final typeContainingKeyword = (machinery.type ?? '').toLowerCase().contains(lowerKeyword);
        return  typeContainingKeyword;
      }).toList();
    }
    notifyListeners();
  }

  void filterAvailableOnly(){
    _filteredMachinery = _allMachinery.where((machinery){
      return machinery.availability == true;
    }).toList();
    notifyListeners();
  }
  //booking
  Future<List<Booking>> fetchBookings({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'bookings');
      if (response.isOk) {
        ApiResponse<List<Booking>> apiResponse = ApiResponse.fromJson(
          response.body,
              (json) =>
              (json as List).map((item) => Booking.fromJson(item)).toList(),
        );

        _allBooking = apiResponse.data ?? [];
        _filteredBooking = List.from(_allBooking);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (showSnack) {
        SnackBarHelper.showErrorSnackBar(e.toString());
      }
      rethrow;
    }
    return _filteredBooking;
  }

  void filterAllBookings(String keyword) {
    if (keyword.isEmpty) {
      _filteredBooking = List.from(_allBooking);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredBooking = _allBooking.where((booking) {
        final manchineryContainsKeyword = (booking.machinery.name ?? '').toLowerCase().contains(lowerKeyword);
        final typeContainingKeyword = (booking.machinery.type ?? '').toLowerCase().contains(lowerKeyword);
        return manchineryContainsKeyword || typeContainingKeyword ;
      }).toList();
    }
    notifyListeners();
  }
  void updateUI(){
    notifyListeners();
  }
  void clearError() {
    _error = null;
    machineryError = null;
    notifyListeners();
  }

}
