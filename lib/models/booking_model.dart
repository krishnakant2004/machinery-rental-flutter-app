import 'package:my_app/models/machinery_model.dart';
import 'package:my_app/models/user_model.dart';

class Booking {
  final String sId;
  Machinery machinery;
  User user;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final bool withOperator;
  final String address;
  final List<double> coordinates;
  final String? notes;
  final double totalAmount;
  final String? paymentStatus;

  Booking({
    required this.sId,
    required this.machinery,
    required this.user,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.withOperator,
    required this.address,
    required this.coordinates,
    this.notes,
    required this.totalAmount,
    this.paymentStatus,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      sId: json['_id'].toString(),
      machinery: Machinery.fromJson(json['machinery'] ?? {}),
      user: User.fromJson(json['renter'] ?? ''),
      startDate: json['startDate'] != null 
          ? DateTime.parse(json['startDate']) 
          : DateTime.now(),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate']) 
          : DateTime.now(),
      status: json['status'] ?? 'pending',
      withOperator: json['withOperator'] ?? false,
      address: json['location']['address'] ?? 'Unknown',
      coordinates: List<double>.from(json['location']['coordinates'] ?? [0.0, 0.0]),
      notes: json['notes'] ?? '',
        paymentStatus :json['paymentStatus'] ?? 'pending',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'machinery': machinery.sId,
      'user': user.sId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
      'withOperator': withOperator,
      'location': {
        'address':address,
        'coordinates':coordinates,
      },
      'paymentStatus':paymentStatus,
      'notes': notes,
      'totalAmount': totalAmount,
    };
  }
}
