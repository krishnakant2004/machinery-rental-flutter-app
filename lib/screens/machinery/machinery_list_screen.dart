import 'package:flutter/material.dart';
import 'package:my_app/core/data/machinary_rental_data_provider.dart';
import 'package:my_app/utils/extension.dart';
import 'package:my_app/widgets/customeNetworkImage.dart';
import 'package:provider/provider.dart';
import '../../models/machinery_model.dart';
import 'machinery_detail_screen.dart';

class MachineryListScreen extends StatefulWidget {
  const MachineryListScreen({super.key});

  @override
  State<MachineryListScreen> createState() => _MachineryListScreenState();
}

class _MachineryListScreenState extends State<MachineryListScreen> {
  bool availableOnly = false;
  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.machineryDataProvider.fetchMachinery();
      Future.delayed(const Duration(seconds: 2));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget ErrorWidget = SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Something went wrong',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 4,
            ),
            ElevatedButton.icon(
              onPressed: () {
                context.machineryDataProvider.fetchMachinery();
              },
              label: const Text('Refresh'),
              icon: const Icon(Icons.refresh),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    return RefreshIndicator(
      onRefresh: () => context.machineryDataProvider.fetchMachinery(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search machinery...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      context.machineryDataProvider.filterAllMachinery(value);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                ),
              ],
            ),
          ),
          Consumer<MachineryDataProvider>(
            builder: (context, machineryDataProvider, child) {
              return Expanded(
                child: machineryDataProvider.machineryLoading &&
                        machineryDataProvider.filteredMachinery.isEmpty
                    ? Center(
                        child: Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "fetching data...",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                    : context.machineryDataProvider.filteredMachinery.isEmpty
                        ? Center(
                            child: Text("no data"),
                          )
                        : ListView.builder(
                            itemCount: context
                                .machineryDataProvider.filteredMachinery.length,
                            itemBuilder: (ctx, i) => MachineryListItem(
                              machinery: context
                                  .machineryDataProvider.filteredMachinery[i],
                            ),
                          ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Filter Machinery'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Type'),
              items: const [
                DropdownMenuItem(value: 'All', child: Text('All')),
                DropdownMenuItem(value: 'Tractor', child: Text('Tractor')),
                DropdownMenuItem(value: 'Harvester', child: Text('Harvester')),
                DropdownMenuItem(
                    value: 'Cultivator', child: Text('Cultivator')),
                DropdownMenuItem(value: 'Thresher', child: Text('Thresher')),
                DropdownMenuItem(value: 'Sprayer', child: Text('Sprayer')),
                DropdownMenuItem(value: 'WaterPump', child: Text('Water Pump')),
              ],
              onChanged: (value) {
                context.machineryDataProvider
                    .filterAllMachineryByType(value ?? '');
              },
            ),
            Consumer<MachineryDataProvider>(
              builder: (context, provider, child) {
                return CheckboxListTile(
                  title: const Text('Available Only'),
                  value: availableOnly,
                  onChanged: (value) {
                      availableOnly = !availableOnly;
                      if (availableOnly == true) {
                        context.machineryDataProvider.filterAvailableOnly();
                      } else {
                        context.machineryDataProvider.filterAllMachinery("All");
                      }

                  },
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Apply filters
              Navigator.of(ctx).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

class MachineryListItem extends StatelessWidget {
  final Machinery machinery;

  const MachineryListItem({
    super.key,
    required this.machinery,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              machinery.availability ?? false
                  ? Colors.green.shade50
                  : Colors.red.shade50,
            ],
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => MachineryDetailScreen(machinery: machinery),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Machinery Image
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: machinery.images.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child:CustomNetworkImage(imageUrl: machinery.images.safeElementAt(0)?.url ?? ''),
                  )
                      : const Center(
                    child: Icon(
                      Icons.agriculture,
                      size: 35,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Machinery Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        machinery.name ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        machinery.type ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${machinery.dailyRate}/day',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Availability Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: machinery.availability ?? false
                          ? [Colors.green.shade300, Colors.green.shade600]
                          : [Colors.red.shade300, Colors.red.shade600],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    machinery.availability ?? false ? 'Available' : 'Unavailable',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
