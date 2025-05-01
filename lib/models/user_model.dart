class User {
  String? sId;
  String? name;
  String? userName;
  String? email;
  String? password;
  String? phone;
  List<String>? roles;
  Address? address;
  Documents? documents;
  ShopDetails? shopDetails;
  ProviderDetails? providerDetails;
  FarmerDetails? farmerDetails;
  OperatorDetails? operatorDetails;
  LabourDetails? labourDetails;
  bool isVerified;
  String verificationStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    required this.sId,
    required this.name,
    required this.userName,
    required this.email,
    required this.password,
    required this.phone,
    required this.roles,
    this.address,
    this.documents,
    this.shopDetails,
    this.providerDetails,
    this.farmerDetails,
    this.operatorDetails,
    this.labourDetails,
    required this.isVerified,
    required this.verificationStatus,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      sId : json['_id'],
      name: json['name'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      documents: json['documents'] != null ? Documents.fromJson(json['documents']) : null,
      shopDetails: json['shopDetails'] != null ? ShopDetails.fromJson(json['shopDetails']) : null,
      providerDetails: json['providerDetails'] != null ? ProviderDetails.fromJson(json['providerDetails']) : null,
      farmerDetails: json['farmerDetails'] != null ? FarmerDetails.fromJson(json['farmerDetails']) : null,
      operatorDetails: json['operatorDetails'] != null ? OperatorDetails.fromJson(json['operatorDetails']) : null,
      labourDetails: json['labourDetails'] != null ? LabourDetails.fromJson(json['labourDetails']) : null,
      isVerified: json['isVerified'] ?? false,
      verificationStatus: json['verificationStatus'] ?? 'pending',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Method to convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id':sId,
      'name': name,
      'userName': userName,
      'email': email,
      'password': password,
      'phone': phone,
      'roles': roles,
      'address': address?.toJson(),
      'documents': documents?.toJson(),
      'shopDetails': shopDetails?.toJson(),
      'providerDetails': providerDetails?.toJson(),
      'farmerDetails': farmerDetails?.toJson(),
      'operatorDetails': operatorDetails?.toJson(),
      'labourDetails': labourDetails?.toJson(),
      'isVerified': isVerified,
      'verificationStatus': verificationStatus,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  bool hasRole(String role) => roles?.contains(role) ?? false;
}

// Address Class
class Address {
  String? street;
  String? city;
  String? state;
  String? pincode;
  List<double>? coordinates;

  Address({this.street, this.city, this.state, this.pincode, this.coordinates});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      coordinates: json['coordinates'] != null ? (json['coordinates'] as List<double>).map((e) => e.toDouble() ?? 0).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'pincode': pincode,
      'coordinates': coordinates,
    };
  }
}

// Documents Class
class Documents {
  String? idProof;
  String? addressProof;
  String? businessLicense;
  String? gstin;

  Documents({this.idProof, this.addressProof, this.businessLicense, this.gstin});

  factory Documents.fromJson(Map<String, dynamic> json) {
    return Documents(
      idProof: json['idProof'],
      addressProof: json['addressProof'],
      businessLicense: json['businessLicense'],
      gstin: json['gstin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProof': idProof,
      'addressProof': addressProof,
      'businessLicense': businessLicense,
      'gstin': gstin,
    };
  }
}

// ShopDetails Class
class ShopDetails {
  String? shopName;
  String? shopType;
  String? registrationNumber;
  OpeningHours? openingHours;

  ShopDetails({this.shopName, this.shopType, this.registrationNumber, this.openingHours});

  factory ShopDetails.fromJson(Map<String, dynamic> json) {
    return ShopDetails(
      shopName: json['shopName'],
      shopType: json['shopType'],
      registrationNumber: json['registrationNumber'],
      openingHours: json['openingHours'] != null ? OpeningHours.fromJson(json['openingHours']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shopName': shopName,
      'shopType': shopType,
      'registrationNumber': registrationNumber,
      'openingHours': openingHours?.toJson(),
    };
  }
}

// OpeningHours Class
class OpeningHours {
  String? open;
  String? close;

  OpeningHours({this.open, this.close});

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      open: json['open'],
      close: json['close'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open': open,
      'close': close,
    };
  }
}

// ProviderDetails Class
class ProviderDetails {
  String? businessName;
  int? experience;
  List<PreferredLocation>? serviceArea;

  ProviderDetails({this.businessName, this.experience, this.serviceArea});

  factory ProviderDetails.fromJson(Map<String, dynamic> json) {
    return ProviderDetails(
      businessName: json['businessName'],
      experience: json['experience'],
      serviceArea: (json['serviceArea'] as List<dynamic>?)
          ?.map((e) => PreferredLocation.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'experience': experience,
      'serviceArea': serviceArea?.map((e) => e.toJson()).toList(),
    };
  }
}

// FarmerDetails Class
class FarmerDetails {
  double? farmSize;
  List<String>? primaryCrops;
  List<String>? farmingType;

  FarmerDetails({this.farmSize, this.primaryCrops, this.farmingType});

