import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/core/data/machinary_rental_data_provider.dart';
import 'package:my_app/services/api.dart';
import '../../../models/api_response.dart';
import '../../../models/machinery_model.dart';
import '../../../models/user_model.dart';
import '../../../services/location.dart';
import '../../../utils/constants.dart';
import '../../../utils/snack_bar_helper.dart';


class MachineryProvider with ChangeNotifier {

  //constructor
  MachineryDataProvider _machineryDataProvider;
  MachineryProvider(this._machineryDataProvider);

  final HttpService service = HttpService();
  final LocationService locationService = LocationService();
  final _storage = GetStorage();
  bool _isLoading = false;
  Machinery? _selectedMachinery;
  String? _error;

  bool get isLoading => _isLoading;
  Machinery? get selectedMachinery => _selectedMachinery;
  String? get error => _error;
  bool get isAuthenticated => _storage.hasData('token');
  
  //machinery use for update and create
  Machinery? machineryForUpdate;
  //images
  File? firstImage, secondImage, thirdImage;
  XFile? firstImageXFile, secondImageXFile,thirdImageXFile;
  //provider machinery
  List<Machinery> _providerMachinery = [];
  List<Machinery> _filterdProviderMachinery = [];

  List<Machinery> get providerMachinery => _providerMachinery;
  List<Machinery> get filterdProviderMachinery => _filterdProviderMachinery;

  //create machinery
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _dailyRateController = TextEditingController();
  final _operatorChargesController = TextEditingController();
  final _categoryController = TextEditingController();
  final _locationController = TextEditingController();
  final _addressController = TextEditingController();
  final Map<String, TextEditingController> _specControllers = {};

  List<double>? _locationPoints = [];
  String _selectedType = 'Tractor';
  bool _operatorAvailable = false;
  bool _availability = true;
  bool machineryLoading = false;
  String machineryError = "";


  final List<String> _machineryTypes = [
    'Tractor',
    'Harvester',
    'Cultivator',
    'Thresher',
    'Sprayer',
    'Water Pump',
  ];

  final List<String> _defaultSpecs = [
    'Brand',
    'Model',
    'Power',
    'Year',
    'Condition',
  ];

  List<double>? get locationPoints => _locationPoints;
  GlobalKey get formKey => _formKey;
  TextEditingController get nameController => _nameController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get hourlyRateController => _hourlyRateController;
  TextEditingController get dailyRateController => _dailyRateController;
  TextEditingController get operatorChargesController => _operatorChargesController;
  TextEditingController get categoryController => _categoryController;
  TextEditingController get locationController => _locationController;
  TextEditingController get addressController => _addressController;
  String get selectedType => _selectedType;
  bool get operatorAvailable => _operatorAvailable;
  bool get availability =>  _availability;

  Map<String, TextEditingController> get specControllers => _specControllers;
  List<String> get machineryTypes => _machineryTypes;
  List<String> get defaultSpecs => _defaultSpecs;




  void changeOperatorAvailable(bool value){
    _operatorAvailable = value;
    notifyListeners();
  }
  
  void changeMachineryAvailable(bool value){
    _availability = value;
    notifyListeners();
  }

  void changeSelectedType(String value){
    _selectedType = value;
    notifyListeners();
  }

  
  void selectMachinery(Machinery machinery) {
    _selectedMachinery = machinery;
    notifyListeners();
  }

