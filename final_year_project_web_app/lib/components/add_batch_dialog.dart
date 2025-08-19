import 'package:flutter/material.dart';
import 'package:final_year_project_web_app/model/batch.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBatchDialog extends StatefulWidget {
  final Function(Batch) onAddBatch;

  const AddBatchDialog({Key? key, required this.onAddBatch}) : super(key: key);

  @override
  State<AddBatchDialog> createState() => _AddBatchDialogState();
}

class _AddBatchDialogState extends State<AddBatchDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _batchNoController = TextEditingController();
  final TextEditingController _manufacturingDateController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();
  final TextEditingController _batchQuantityController = TextEditingController();
  final TextEditingController _manufacturerUsernameController = TextEditingController();
  final TextEditingController _manufacturerRoleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // Load manufacturer username and role from SharedPreferences and update the UI.
  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? role = prefs.getString('role');
    setState(() {
      _manufacturerUsernameController.text = username ?? "";
      _manufacturerRoleController.text = role ?? "";
    });
  }

  // Show date picker and update the corresponding controller.
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.now();
    try {
      initialDate = DateFormat('yyyy-MM-dd').parse(controller.text);
    } catch (_) {}
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
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
                  "Add Manufacturing Batch",
                  style: TextStyle(
                    color: Color(0xFF613EEA),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextFormField(
                  controller: _productIdController,
                  hintText: "Product ID",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                _buildTextFormField(
                  controller: _batchNoController,
                  hintText: "Batch No",
                ),
                const SizedBox(height: 15),
                _buildTextFormField(
                  controller: _manufacturingDateController,
                  hintText: "Manufacturing Date (YYYY-MM-DD)",
                  readOnly: true,
                  onTap: () => _selectDate(context, _manufacturingDateController),
                ),
                const SizedBox(height: 15),
                _buildTextFormField(
                  controller: _expirationDateController,
                  hintText: "Expiration Date (YYYY-MM-DD)",
                  readOnly: true,
                  onTap: () => _selectDate(context, _expirationDateController),
                ),
                const SizedBox(height: 15),
                _buildTextFormField(
                  controller: _batchQuantityController,
                  hintText: "Batch Quantity",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                // Auto-filled manufacturer fields: no hint or label text, just the actual value.
                _buildTextFormField(
                  controller: _manufacturerUsernameController,
                  hintText: "",
                  readOnly: true,
                ),
                const SizedBox(height: 15),
                _buildTextFormField(
                  controller: _manufacturerRoleController,
                  hintText: "",
                  readOnly: true,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final int? productId = int.tryParse(_productIdController.text);
                      final int? batchQuantity = int.tryParse(_batchQuantityController.text);
                      if (productId == null || batchQuantity == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter valid numbers for Product ID and Batch Quantity')),
                        );
                        return;
                      }
                      final Batch newBatch = Batch(
                        productId: productId,
                        batchNo: _batchNoController.text,
                        manufacturingDate: _manufacturingDateController.text,
                        expireDate: _expirationDateController.text,
                        batchQuantity: batchQuantity,
                        manufacturerUsername: _manufacturerUsernameController.text,
                        manufacturerRole: _manufacturerRoleController.text,
                      );
                      widget.onAddBatch(newBatch);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF613EEA),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    "Add Batch",
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        // No labelText/hint for auto-filled fields if readOnly and hintText is empty.
        hintText: readOnly && hintText.isEmpty ? null : hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: Colors.grey[200],
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Please enter ${hintText.isEmpty ? 'this field' : hintText}";
        }
        return null;
      },
    );
  }
}
