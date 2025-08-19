import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/company.dart';
import '../services/company_service.dart';

class CompanyInfoWidget extends StatefulWidget {
  const CompanyInfoWidget({Key? key}) : super(key: key);

  @override
  State<CompanyInfoWidget> createState() => _CompanyInfoWidgetState();
}

class _CompanyInfoWidgetState extends State<CompanyInfoWidget> {
  int? _companyId;
  String? _companyName;
  String? _registrationNo;
  final CompanyService _companyService = CompanyService();

  @override
  void initState() {
    super.initState();
    _loadMinimalCompanyInfo();
  }

  Future<void> _loadMinimalCompanyInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _companyId = prefs.getInt('companyId');
      _companyName = prefs.getString('companyName');
      _registrationNo = prefs.getString('registrationNo');
    });
  }

  void _showMoreInfoDialog() async {
    if (_companyId == null) return;
    try {
      Company fullCompany = await _companyService.fetchFullCompanyById(_companyId!);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // Purple border with rounded corners
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(
                color: Color(0xFF613EEA),
                width: 2,
              ),
            ),
            title: const Text(
              'Company Information',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF613EEA),
                decoration: TextDecoration.underline,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _infoRow('Company ID', fullCompany.companyId.toString()),
                  const SizedBox(height: 12),
                  _infoRow('Name', fullCompany.name),
                  const SizedBox(height: 12),
                  _infoRow('Registration No', fullCompany.registrationNo),
                  const SizedBox(height: 12),
                  _infoRow('Type', fullCompany.companyType),
                  const SizedBox(height: 12),
                  _infoRow('Address', fullCompany.hqAddress),
                  const SizedBox(height: 12),
                  _infoRow('Phone Number', fullCompany.phoneNumber),
                  const SizedBox(height: 12),
                  _infoRow('Email', fullCompany.email),
                  const SizedBox(height: 12),
                  _infoRow('Website', fullCompany.website),
                  const SizedBox(height: 12),
                  _infoRow('Certificates', fullCompany.healthSafetyCertificates),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching full details: $e")),
      );
    }
  }

  /// Helper for displaying a label-value pair in the More Info dialog.
  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              // Label is not bold
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB76DEC),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a column for a single piece of minimal info (label + value).
  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB76DEC),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_companyId == null || _companyName == null || _registrationNo == null) {
      return const Text('No minimal company info available');
    }

    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 40),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF613EEA),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row for minimal info: Company ID, Name, Registration No.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoColumn('Company ID', _companyId.toString()),
              _buildInfoColumn('Company Name', _companyName!),
              _buildInfoColumn('Reg. No', _registrationNo!),
            ],
          ),
          const SizedBox(height: 12),
          // "More Information" button, centered.
          Center(
            child: TextButton(
              onPressed: _showMoreInfoDialog,
              child: const Text(
                'More Information',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