  Future<List<Machinery>> getProviderMachinery({bool showSnack = false}) async {
    try {
      machineryLoading =true;
      notifyListeners();
      User? _user = getLoginUsr();

      String userId =_user?.sId ?? '';
      if(kDebugMode){
        print(userId);
      }
      Response response = await service.getItemsById(endpointUrl: 'machinery/provider',itemId: userId);
      if (response.isOk) {
        if(kDebugMode){
          print("fetch successfully");
        }
        machineryLoading = false;
        ApiResponse<List<Machinery>> apiResponse = ApiResponse.fromJson(
          response.body,
              (json) =>
              (json as List).map((item) => Machinery.fromJson(item)).toList(),
        );

        _providerMachinery = apiResponse.data ?? [];
        _filterdProviderMachinery = List.from(_providerMachinery);
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
      return _filterdProviderMachinery;
    }

  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void disposeTextFiels(){
    nameController.dispose();
    descriptionController.dispose();
    hourlyRateController.dispose();
    dailyRateController.dispose();
    operatorChargesController.dispose();
    categoryController.dispose();
    locationController.dispose();
    for (var controller in specControllers.values) {
      controller.dispose();
    }
  }

  void pickerImage({required int imageNumber}) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image;
    if(GetPlatform.isDesktop){
      image = await imagePicker.pickImage(source: ImageSource.gallery);
    }else if(GetPlatform.isMobile){
      image = await imagePicker.pickImage(source: ImageSource.camera);
    }

    if(image != null){
      switch (imageNumber){
        case 1:
          firstImage = File(image.path);
          firstImageXFile = image;
          break;
        case 2:
          secondImage = File(image.path);
          secondImageXFile = image;
          break;
        case 3:
          thirdImage = File(image.path);
          thirdImageXFile = image;
          break;
      }
    }
    notifyListeners();
  }

  Future<FormData> createFormDataForMultipleImage({required Map<String,dynamic> formData,required List<Map<String,XFile?>>? imageXFiles,}) async {
    // Loop over the provided image files and add them to the form data
    if(kDebugMode){
      print("creating form data");
    }
    if(imageXFiles != null){
      for(int i = 0 ; i < imageXFiles.length ; i++){
        XFile? imageXFile = imageXFiles[i]['image${i + 1}'];
        if(imageXFile != null){
          // Check if it's running on the web

          if(kIsWeb){
            String fileName = imageXFile.name;
            Uint8List byteImg = await imageXFile.readAsBytes();
            formData['image${i+1}'] = MultipartFile(byteImg, filename: fileName);
          }else{
            String filePath = imageXFile.path;
            String fileName = filePath.split('/').last;
            formData['image${i+1}'] = MultipartFile(filePath, filename: fileName);
          }
        }
      }
    }

    //create and return the FormData object
    final FormData form = FormData(formData);
    return form;
  }

  setDataForUpdateMachinery(Machinery? machinery){
    if(machinery != null){
      machineryForUpdate = machinery;

      _nameController.text = machinery.name ?? '';
      _descriptionController.text = machinery.description ?? '';
      _hourlyRateController.text = machinery.hourlyRate.toString() ?? 'Unkonw';
      _dailyRateController.text = machinery.dailyRate.toString() ?? "Unknow";
       _operatorChargesController.text = machinery.operatorCharges.toString() ?? "Unknow";
       _categoryController.text = machinery.type;
       _locationController.text = machinery.locationType ?? "Unknown";
       _addressController.text = machinery.address ?? 'Unknown';
       _operatorAvailable= machinery.operatorAvailable;
       _operatorChargesController.text = machinery.operatorCharges.toString();

      for (var spec in _defaultSpecs) {
        _specControllers[spec] = TextEditingController();
      }
       for(var item in _specControllers.keys){
         _specControllers[item]?.text = machinery.specifications[item] ?? '';
       }
       _locationPoints = machinery.coordinates ?? [];

    }else{
      clearFields();
    }
  }
 
  void createMachinery({bool showSnack = false}) async {
    if (!isAuthenticated) {
      _error = 'Please login to add machinery';
      notifyListeners();
      return;
    }

    try {
      Map<String,dynamic> specification = {};
      for (var spec in _defaultSpecs) {
        specification[spec] = _specControllers[spec]?.text ?? '';
      }
      if(kDebugMode){
        print(specification);
      }
      _locationPoints = await locationService.getUserLocation();

      // location data
      Map<String,dynamic> locationData = {
        'coordinates': _locationPoints ?? [],
        'address':_locationController.text,
      };

      final formDataMap = {
        'name': _nameController.text,
        'type': _selectedType,
        'description': _descriptionController.text,
        'hourlyRate': _hourlyRateController.text,
        'dailyRate': _dailyRateController.text,
        'availability':_availability,
        'operatorAvailable': _operatorAvailable,
        'operatorCharges': operatorChargesController.text,
        'specifications': jsonEncode(specification),
        'location': jsonEncode(locationData),
        'address':_addressController.text,
      };
      if(kDebugMode){
        print(formDataMap);
      }
      final FormData form = await createFormDataForMultipleImage(formData: formDataMap,
          imageXFiles:[
            {'image1':firstImageXFile},
            {'image2':secondImageXFile},
            {'image3':thirdImageXFile},
          ]
      );

      _isLoading = true;
      notifyListeners();

      Response response = await service.addItem(endpointUrl: 'machinery/',itemData: form);
      if(response.isOk){
        ApiResponse<void> apiResponse = ApiResponse.fromJson(response.body,null);
        if(apiResponse.success == true){
          clearFields();
          _machineryDataProvider.fetchMachinery();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        }
        else{
          SnackBarHelper.showErrorSnackBar(apiResponse.message);
        }
      }else{
        SnackBarHelper.showErrorSnackBar("something went wrong!");
      }

      _error = null;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (showSnack) {
        SnackBarHelper.showErrorSnackBar(e.toString());
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void updateMachinery() async {
    try{
      Map<String,dynamic> specification = {};
      for (var spec in _defaultSpecs) {
        specification[spec] = _specControllers[spec]?.text ?? '';
      }

      // location data
      Map<String,dynamic> locationData = {
        'coordinates': _locationPoints ?? [],
        'address':_locationController.text,
      };

      final formDataMap = {
        'name': _nameController.text,
        'type': _selectedType,
        'description': _descriptionController.text,
        'hourlyRate': _hourlyRateController.text,
        'dailyRate': _dailyRateController.text,
        'availability':_availability,
        'operatorAvailable': _operatorAvailable,
        'operatorCharges': operatorChargesController.text,
        'specifications': jsonEncode(specification),
        'location': jsonEncode(locationData),
        'address':_addressController.text,
      };
      if (kDebugMode) {
        print(formDataMap);
      }
      final FormData form = await createFormDataForMultipleImage(formData: formDataMap,
          imageXFiles:[
            {'image1':firstImageXFile},
            {'image2':secondImageXFile},
            {'image3':thirdImageXFile},
          ]
      );
      
      final response = await service.updateItem(endpointUrl: 'machinery', itemId: '${machineryForUpdate?.sId}', itemData: form);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          _machineryDataProvider.fetchMachinery();
          SnackBarHelper.showSuccessSnackBar(apiResponse.message);

        } else {
          SnackBarHelper.showInfoSnackBar(
              'Failed to update machinery: ${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showInfoSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    }catch (e){
      SnackBarHelper.showErrorSnackBar('An error occurred $e');
      rethrow;
    }
  }

  deleteMachinery(Machinery machinery) async {
    try{
      Response response = await service.deleteItem(endpointUrl: 'machinery', itemId: machinery.sId);
      if(response.isOk){
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if(apiResponse.success == true){
          getProviderMachinery();
          _machineryDataProvider.fetchMachinery();
          _machineryDataProvider.updateUI();
          updateUI();
          SnackBarHelper.showSuccessSnackBar('machinery deleted successfully');
        }else{
          SnackBarHelper.showInfoSnackBar(apiResponse.message);
        }
      }else{
        SnackBarHelper.showErrorSnackBar('Error ${response.body?['message'] ?? response.statusText}');
      }
    }catch(e){
      print(e);
      rethrow;
    }
  }

  void submitMachinery(){
    if(machineryForUpdate != null){
      updateMachinery();
    }else{
      createMachinery();
    }
  }

  void clearFields(){
    //clear images
    firstImage = null;
    secondImage = null;
    thirdImage = null;

    firstImageXFile = null;
    secondImageXFile = null;
    thirdImageXFile = null;

    _nameController.clear();
    _descriptionController.clear();
    _hourlyRateController.clear();
    _dailyRateController.clear();
    _addressController.clear();

    for(var controller in _specControllers.values){
      controller.clear();
    }
    _operatorAvailable =false;
    operatorChargesController.clear();


  }

  void updateUI(){
    notifyListeners();
  }

  User? getLoginUsr() {
    Map<String, dynamic>? userJson = _storage.read(USER_INFO_BOX);
    if(userJson == null) return null;
    User? userLogged = User.fromJson(userJson);
    return userLogged;
  }

}
