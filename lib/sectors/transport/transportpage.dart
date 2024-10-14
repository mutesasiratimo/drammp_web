import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';

class TransportPage extends StatefulWidget {
  const TransportPage({super.key});

  @override
  State<TransportPage> createState() => _TransportPageState();
}

class _TransportPageState extends State<TransportPage> {
  @override
  Widget build(BuildContext context) {
    return BootstrapContainer(children: <BootstrapRow>[
      BootstrapRow(
        children: <BootstrapCol>[
          BootstrapCol(
            sizes: 'col-lg-12 col-md-12 col-sm-12',
            child: const Text(
              textAlign: TextAlign.start,
              "Transport Page",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}
