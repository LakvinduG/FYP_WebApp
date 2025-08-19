import 'package:flutter/material.dart';
import 'package:final_year_project_web_app/model/batch.dart';

class ManufacturingInfoTable extends StatelessWidget {
  final List<Batch> batches;
  final Function(String?) onQRCodeTap;

  const ManufacturingInfoTable({
    super.key,
    required this.batches,
    required this.onQRCodeTap,
  });

  Widget _buildHeaderCell(String label, double width,
      {bool isLast = false, bool centerText = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(
          right:
              isLast ? BorderSide.none : const BorderSide(color: Colors.white, width: 1),
          // No bottom border here; divider widget will be used instead.
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
          right: isLast
              ? BorderSide.none
              : const BorderSide(color: Colors.white, width: 1),
          // No bottom border; the divider widget will serve that purpose.
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        softWrap: true,
        overflow: TextOverflow.visible,
        textAlign: centerText ? TextAlign.center : TextAlign.start,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Use the available maxWidth to compute column widths.
      double totalWidth = constraints.maxWidth;
      double productIdWidth = totalWidth * 0.06;
      double batchNoWidth = totalWidth * 0.08;
      double manufacturingDateWidth = totalWidth * 0.10;
      double expirationDateWidth = totalWidth * 0.10;
      double batchQuantityWidth = totalWidth * 0.10;
      double manufacturerUsernameWidth = totalWidth * 0.13;
      double manufacturerRoleWidth = totalWidth * 0.12;
      double manufacturedIdWidth = totalWidth * 0.14;
      double qrCodeWidth = totalWidth * 0.15;

      return Container(
        margin: const EdgeInsets.all(16.0),
        // Remove inner padding so borders can align flush.
        padding: EdgeInsets.zero,
        width: totalWidth,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          // Outer border around the entire table.
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeaderCell("Product ID", productIdWidth, centerText: true),
                      _buildHeaderCell("Batch No", batchNoWidth, centerText: true),
                      _buildHeaderCell("Manufacturing Date", manufacturingDateWidth, centerText: true),
                      _buildHeaderCell("Expiration Date", expirationDateWidth, centerText: true),
                      _buildHeaderCell("Batch Quantity", batchQuantityWidth, centerText: true),
                      _buildHeaderCell("Manufacturer Username", manufacturerUsernameWidth, centerText: true),
                      _buildHeaderCell("Manufacturer Role", manufacturerRoleWidth, centerText: true),
                      _buildHeaderCell("Manufactured ID (QR ID)", manufacturedIdWidth, centerText: true),
                      _buildHeaderCell("QR Code", qrCodeWidth, isLast: true, centerText: true),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Colors.white),
              ],
            ),
            ...batches.map((batch) {
              return Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCell(batch.productId?.toString() ?? '', productIdWidth, centerText: true),
                        _buildCell(batch.batchNo ?? '', batchNoWidth, centerText: true),
                        _buildCell(batch.manufacturingDate ?? '', manufacturingDateWidth, centerText: true),
                        _buildCell(batch.expireDate ?? '', expirationDateWidth, centerText: true),
                        _buildCell(batch.batchQuantity?.toString() ?? '', batchQuantityWidth, centerText: true),
                        _buildCell(batch.manufacturerUsername ?? '', manufacturerUsernameWidth, centerText: true),
                        _buildCell(batch.manufacturerRole ?? '', manufacturerRoleWidth, centerText: true),
                        _buildCell(batch.manufacturedId ?? '', manufacturedIdWidth, centerText: true),
                        Container(
                          width: qrCodeWidth,
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.white, width: 1),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: ElevatedButton.icon(
                              onPressed: () => onQRCodeTap(batch.manufacturedId),
                              icon: const Icon(Icons.open_in_new, size: 18),
                              label: const Text("Open QR in Browser"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                minimumSize: const Size(150, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Colors.white),
                ],
              );
            }).toList(),
          ],
        ),
      );
    });
  }
}
