import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecom_client_f/controller/purchase_controller.dart';
import '../model/product/product.dart'; // Assuming product.dart is in model folder

class ProductDescriptionPage extends StatelessWidget {
  const ProductDescriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Product product = Get.arguments['data'];
    return GetBuilder<PurchaseController>(
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Product Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.image ?? '',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  product.name ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  product.description ?? '',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                SizedBox(height: 20),
                Text(
                  'Rs: ${product.price ?? ''}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: ctrl.addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: 'Enter your billing address!',
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.indigo,
                    ),
                    onPressed: () {
                      ctrl.submitOrder(
                        price: product.price ?? 0,
                        item: product.name ?? '',
                        description: product.description ?? '',
                      );
                      print('buy now tapped');
                    },
                    child: Text(
                      'Buy Now',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
