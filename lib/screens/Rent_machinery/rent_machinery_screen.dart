import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_app/core/data/machinary_rental_data_provider.dart';
import 'package:my_app/screens/bookings/provider/booking_provider.dart';
import 'package:my_app/screens/machinery/provider/machinery_provider.dart';
import 'package:my_app/utils/extension.dart';
import 'package:my_app/widgets/customeNetworkImage.dart';
import 'package:provider/provider.dart';
import '../../models/booking_model.dart';
import 'package:intl/intl.dart';

import '../../models/machinery_model.dart';
import '../../widgets/machineryCard_widget.dart';

class RentMachineryScreen extends StatefulWidget {
  const RentMachineryScreen({super.key});

  @override
  State<RentMachineryScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<RentMachineryScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //todo: fetch
      await context.machineryProvider.getProviderMachinery();
      Future.delayed(const Duration(seconds: 2));
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 50,
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 0,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF42A5F5),  // Light blue
                                    Color(0xFF1976D2),  // Medium blue
                                  ],
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: (){},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Center(
                                  child: Text(
                                    "Add Machinery",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 4,),
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(CupertinoIcons.refresh, color: Colors.blue),
                              onPressed: () {
                                setState(() {
                                  context.machineryProvider.getProviderMachinery();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.blue.shade700,
                      unselectedLabelColor: Colors.grey.shade600,
                      indicatorColor: Colors.blue.shade700,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: const [
                        Tab(text: 'Registered\nMachinery'),
                        // Tab(text: 'Requests'),
                        // Tab(text: 'Accepted'),
                        // Tab(text: 'Completed'),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: Consumer<MachineryProvider>(
              builder: (context, machineProvider, child) {
                // if (machineProvider.fetchingData == true) {
                //   return Center(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Container(
                //           width: 50,
                //           height: 50,
                //           decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius: BorderRadius.circular(12),
                //             boxShadow: [
                //               BoxShadow(
                //                 color: Colors.blue.shade100.withOpacity(0.5),
                //                 blurRadius: 10,
                //                 spreadRadius: 2,
                //               ),
                //             ],
                //           ),
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: CircularProgressIndicator(
                //               valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                //               strokeWidth: 3,
                //             ),
                //           ),
                //         ),
                //         const SizedBox(height: 16),
                //         Text(
                //           'Loading your bookings...',
                //           style: TextStyle(
                //             color: Colors.grey.shade700,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ],
                //     ),
                //   );
                // }
                //
                // if (machineryDataProvider.error != null) {
                //   return Center(
                //     child: Container(
                //       width: double.infinity,
                //       margin: const EdgeInsets.all(24),
                //       padding: const EdgeInsets.all(24),
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(20),
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.grey.shade200,
                //             blurRadius: 10,
                //             spreadRadius: 2,
                //           ),
                //         ],
                //       ),
                //       child: Column(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           Icon(
                //             CupertinoIcons.exclamationmark_circle,
                //             size: 60,
                //             color: Colors.red.shade400,
                //           ),
                //           const SizedBox(height: 16),
                //           Text(
                //             'Oops!',
                //             style: TextStyle(
                //               fontSize: 24,
                //               fontWeight: FontWeight.bold,
                //               color: Colors.grey.shade800,
                //             ),
                //           ),
                //           const SizedBox(height: 8),
                //           Text(
                //             '${machineryDataProvider.error}',
                //             textAlign: TextAlign.center,
                //             style: TextStyle(
                //               fontSize: 16,
                //               color: Colors.grey.shade600,
                //             ),
                //           ),
                //           const SizedBox(height: 24),
                //           GestureDetector(
                //             onTap: () async {
                //               machineryDataProvider.clearError();
                //               machineryDataProvider.fetchBookings();
                //             },
                //             child: Container(
                //               width: 200,
                //               height: 50,
                //               decoration: BoxDecoration(
                //                 gradient: LinearGradient(
                //                   colors: [
                //                     Colors.blue.shade400,
                //                     Colors.blue.shade600,
                //                   ],
                //                 ),
                //                 borderRadius: BorderRadius.circular(12),
                //                 boxShadow: [
                //                   BoxShadow(
                //                     color: Colors.blue.shade200.withOpacity(0.5),
                //                     blurRadius: 10,
                //                     spreadRadius: 2,
                //                     offset: const Offset(0, 2),
                //                   ),
                //                 ],
                //               ),
                //               child: const Center(
                //                 child: Text(
                //                   'Retry',
                //                   style: TextStyle(
                //                     color: Colors.white,
                //                     fontWeight: FontWeight.bold,
                //                     fontSize: 16,
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   );
                // }
                //
                // if (machineryDataProvider.filteredBooking.isEmpty) {
                //   return Center(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Container(
                //           width: 120,
                //           height: 120,
                //           decoration: BoxDecoration(
                //             color: Colors.blue.shade50,
                //             shape: BoxShape.circle,
                //           ),
                //           child: Icon(
                //             CupertinoIcons.calendar_badge_minus,
                //             size: 60,
                //             color: Colors.blue.shade300,
                //           ),
                //         ),
                //         const SizedBox(height: 24),
                //         Text(
                //           'No Bookings Yet',
                //           style: TextStyle(
                //             fontSize: 22,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.grey.shade800,
                //           ),
                //         ),
                //         const SizedBox(height: 8),
                //         Text(
                //           'You haven\'t made any bookings yet.\nBook machinery to see them here.',
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: Colors.grey.shade600,
                //           ),
                //         ),
                //       ],
                //     ),
                //   );
                // }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    //all machinery
                    ListView.builder(
                      itemCount: machineProvider.filterdProviderMachinery.length,
                      itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: buildProviderMachineryCard(context,machineProvider.filterdProviderMachinery[index]),
                      );
                    },)
                    //requested machinery


                    //accepted

                    //completed


                    // machineryDataProvider.filteredBooking
                    //     .where((booking) => booking.status.toLowerCase() == 'pending' ||
                    //     booking.status.toLowerCase() == 'confirmed')
                    //     .toList()
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }


}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({super.key, required this.booking});

  Color _getStatusColor() {
    switch (booking.status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final formattedStartDate = DateFormat('MMM dd, yyyy').format(booking.startDate);
    final formattedEndDate = DateFormat('MMM dd, yyyy').format(booking.endDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with status and machine name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  statusColor.withOpacity(0.1),
                  statusColor.withOpacity(0.2),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    booking.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    booking.machinery.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dates
                Row(
                  children: [
                    Expanded(
                      child: _InfoItem(
                        icon: CupertinoIcons.calendar,
                        title: 'Start Date',
                        value: formattedStartDate,
                        iconColor: Colors.blue,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey.shade200,
                    ),
                    Expanded(
                      child: _InfoItem(
                        icon: CupertinoIcons.calendar,
                        title: 'End Date',
                        value: formattedEndDate,
                        iconColor: Colors.red,
                      ),
                    ),
                  ],
                ),

                const Divider(height: 32),

                // Price
                _InfoItem(
                  icon: CupertinoIcons.money_dollar_circle,
                  title: 'Total Amount',
                  value: '₹${booking.totalAmount}',
                  iconColor: Colors.green,
                ),

                const SizedBox(height: 16),

                // Location
                _InfoItem(
                  icon: CupertinoIcons.location,
                  title: 'Delivery Location',
                  value: booking.address,
                  iconColor: Colors.orange,
                ),

                if (booking.withOperator) ...[
                  const SizedBox(height: 16),
                  _InfoItem(
                    icon: CupertinoIcons.person,
                    title: 'Operator',
                    value: 'Included',
                    iconColor: Colors.purple,
                  ),
                ],

                if (booking.notes?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 16),
                  _InfoItem(
                    icon: CupertinoIcons.doc_text,
                    title: 'Notes',
                    value: booking.notes ?? '',
                    iconColor: Colors.blue.shade300,
                  ),
                ],

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Edit booking functionality
                        },
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey.shade200,
                                Colors.grey.shade300,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.pencil,
                                color: Colors.grey.shade700,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          // Show confirmation dialog
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => _DeleteConfirmationDialog(),
                          );

                          if (confirm == true) {
                            bool val = await context.read<BookingProvider>().deleteBooking(booking.sId, context);
                            if(val) context.machineryDataProvider.fetchAllData();
                          }
                        },
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.shade300,
                                Colors.red.shade400,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.shade200.withOpacity(0.3),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                CupertinoIcons.delete,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DeleteConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.delete,
                color: Colors.red.shade400,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Delete Booking',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to delete this booking? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(true),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.shade400,
                            Colors.red.shade600,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


