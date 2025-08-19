import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:final_year_project_web_app/model/batch.dart';
import 'package:final_year_project_web_app/services/manufacturing_service.dart';
import 'package:final_year_project_web_app/components/manufacturing_info_table.dart';
import 'package:final_year_project_web_app/components/add_batch_dialog.dart';
import 'package:final_year_project_web_app/components/company_info_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ManufacturingInfoScreen
///
/// Displays the manufacturing information of a company.
/// Features:
/// - Fetches companyId from SharedPreferences
/// - Shows list of batches in a table
/// - Launches QR code links for each batch
/// - Allows adding new batches via a dialog
class ManufacturingInfoScreen extends StatefulWidget {
  const ManufacturingInfoScreen({Key? key}) : super(key: key);

  @override
  State<ManufacturingInfoScreen> createState() =>
      _ManufacturingInfoScreenState();
}

class _ManufacturingInfoScreenState extends State<ManufacturingInfoScreen> {
  final ManufacturingService _manufacturingService = ManufacturingService();
  int? _companyId; // Removed fixed company ID
  List<Batch> _batches = [];

  @override
  void initState() {
    super.initState();
    _loadCompanyId();
  }

  /// LOAD COMPANY ID
  Future<void> _loadCompanyId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _companyId = prefs.getInt('companyId');
    });
    if (_companyId != null) {
      _fetchBatches();
    } else {
      print('No companyId found in shared preferences');
    }
  }

  ///  FETCH BATCHES
  Future<void> _fetchBatches() async {
    try {
      List<Batch> batches =
          await _manufacturingService.fetchBatchesByCompanyId(_companyId!);
      setState(() {
        _batches = batches;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch batches: $e')),
      );
    }
  }

  ///  LAUNCH QR CODE URL
  Future<void> _launchQRCode(String? manufacturedId) async {
    if (manufacturedId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No manufacturedId available for this item')),
      );
      return;
    }

    final Uri qrUri =
        Uri.parse('${_manufacturingService.baseUrl}/qr/$manufacturedId');

    if (await canLaunchUrl(qrUri)) {
      await launchUrl(
        qrUri,
        mode: LaunchMode.platformDefault,
        webOnlyWindowName: '_blank',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch QR code URL')),
      );
    }
  }

  ///  SHOW ADD BATCH DIALOG
  void _showAddBatchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddBatchDialog(
          onAddBatch: (Batch newBatch) async {
            try {
              await _manufacturingService.addBatch(newBatch, _companyId!);
              await _fetchBatches();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Batch added successfully!')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to add batch: $e')),
              );
            }
          },
        );
      },
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
            "Manufacturing Information",
            style: TextStyle(
              color: Color(0xFFB76DEC),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const CompanyInfoWidget(),
          Expanded(
            child: ManufacturingInfoTable(
              batches: _batches,
              onQRCodeTap: (id) => _launchQRCode(id),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBatchDialog,
        backgroundColor: const Color(0xFF613EEA),
        child: const Icon(Icons.add),
      ),
    );
  }
}
