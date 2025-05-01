import 'package:my_app/models/user_model.dart';

class Machinery {
   String sId;
   String name;
   String type;
   String description;
   double hourlyRate;
   double dailyRate;
   List<Images> images;
   Map<String, String> specifications;
   User owner;
   String locationType;
   List<double> coordinates;
   String? address;
   bool operatorAvailable;
   double operatorCharges;
  bool availability;

  Machinery({
    required this.sId,
    required this.name,
    required this.type,
    required this.description,
    required this.hourlyRate,
    required this.dailyRate,
    required this.images,
    required this.specifications,
    required this.owner,
    required this.locationType,
    required this.coordinates,
    this.address,
    required this.operatorAvailable,
    required this.operatorCharges,
    required this.availability,
  });

  factory Machinery.fromJson(Map<String, dynamic> json) {
    return Machinery(
      sId: json['_id'].toString(), // Convert ObjectId to String
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      hourlyRate: (json['hourlyRate'] ?? 0).toDouble(),
      dailyRate: (json['dailyRate'] ?? 0).toDouble(),
      images: (json['images'] != null)
          ? (json['images'] as List).map((v) => Images.fromJson(v)).toList()
          : [],
      specifications: Map<String, String>.from(json['specifications'] ?? {}),
      owner: User.fromJson(json['owner'] ?? {}),
      locationType: json['location']?['type'] ?? 'Unknown',
      coordinates: List<double>.from(json['location']?['coordinates'] ?? [0.0, 0.0]),
      address: json['address'] ?? 'Unknown',
      operatorAvailable: json['operatorAvailable'] ?? false,
      operatorCharges: (json['operatorCharges'] ?? 0).toDouble(),
      availability: json['availability'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'name': name,
      'type': type,
      'description': description,
      'hourlyRate': hourlyRate,
      'dailyRate': dailyRate,
      'images': images,
      'specifications': specifications,
      'owner': owner.toJson(),
      'location': {
        'type': locationType,
        'coordinates': coordinates,
      },
      'address':address,
      'operatorAvailable': operatorAvailable,
      'operatorCharges': operatorCharges,
      'availability': availability,
    };
  }
}

class Images {
  int? image;
  String? url;
  String? sId;

  Images({this.image, this.url, this.sId});

  Images.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    url = json['url'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['image'] = image;
    data['url'] = url;
    data['_id'] = sId;
    return data;
  }
}