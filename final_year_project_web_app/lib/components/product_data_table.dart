import 'package:flutter/material.dart';
import 'package:final_year_project_web_app/model/product.dart';

class ProductDataTable extends StatelessWidget {
  final List<Product> products;

  const ProductDataTable({super.key, required this.products});

  Widget _buildHeaderCell(String label, double width,
      {bool isLast = false, bool centerText = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          right: isLast ? BorderSide.none : const BorderSide(color: Colors.white, width: 1),
          bottom: const BorderSide(color: Colors.white, width: 1),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: centerText ? TextAlign.center : TextAlign.start,
      ),
    );
  }

  Widget _buildCell(String text, double width,
      {bool isLast = false, bool centerText = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          right: isLast ? BorderSide.none : const BorderSide(color: Colors.white, width: 1),
        ),
      ),
      child: Text(
        text,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        textAlign: centerText ? TextAlign.center : TextAlign.start,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Total weight is 13.5. Compute each column's width.
        double totalWeight = 13.5;
        double idWidth = constraints.maxWidth * (0.8 / totalWeight);
        double companyIdWidth = constraints.maxWidth * (0.8 / totalWeight);
        double nameWidth = constraints.maxWidth * (1 / totalWeight);
        double brandNameWidth = constraints.maxWidth * (1 / totalWeight);
        double categoryWidth = constraints.maxWidth * (1 / totalWeight);
        double subCategoryWidth = constraints.maxWidth * (1 / totalWeight);
        double nutritionalWidth = constraints.maxWidth * (1.7 / totalWeight);
        double ingredientsWidth = constraints.maxWidth * (1 / totalWeight);
        double storageWidth = constraints.maxWidth * (1.7 / totalWeight);
        double priceWidth = constraints.maxWidth * (0.8 / totalWeight);
        double keywordsWidth = constraints.maxWidth * (1 / totalWeight);
        double additionalWidth = constraints.maxWidth * (1.7 / totalWeight);

        // Fixed heights for header and each data row.
        double headerHeight = 80;  // approximately two rows tall
        double rowHeight = 100;    // approximately four rows tall

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: headerHeight,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeaderCell("ID", idWidth, centerText: true),
                      _buildHeaderCell("Company ID", companyIdWidth, centerText: true),
                      _buildHeaderCell("Name", nameWidth, centerText: true),
                      _buildHeaderCell("Brand Name", brandNameWidth, centerText: true),
                      _buildHeaderCell("Category", categoryWidth, centerText: true),
                      _buildHeaderCell("Sub Category", subCategoryWidth, centerText: true),
                      _buildHeaderCell("Nutritional Information", nutritionalWidth, centerText: true),
                      _buildHeaderCell("Ingredients", ingredientsWidth, centerText: true),
                      _buildHeaderCell("Storage Instruction", storageWidth, centerText: true),
                      _buildHeaderCell("Price", priceWidth, centerText: true),
                      _buildHeaderCell("Keywords", keywordsWidth, centerText: true),
                      _buildHeaderCell("Additional Information", additionalWidth, isLast: true, centerText: true),
                    ],
                  ),
                ),
              ),
              ...products.map((product) {
                return SizedBox(
                  height: rowHeight,
                  child: IntrinsicHeight(
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildCell(product.id.toString(), idWidth, centerText: true),
                          _buildCell(product.companyId.toString(), companyIdWidth, centerText: true),
                          _buildCell(product.name, nameWidth),
                          _buildCell(product.brandName, brandNameWidth),
                          _buildCell(product.category, categoryWidth),
                          _buildCell(product.subCategory, subCategoryWidth),
                          _buildCell(product.nutritionalInfo, nutritionalWidth),
                          _buildCell(product.ingredients, ingredientsWidth),
                          _buildCell(product.storageInstruction, storageWidth),
                          _buildCell(product.price.toString(), priceWidth, centerText: true),
                          _buildCell(product.keywords.join(', '), keywordsWidth),
                          _buildCell(product.additionalInfo, additionalWidth, isLast: true),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
