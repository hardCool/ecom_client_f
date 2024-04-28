
import 'package:ecom_client_f/controller/home_controller.dart';
import 'package:ecom_client_f/pages/login_pages.dart';
import 'package:ecom_client_f/pages/product_description_page.dart';
import 'package:ecom_client_f/widgets/mult_select_dropdown_btn.dart';
import 'package:ecom_client_f/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecom_client_f/widgets/drop_down_btn.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return RefreshIndicator(
        onRefresh: () async {
          ctrl.fetchProducts();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                'Nutri Nector Store',
                style: TextStyle(fontWeight: FontWeight.bold)
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    GetStorage box = GetStorage();
                    box.erase();
                    Get.offAll(LoginPage());
                  },
                  icon: Icon(Icons.logout)
              )
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ctrl.productCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          ctrl.filterByCategory(ctrl.productCategories[index].name ?? '');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Chip(label: Text(ctrl.productCategories[index].name ?? 'Error')),
                        ),
                      );
                    }
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: DropDownBtn( // Correct the usage of DropDownBtn
                      items: ['Rs: Low to High', 'Rs: High to Low'],
                      selectedItemText: 'Sort',
                      onSelected: (selected) {
                        ctrl.sortByPrice(ascending: selected == 'Rs: Low to High' ? true : false);
                      },
                    ),
                  ),
                  Flexible(child: MultiSelectDropdownBtn(
                    items: ['Nutri Nector', 'Others'],
                    onSelectionChanged: (selectedItems) {
                      ctrl.filterByBrand(selectedItems);
                    },
                  )
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: ctrl.filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        name: ctrl.filteredProducts[index].name ?? 'No name',
                        imageUrl: ctrl.filteredProducts[index].image ?? 'No name',
                        price: ctrl.filteredProducts[index].price ?? 00,
                        offerTag: '20 % off',
                        onTap: () {
                          Get.to(ProductDescriptionPage(), arguments: {'data':ctrl.filteredProducts[index]});
                        },
                      );
                    }
                ),
              )

            ],
          ),
        ),
      );
    });
  }
}
