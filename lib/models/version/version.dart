import 'package:flutter/material.dart';

class VersionModel {
  int? appCode;
  String? appName;
  String? deprecatedVersion;
  String? minimumVersion;
  String? newestVersion;
  int? updateCountdown;
  String? downloadLink;
  String? message;
  String? lastAssetUpdate;

  VersionModel({
    this.appCode,
    this.appName,
    this.deprecatedVersion,
    this.minimumVersion,
    this.newestVersion,
    this.updateCountdown,
    this.downloadLink,
    this.message,
    this.lastAssetUpdate,
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) => VersionModel(
        appCode: json['app_code'] as int?,
        appName: json['app_name'] as String?,
        deprecatedVersion: json['deprecated_version'] as String?,
        minimumVersion: json['minimum_version'] as String?,
        newestVersion: json['newest_version'] as String?,
        updateCountdown: json['update_countdown'] as int?,
        downloadLink: json['download_link'] as String?,
        message: json['message'] as String?,
        lastAssetUpdate: json['last_asset_update'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'app_code': appCode,
        'app_name': appName,
        'deprecated_version': deprecatedVersion,
        'minimum_version': minimumVersion,
        'newest_version': newestVersion,
        'update_countdown': updateCountdown,
        'download_link': downloadLink,
        'message': message,
        'last_asset_update': lastAssetUpdate,
      };
}

class SystemDev extends StatelessWidget {
  const SystemDev({super.key});

  static void performance(BuildContext c) {
    Navigator.push(c, MaterialPageRoute(builder: (c) => const SystemDev()));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 14, color: Colors.white),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                  'full-stack developed\nby Umar Izzuddin\nideeynstudio@gmail.com',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text(
                  "please don't delete this credit. if you willing to remove it you can contact me as developer. i can even do more custom on request.",
                  textAlign: TextAlign.justify)
            ]),
          ),
        ),
      ),
    );
  }
}
