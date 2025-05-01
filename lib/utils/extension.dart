import 'package:flutter/cupertino.dart';
import 'package:my_app/providers/auth_provider.dart';
import 'package:my_app/screens/bookings/provider/booking_provider.dart';
import 'package:provider/provider.dart';
import '../core/data/machinary_rental_data_provider.dart';
import '../screens/machinery/provider/machinery_provider.dart';

extension Providers on BuildContext {
  MachineryDataProvider get machineryDataProvider => Provider.of<MachineryDataProvider>(this,listen: false);
  AuthProvider get authProvider => Provider.of<AuthProvider>(this, listen: false);
  MachineryProvider get machineryProvider => Provider.of<MachineryProvider>(this,listen: false);
  BookingProvider get bookingProvider => Provider.of<BookingProvider>(this,listen:false);
}

extension SafeList<T> on List<T>? {
  T? safeElementAt(int index) {
    // Check if the list is null or if the index is out of range
    if (this == null || index < 0 || index >= this!.length) {
      return null;
    }
    return this![index];
  }
}