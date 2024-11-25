import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DiscountController extends GetxController {
  final box = GetStorage(); // Sử dụng GetStorage
  var discounts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDiscounts(); // Tải dữ liệu từ GetStorage
  }

  // Tải dữ liệu từ GetStorage
  void loadDiscounts() {
    final data = box.read('discounts');
    if (data != null) {
      discounts.value =
          List<Map<String, dynamic>>.from(json.decode(data) as List);
    }
  }

  // Lưu dữ liệu vào GetStorage
  void saveDiscounts() {
    box.write('discounts', json.encode(discounts));
  }

  // Thêm một discount
  void addDiscount(Map<String, String> discount) {
    discounts.add(discount);
    saveDiscounts();
  }

  // Chỉnh sửa một discount
  void editDiscount(int index, Map<String, String> updatedDiscount) {
    discounts[index] = updatedDiscount;
    saveDiscounts();
  }

  // Xóa một discount
  void deleteDiscount(int index) {
    discounts.removeAt(index);
    saveDiscounts();
  }
}
