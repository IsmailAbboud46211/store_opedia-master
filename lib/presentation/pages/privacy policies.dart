// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../constant/privacy_policies.dart';

class PrivacyPlicies extends StatelessWidget {
  const PrivacyPlicies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.privacy_and_policies.tr()),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => Text(
                        privacy_policies[index],
                        style: const TextStyle(fontSize: 16.0),
                      ),
                  separatorBuilder: (context, index) =>
                      SizedBox(height: height * 0.02),
                  itemCount: privacy_policies.length),
              SizedBox(height: height * 0.2),
              ElevatedButton(
                  onPressed: () => Navigator.pop(
                        context,
                      ),
                  child: Text(LocaleKeys.ok.tr()))
            ],
          ),
        ),
      ),
    );
  }
}
