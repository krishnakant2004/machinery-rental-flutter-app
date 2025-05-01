import 'package:flutter/material.dart';
import 'package:my_app/core/data/machinary_rental_data_provider.dart';
import 'package:my_app/models/machinery_model.dart';
import 'package:my_app/screens/machinery/provider/machinery_provider.dart';
import 'package:my_app/utils/extension.dart';
import 'package:my_app/widgets/product_image_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../utils/constants.dart';

class AddMachineryScreen extends StatelessWidget {
  Machinery? machinery;
  AddMachineryScreen({super.key, required this.machinery});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if(machinery == null){
      for (var spec in context.machineryProvider.defaultSpecs) {
        context.machineryProvider.specControllers[spec] = TextEditingController();
      }
    }
    context.machineryProvider.setDataForUpdateMachinery(machinery);

    return Scaffold(

      appBar: AppBar(
        title: const Text('Add Machinery',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: context.machineryProvider.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.blue.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Machinery Images',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kDarkBlueColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Consumer<MachineryProvider>(
                            builder: (context, machineryProvider, child) {
                              return _buildImageCard(
                                context,
                                machineryProvider,
                                "Main Image",
                                context.machineryProvider.firstImage,
                                machinery?.images.safeElementAt(0)?.url,
                                1,
                                Colors.blue.shade400,
                                Colors.blue.shade700,
                              );
                            },
                          ),
                          Consumer<MachineryProvider>(
                            builder: (context, machineryProvider, child) {
                              return _buildImageCard(
                                context,
                                machineryProvider,
                                "Second Image",
                                context.machineryProvider.secondImage,
                                machinery?.images.safeElementAt(1)?.url,
                                2,
                                Colors.teal.shade400,
                                Colors.teal.shade700,
                              );
                            },
                          ),
                          Consumer<MachineryProvider>(
                            builder: (context, machineryProvider, child) {
                              return _buildImageCard(
                                context,
                                machineryProvider,
                                "Third Image",
                                context.machineryProvider.thirdImage,
                                machinery?.images.safeElementAt(2)?.url ,
                                3,
                                Colors.purple.shade400,
                                Colors.purple.shade700,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.green.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Basic Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kDarkGreenColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: context.machineryProvider.nameController,
                        labelText: 'Machinery Name',
                        prefixIcon: Icons.engineering,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter machinery name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        value: context.machineryProvider.selectedType,
                        labelText: 'Machinery Type',
                        prefixIcon: Icons.category,
                        items: context.machineryProvider.machineryTypes,
                        onChanged: (value) {
                          context.machineryProvider.changeSelectedType(value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: context.machineryProvider.addressController,
                        labelText: 'Address',
                        prefixIcon: Icons.location_on,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: context.machineryProvider.descriptionController,
                        labelText: 'Description',
                        prefixIcon: Icons.description,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.amber.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pricing & Availability',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: context.machineryProvider.hourlyRateController,
                              labelText: 'Hourly Rate (₹)',
                              prefixIcon: Icons.schedule,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter hourly rate';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: context.machineryProvider.dailyRateController,
                              labelText: 'Daily Rate (₹)',
                              prefixIcon: Icons.calendar_today,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter daily rate';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Consumer<MachineryProvider>(
                        builder: (context, machineProvider, child) {
                          return Column(
                            children: [
                              _buildSwitchTile(
                                title: 'Operator Available',
                                value: context.machineryProvider.operatorAvailable,
                                activeColor: Colors.green,
                                inactiveColor: Colors.grey,
                                onChanged: (value) {
                                  context.machineryProvider.changeOperatorAvailable(value);
                                },
                                icon: Icons.person,
                              ),
                              if (context.machineryProvider.operatorAvailable) ...[
                                _buildTextField(
                                  controller: context.machineryProvider.operatorChargesController,
                                  labelText: 'Operator Charges (₹/day)',
                                  prefixIcon: Icons.money,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter operator charges';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                      Consumer<MachineryProvider>(
                        builder: (context, machineProvider, child) {
                          return Column(
                            children: [
                              _buildSwitchTile(
                                title: 'Machinery Availability',
                                value: context.machineryProvider.availability,
                                activeColor: Colors.green,
                                inactiveColor: Colors.grey,
                                onChanged: (value) {
                                  context.machineryProvider.changeMachineryAvailable(value);
                                },
                                icon: Icons.check_circle,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.purple.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Specifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...context.machineryProvider.defaultSpecs.map(
                            (spec) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildTextField(
                            controller: context.machineryProvider.specControllers[spec]!,
                            labelText: spec,
                            prefixIcon: Icons.settings,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Consumer<MachineryProvider>(
                  builder: (context, provider, child) {
                    return _buildGradientButton(
                      onPressed: context.machineryProvider.isLoading
                          ? null
                          : () {
                        context.machineryProvider.submitMachinery();
                        context.machineryProvider.getProviderMachinery();
                        context.machineryDataProvider.fetchMachinery();
                        Navigator.pop(context);
                      },
                      child: context.machineryProvider.isLoading
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add_circle, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            machinery == null ? 'Add Machinery' : 'Update Machinery',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(
      BuildContext context,
      MachineryProvider provider,
      String label,
      dynamic imageFile,
      String? imageUrl,
      int imageNumber,
      Color startColor,
      Color endColor,
      ) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [startColor.withOpacity(0.2), endColor.withOpacity(0.3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ProductImageCard(
            labelText: label,
            imageFile: imageFile,
            imageUrlForUpdateImage: imageUrl,
            onTap: () {
              provider.pickerImage(imageNumber: imageNumber);
            },
            onRemoveImage: () {
              if (imageNumber == 1) {
                provider.firstImage = null;
              } else if (imageNumber == 2) {
                provider.secondImage = null;
              } else {
                provider.thirdImage = null;
              }
              provider.updateUI();
            },
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.camera_alt,
              size: 16,
              color: endColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? prefixIcon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kDarkBlueColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kDarkRedColor, width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: kDarkBlueColor) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String labelText,
    required List<String> items,
    required void Function(String?) onChanged,
    IconData? prefixIcon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kDarkBlueColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: kDarkBlueColor) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items
          .map((type) => DropdownMenuItem(
        value: type,
        child: Text(type),
      ))
          .toList(),
      onChanged: onChanged,
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down_circle, color: kDarkBlueColor),
      isExpanded: true,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required void Function(bool) onChanged,
    required IconData icon,
    Color activeColor = Colors.green,
    Color inactiveColor = Colors.grey,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: Icon(icon, color: value ? activeColor : inactiveColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: value ? activeColor : Colors.grey.shade700,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
          inactiveTrackColor: inactiveColor.withOpacity(0.3),
          thumbColor: WidgetStatePropertyAll(value ? Colors.white : Colors.white),
          trackOutlineColor: WidgetStatePropertyAll(Colors.transparent),
          trackOutlineWidth: const WidgetStatePropertyAll(0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: onPressed == null
              ? [Colors.grey.shade400, Colors.grey.shade600]
              : [kDarkBlueColor, kDarkGreenColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: onPressed == null
            ? []
            : [
          BoxShadow(
            color: kDarkBlueColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          splashColor: Colors.white.withOpacity(0.1),
          child: Center(child: child),
        ),
      ),
    );
  }
}