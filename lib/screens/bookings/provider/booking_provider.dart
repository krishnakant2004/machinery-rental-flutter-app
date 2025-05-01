import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_app/core/data/machinary_rental_data_provider.dart';
import 'package:my_app/models/api_response.dart';
import 'package:my_app/models/machinery_model.dart';
import 'package:my_app/utils/snack_bar_helper.dart';
import '../../../models/booking_model.dart';
import '../../../services/api.dart';
import '../../../services/location.dart';
import '../../../widgets/customeAlertDialog.dart';

class BookingProvider with ChangeNotifier {

  HttpService service = HttpService();
  final _storage = GetStorage();

  bool _isLoading = false;
  String? _error;


  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _storage.hasData('token');


  //
  DateTime? _startDate;
  DateTime? _endDate;
  bool withOperator = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  TextEditingController _locationCoordinatesController = TextEditingController();
  List<double> _locationPoints = [0, 0];
  double? _totalAmount;

  //getter
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get locationController => _locationController;
  TextEditingController get notesController => _notesController;
  TextEditingController get locationCoordinatesController =>
      _locationCoordinatesController;
  List<double> get locationPoints => _locationPoints;
  double? get totalAmount => _totalAmount;

  //constructor
  final MachineryDataProvider _machineryDataProvider;
  BookingProvider(this._machineryDataProvider);

  void calculateTotalAmount(Machinery machinery) {
    if (_startDate != null && _endDate != null) {
      final days = _endDate!.difference(_startDate!).inDays + 1;
      double total = days * machinery.dailyRate;
      if (withOperator && machinery.operatorAvailable) {
        total += days * machinery.operatorCharges;
      }
      _totalAmount = total;
      notifyListeners();
    }
  }


  Future<void> selectDate(BuildContext context, bool isStart, Machinery machinery) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      notifyListeners();
      if (isStart) {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = _startDate;
        }
      } else {
        _endDate = picked;
        _startDate ??= picked;
      }
      calculateTotalAmount(machinery);
      notifyListeners();
    }
  }

  Future<void> submit(Machinery machinery,BuildContext context,{bool showSnack = true}) async {

    calculateTotalAmount(machinery);
    if (!isAuthenticated) {
      _error = 'Please login to create a booking';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("login again to create booking")));
      return;
    }
    if (!_formKey.currentState!.validate() || _startDate == null || _endDate == null) {
      return ;
    }

    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> machineryData = {
        'machinery': machinery.sId.toString(),
        'startDate': _startDate!.toIso8601String(),
        'endDate': _endDate!.toIso8601String(),
        'withOperator': withOperator,
        'location': {
          'address': _locationController.text,
          'coordinates': locationPoints,
        },
        'totalAmount': _totalAmount!,
        'notes': _notesController.text,
      };
      if(kDebugMode){
        print(machineryData);
      }

      Response response = await service.addItem(endpointUrl: 'bookings/',itemData:  machineryData);
      if (response.isOk) {
        // Reset the form state
        clearBookingData();
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          machinery.availability = false;
          if(showSnack){
          SnackBarHelper.showSuccessSnackBar('Booking created successfully',title: 'Successful');
          }
        }else{
          if(showSnack) {
            SnackBarHelper.showInfoSnackBar(
                '${response.body['message']}', title: 'Unsuccessful');
          }
          }

      } else {
        throw Exception(response.body['message'] ?? 'Failed to create booking');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      SnackBarHelper.showErrorSnackBar('$error',title: 'error');
      throw error; // Rethrow to be handled by the UI
    } finally {
      _isLoading = false;
      notifyListeners();
      return ;
    }
  }

  Future<void> getLocation(BuildContext context) async {
    LocationService locationService = LocationService();

    //coordinate in array which contain longitude,latitude
    final coordinates = await locationService.getUserLocation();
    print("$coordinates");
    if (coordinates != null) {
      _locationCoordinatesController.text = "$coordinates";
      _locationPoints = coordinates;
      return;
    }
    customeAlertDialog(
        context: context,
        title: 'Location Denied ❌',
        content: "unable to get Location",
    );
  }

  Future<bool> deleteBooking(String bookingId,BuildContext context,{bool showSnack = true}) async {
    bool isSuccess = false;
    try{
      Response response = await service.deleteItem(endpointUrl: 'bookings', itemId: bookingId);

      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          if(showSnack){
          SnackBarHelper.showSuccessSnackBar('booking cancelled successful',title: 'Successful');
          isSuccess =true;
          // _machineryDataProvider.fetchAllData();
          }
        }else{
          if(showSnack){
          SnackBarHelper.showInfoSnackBar('booking cancelled Unsuccessful',title: 'Failed');
          }
        }

      }else{
        if (kDebugMode) {
          print(response.body['message']);
        }
        SnackBarHelper.showErrorSnackBar('${response.body['message'].toString()}',title: 'Failed');
      }
    }catch (e){
      if (kDebugMode) {
        print(e);
        print(e);
      }
      SnackBarHelper.showErrorSnackBar('$e',title: 'Error');
    }finally{
      return isSuccess;
    }
  }


  void clearBookingData(){
    _startDate = null;
    _endDate = null;
    withOperator = false;
    _totalAmount = null;
    _locationPoints = [0, 0];
    _locationController.clear();
    _notesController.clear();
    _locationCoordinatesController.clear();
    notifyListeners();
  }

  void clearBookingError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    _locationCoordinatesController.dispose();
    super.dispose();
  }
}
