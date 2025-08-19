import 'package:flutter/material.dart';
import 'package:final_year_project_web_app/services/product_service.dart';

class AddProductDialog extends StatefulWidget {
  final int companyId;
  final Function onProductAdded;

  const AddProductDialog({Key? key, required this.companyId, required this.onProductAdded}) : super(key: key);

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subCategoryController = TextEditingController();
  final TextEditingController _nutritionalInfoController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _storageInstructionsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _keywordsController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();

  bool _isLoading = false;

  Future<void> _addProduct() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Map<String, dynamic> productData = {
      "companyId": widget.companyId,
      "name": _nameController.text,
      "brandName": _brandNameController.text,
      "category": _categoryController.text,
      "subCategory": _subCategoryController.text,
      "nutritionalInfo": _nutritionalInfoController.text,
      "ingredients": _ingredientsController.text,
      "storageInstruction": _storageInstructionsController.text,
      "price": double.tryParse(_priceController.text) ?? 0.0,
      "keywords": _keywordsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      "additionalInfo": _additionalInfoController.text,
    };

    setState(() {
      _isLoading = true;
    });
    try {
      await ProductService().addProduct(productData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );
      widget.onProductAdded();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTextFormField(TextEditingController controller, String hintText,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.grey[200],
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter $hintText";
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add New Product Information",
                  style: TextStyle(
                    color: Color(0xFF613EEA),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextFormField(_nameController, "Name"),
                const SizedBox(height: 15),
                _buildTextFormField(_brandNameController, "Brand Name"),
                const SizedBox(height: 15),
                _buildTextFormField(_categoryController, "Category"),
                const SizedBox(height: 15),
                _buildTextFormField(_subCategoryController, "Sub Category"),
                const SizedBox(height: 15),
                _buildTextFormField(_nutritionalInfoController, "Nutritional Information"),
                const SizedBox(height: 15),
                _buildTextFormField(_ingredientsController, "Ingredients"),
                const SizedBox(height: 15),
                _buildTextFormField(_storageInstructionsController, "Storage Instructions"),
                const SizedBox(height: 15),
                _buildTextFormField(_priceController, "Price", keyboardType: TextInputType.number),
                const SizedBox(height: 15),
                _buildTextFormField(_keywordsController, "Keywords (comma separated)"),
                const SizedBox(height: 15),
                _buildTextFormField(_additionalInfoController, "Additional Information"),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _addProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF613EEA),
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          "Add Item",
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
