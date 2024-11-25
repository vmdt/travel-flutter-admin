import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:travel_management/controllers/discount_controller.dart';

class DiscountManagementScreen extends StatelessWidget {
  DiscountManagementScreen({Key? key}) : super(key: key);

  final DiscountController discountController = Get.put(DiscountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discount Management'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Obx(() {
          return ListView.builder(
            itemCount: discountController.discounts.length,
            itemBuilder: (context, index) {
              final discount = discountController.discounts[index];
              return DiscountCard(
                discountName: discount['discount_name']!,
                type: discount['type']!,
                value: discount['value']!,
                startDate: discount['startDate']!,
                endDate: discount['endDate']!,
                onSendNotification: () {
                  Get.snackbar(
                    "Notification Sent",
                    "Notification sent for ${discount['discount_name']}",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                onEdit: () {
                  showEditPopup(context, index);
                },
                onDelete: () {
                  discountController.deleteDiscount(index);
                  Get.snackbar(
                    "Deleted",
                    "Discount '${discount['discount_name']}' has been deleted.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                },
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddPopup(context);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddPopup(BuildContext context) {
    final nameController = TextEditingController();
    final typeController = TextEditingController();
    final valueController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final formKey = GlobalKey<FormState>(); // Key for form validation
    String? selectedType;

    Future<void> pickDate(
        BuildContext context, TextEditingController controller) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        controller.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Discount'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey, // Attach the form key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Discount Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Discount Name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    items: ['Percentage', 'Fixed Amount']
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ),
                        )
                        .toList(),
                    decoration: const InputDecoration(labelText: 'Type'),
                    onChanged: (value) {
                      selectedType = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Type is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: valueController,
                    decoration: const InputDecoration(labelText: 'Value'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Value is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: startDateController,
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => pickDate(context, startDateController),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Start Date is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: endDateController,
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => pickDate(context, endDateController),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'End Date is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  discountController.addDiscount({
                    'discount_name': nameController.text,
                    'type': selectedType!,
                    'value': valueController.text,
                    'startDate': startDateController.text,
                    'endDate': endDateController.text,
                  });
                  Get.back();
                  Get.snackbar(
                    "Added",
                    "Discount '${nameController.text}' has been added.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showEditPopup(BuildContext context, int index) {
    final discount = discountController.discounts[index];
    final nameController =
        TextEditingController(text: discount['discount_name']);
    final valueController = TextEditingController(text: discount['value']);
    final startDateController =
        TextEditingController(text: discount['startDate']);
    final endDateController = TextEditingController(text: discount['endDate']);
    final formKey = GlobalKey<FormState>(); // Key for form validation
    String? selectedType = discount['type'];

    Future<void> pickDate(
        BuildContext context, TextEditingController controller) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        controller.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Discount'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey, // Attach the form key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Discount Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Discount Name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    items: ['Percentage', 'Fixed Amount']
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ),
                        )
                        .toList(),
                    decoration: const InputDecoration(labelText: 'Type'),
                    onChanged: (value) {
                      selectedType = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Type is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: valueController,
                    decoration: const InputDecoration(labelText: 'Value'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Value is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: startDateController,
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => pickDate(context, startDateController),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Start Date is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: endDateController,
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => pickDate(context, endDateController),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'End Date is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  discountController.editDiscount(index, {
                    'discount_name': nameController.text,
                    'type': selectedType!,
                    'value': valueController.text,
                    'startDate': startDateController.text,
                    'endDate': endDateController.text,
                  });
                  Get.back();
                  Get.snackbar(
                    "Updated",
                    "Discount '${nameController.text}' has been updated.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class DiscountCard extends StatelessWidget {
  final String discountName;
  final String type;
  final String value;
  final String startDate;
  final String endDate;
  final VoidCallback onSendNotification;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DiscountCard({
    Key? key,
    required this.discountName,
    required this.type,
    required this.value,
    required this.startDate,
    required this.endDate,
    required this.onSendNotification,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              discountName,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Type: $type',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
                Text(
                  'Value: $value',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'Start Date: $startDate',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            ),
            Text(
              'End Date: $endDate',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text('Edit'),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('Delete'),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: onSendNotification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Send Notification'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
