import 'package:flutter/material.dart';

import '../../../../config/constants.dart';

class AddSectorPage extends StatefulWidget {
  const AddSectorPage({super.key});

  @override
  State<AddSectorPage> createState() => _AddSectorPageState();
}

class _AddSectorPageState extends State<AddSectorPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool responseLoading = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          title: Text(
            'Sector Name',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Container(
            height: 38,
            child: TextFormField(
              controller: nameController,
              enabled: true,
              decoration: const InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffB9B9B9)),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffB9B9B9), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                hintText: '',
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          title: Text(
            'Sector Code',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Container(
            height: 38,
            child: TextFormField(
              controller: codeController,
              enabled: true,
              decoration: const InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffB9B9B9)),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffB9B9B9), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                hintText: '',
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0),
          title: Text(
            'Description',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Container(
            height: 38,
            child: TextFormField(
              controller: descriptionController,
              enabled: true,
              decoration: const InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffB9B9B9)),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffB9B9B9), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                hintText: '',
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        responseLoading
            ? Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: AppConstants.primaryColor,
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: () {
                  // registerSector(nameController.text, codeController.text,
                  //     descriptionController.text);
                },
                child: Center(
                  child: const Text(
                    'Save',
                    style: TextStyle(
                        color: AppConstants.secondaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: AppConstants.primaryColor,
                ),
              ),
      ],
    );
  }
}
