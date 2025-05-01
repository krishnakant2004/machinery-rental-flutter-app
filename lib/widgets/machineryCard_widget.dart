import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/utils/extension.dart';
import 'package:my_app/widgets/customeNetworkImage.dart';

import '../models/machinery_model.dart';
import '../screens/machinery/add_machinery_screen.dart';

Widget buildProviderMachineryCard(BuildContext context, Machinery machinery) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          offset: Offset(0, 2),
          blurRadius: 6,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image and badges in a smaller size
        Stack(
          children: [
            // Machinery image (reduced height)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: machinery.images.isNotEmpty
                  ? CustomNetworkImage(
                  height: 200,
                  width: double.infinity,
                  imageUrl: machinery.images
                  .safeElementAt(0)
                  ?.url ??
                  '')
                  : Container(
                height: 120, // Reduced from 180
                width: double.infinity,
                color: Colors.grey[200],
                child: Icon(Icons.construction, size: 48, color: Colors.grey),
              ),
            ),
            //delete machinery
            Positioned(
              top: 8,
              right: 8,
              child: InkWell(
                splashColor: Colors.white,
                onTap: (){
                  context.machineryProvider.deleteMachinery(machinery);
                  context.machineryProvider.updateUI();
                },
                  child: CircleAvatar(child: Icon(Icons.delete,color: Colors.red,), backgroundColor: Colors.grey.withOpacity(0.6),)),),
            // Status badge (smaller)
            Positioned(
              top: 8,
              right: 60,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: machinery.availability ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  machinery.availability ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            // Type badge (smaller)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  machinery.type,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Content section (more compact)
        Padding(
          padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name (slightly smaller)
              Text(
                machinery.name,
                style: TextStyle(
                  fontSize: 16, // Reduced from 18
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4), // Reduced spacing

              // Description (only 1 line now)
              Text(
                machinery.description,
                style: TextStyle(
                  fontSize: 12, // Reduced from 14
                  color: Colors.black54,
                ),
                maxLines: 1, // Reduced from 2
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8), // Reduced spacing

              // Rates section (more compact)
              Row(
                children: [
                  // Hourly rate
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.black54),
                        SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hourly',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '\$${machinery.hourlyRate.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Daily rate
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.black54),
                        SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              '\$${machinery.dailyRate.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Operator info (condensed)
                  if (machinery.operatorAvailable)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 12, color: Colors.blue),
                          SizedBox(width: 2),
                          Text(
                            '\$${machinery.operatorCharges.toStringAsFixed(0)}/hr',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        // Action buttons (smaller)
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) {
                        return AddMachineryScreen(machinery:machinery ,);
                      }) );
                      context.machineryProvider.getProviderMachinery();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue[700], backgroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 8), // Reduced
                      minimumSize: Size(0, 32), // Smaller minimum height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(color: Colors.blue[700]!),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, size: 14),
                        SizedBox(width: 4),
                        Text('Edit', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}