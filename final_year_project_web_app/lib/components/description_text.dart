import 'package:flutter/material.dart';

class DescriptionText extends StatelessWidget {
  const DescriptionText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 70.0),
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text:
                  "Welcome to Shelf Life – Your Smart Food Product Management Solution!\n\n",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(
              text:
                  "This application is designed to streamline the management of food products "
                  "for manufacturers and distributors. With an intuitive interface, it allows "
                  "you to efficiently organize inventory, track product details, and generate "
                  "QR codes for seamless consumer access.\n\n\n",
            ),
            TextSpan(
              text: "Key Features:\n\n",
              style: const TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(
              text:
                  "1. Centralized Product Database – Store essential details like product name, "
                  "price, quantity, ingredients, expiration date, and category.\n\n",
            ),
            const TextSpan(
              text:
                  "2. Effortless QR Code Generation – Instantly create and print QR codes for "
                  "each product, ensuring consumers have access to accurate and up-to-date information.\n\n",
            ),
            const TextSpan(
              text:
                  "3. Batch Inventory Updates – Add new stock and keep track of inventory with ease.\n\n",
            ),
            const TextSpan(
              text:
                  "4. Real-Time Data Syncing – Ensure seamless information retrieval across "
                  "connected consumer applications.\n\n",
            ),
            const TextSpan(
              text:
                  "5. User-Friendly Interface – A simple, clean design tailored for quick and "
                  "efficient data entry.\n\n",
            ),
          ],
        ),
      ),
    );
  }
}
