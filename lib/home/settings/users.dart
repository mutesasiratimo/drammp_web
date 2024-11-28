import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BootstrapRow(
        children: <BootstrapCol>[
          BootstrapCol(
            sizes: "col-lg-8 col-md-12 col-sm-12",
            child: SizedBox(
              height: size.height * .8,
              child: Container(
                padding: EdgeInsets.all(24.0),
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Column(children: [
                  SizedBox(height: 8.0),
                ]),
              ),
            ),
          ),
          BootstrapCol(
            sizes: "col-lg-4 col-md-12 col-sm-12",
            child: Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