  factory FarmerDetails.fromJson(Map<String, dynamic> json) {
    return FarmerDetails(
      farmSize: (json['farmSize'] ?? 0).toDouble(),
      primaryCrops: List<String>.from(json['primaryCrops'] ?? []),
      farmingType: List<String>.from(json['farmingType'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'farmSize': farmSize,
      'primaryCrops': primaryCrops,
      'farmingType': farmingType,
    };
  }
}

// OperatorDetails Class
class OperatorDetails {
  int? experience;
  List<String>? specializations;
  List<String>? licenses;
  bool availability;

  OperatorDetails({this.experience, this.specializations, this.licenses, required this.availability});

  factory OperatorDetails.fromJson(Map<String, dynamic> json) {
    return OperatorDetails(
      experience: json['experience'],
      specializations: List<String>.from(json['specializations'] ?? []),
      licenses: List<String>.from(json['licenses'] ?? []),
      availability: json['availability'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'experience': experience,
      'specializations': specializations,
      'licenses': licenses,
      'availability': availability,
    };
  }
}

// LabourDetails uses the class created previously

class LabourDetails {
  List<String> skills;
  int experience;
  double dailyWage;
  bool availability;
  List<String> preferredWorkTypes;
  List<String> languages;
  PhysicalCapabilities physicalCapabilities;
  List<WorkHistory> workHistory;
  List<PreferredLocation> preferredLocations;
  List<SeasonalAvailability> seasonalAvailability;

  LabourDetails({
    required this.skills,
    required this.experience,
    required this.dailyWage,
    required this.availability,
    required this.preferredWorkTypes,
    required this.languages,
    required this.physicalCapabilities,
    required this.workHistory,
    required this.preferredLocations,
    required this.seasonalAvailability,
  });

  // Named constructor to create an instance from JSON
  factory LabourDetails.fromJson(Map<String, dynamic> json) {
    return LabourDetails(
      skills: List<String>.from(json['skills'] ?? []),
      experience: json['experience'] ?? 0,
      dailyWage: (json['dailyWage'] ?? 0).toDouble(),
      availability: json['availability'] ?? true,
      preferredWorkTypes: List<String>.from(json['preferredWorkTypes'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      physicalCapabilities: PhysicalCapabilities.fromJson(json['physicalCapabilities'] ?? {}),
      workHistory: (json['workHistory'] as List<dynamic>?)
          ?.map((e) => WorkHistory.fromJson(e))
          .toList() ??
          [],
      preferredLocations: (json['preferredLocations'] as List<dynamic>?)
          ?.map((e) => PreferredLocation.fromJson(e))
          .toList() ??
          [],
      seasonalAvailability: (json['seasonalAvailability'] as List<dynamic>?)
          ?.map((e) => SeasonalAvailability.fromJson(e))
          .toList() ??
          [],
    );
  }

  // Method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'skills': skills,
      'experience': experience,
      'dailyWage': dailyWage,
      'availability': availability,
      'preferredWorkTypes': preferredWorkTypes,
      'languages': languages,
      'physicalCapabilities': physicalCapabilities.toJson(),
      'workHistory': workHistory.map((e) => e.toJson()).toList(),
      'preferredLocations': preferredLocations.map((e) => e.toJson()).toList(),
      'seasonalAvailability': seasonalAvailability.map((e) => e.toJson()).toList(),
    };
  }
}

// Subclass for PhysicalCapabilities
class PhysicalCapabilities {
  bool canLiftHeavyWeights;
  bool canWorkInSunlight;
  bool canOperateBasicTools;

  PhysicalCapabilities({
    required this.canLiftHeavyWeights,
    required this.canWorkInSunlight,
    required this.canOperateBasicTools,
  });

  factory PhysicalCapabilities.fromJson(Map<String, dynamic> json) {
    return PhysicalCapabilities(
      canLiftHeavyWeights: json['canLiftHeavyWeights'] ?? false,
      canWorkInSunlight: json['canWorkInSunlight'] ?? false,
      canOperateBasicTools: json['canOperateBasicTools'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'canLiftHeavyWeights': canLiftHeavyWeights,
      'canWorkInSunlight': canWorkInSunlight,
      'canOperateBasicTools': canOperateBasicTools,
    };
  }
}

// Subclass for WorkHistory
class WorkHistory {
  String farmName;
  String duration;
  String workType;
  String location;

  WorkHistory({
    required this.farmName,
    required this.duration,
    required this.workType,
    required this.location,
  });

  factory WorkHistory.fromJson(Map<String, dynamic> json) {
    return WorkHistory(
      farmName: json['farmName'] ?? '',
      duration: json['duration'] ?? '',
      workType: json['workType'] ?? '',
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'farmName': farmName,
      'duration': duration,
      'workType': workType,
      'location': location,
    };
  }
}

// Subclass for PreferredLocation
class PreferredLocation {
  String city;
  String state;

  PreferredLocation({
    required this.city,
    required this.state,
  });

  factory PreferredLocation.fromJson(Map<String, dynamic> json) {
    return PreferredLocation(
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'state': state,
    };
  }
}

// Subclass for SeasonalAvailability
class SeasonalAvailability {
  String season;
  bool isAvailable;

  SeasonalAvailability({
    required this.season,
    required this.isAvailable,
  });

  factory SeasonalAvailability.fromJson(Map<String, dynamic> json) {
    return SeasonalAvailability(
      season: json['season'] ?? '',
      isAvailable: json['isAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'season': season,
      'isAvailable': isAvailable,
    };
  }
}
