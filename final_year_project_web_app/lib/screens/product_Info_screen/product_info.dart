import 'package:flutter/material.dart';
import 'package:final_year_project_web_app/model/product.dart';
import 'package:final_year_project_web_app/services/product_service.dart';
import 'package:final_year_project_web_app/components/product_data_table.dart';
import 'package:final_year_project_web_app/components/add_product_dialog.dart';
import 'package:final_year_project_web_app/screens/manufacturing_Info_screen/manufacturing_info.dart';
import 'package:final_year_project_web_app/components/company_info_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ProductInformationScreen
///
/// Displays the list of products for the logged-in company.
/// Features:
/// - Fetches companyId from SharedPreferences
/// - Shows company information at the top
/// - Displays products in a data table
/// - Provides option to add new products via a dialog
/// - Navigation to ManufacturingInfoScreen via AppBar action
class ProductInformationScreen extends StatefulWidget {
  const ProductInformationScreen({Key? key}) : super(key: key);

  @override
  State<ProductInformationScreen> createState() =>
      _ProductInformationScreenState();
}

class _ProductInformationScreenState extends State<ProductInformationScreen> {
  List<Product> _products = [];
  int? _companyId;

  @override
  void initState() {
    super.initState();
    _loadCompanyId();
  }

  ///  LOAD COMPANY ID
  Future<void> _loadCompanyId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _companyId = prefs.getInt('companyId');
    });
    if (_companyId != null) {
      _fetchProducts();
    } else {
      print('No companyId found in shared preferences');
    }
  }

  ///  FETCH PRODUCTS
  Future<void> _fetchProducts() async {
    try {
      List<Product> products =
          await ProductService().fetchProductsByCompanyId(_companyId!);
      setState(() {
        _products = products;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  ///  SHOW ADD PRODUCT DIALOG
  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AddProductDialog(
        companyId: _companyId!,
        onProductAdded: _fetchProducts,
      ),
    );
  }


  // =========================
  //  UI BUILD
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.purple[50],
        elevation: 0,
        title: const Center(
          child: Text(
            "Product Information",
            style: TextStyle(
              color: Color(0xFFB76DEC),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.business, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManufacturingInfoScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Show company info at the top
          const CompanyInfoWidget(),
          // Transparent container for the product table
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ProductDataTable(products: _products),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        backgroundColor: const Color(0xFF613EEA),
        child: const Icon(Icons.add),
      ),
    );
  }
}
