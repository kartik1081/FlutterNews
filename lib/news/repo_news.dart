// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:excel/excel.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mvvm/news/model_news.dart';
import 'package:mvvm_plugin/mvvm_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class NewsRepo {
  Future<List<NewsModel>> fetchData(
      {required String category, required int platform});
  void storeNewsCard({required GlobalKey key, required int platform});
  Future<void> launchURL({required String uri, required int platform});
  void exportData(List<NewsModel> data, int platform);
  Future<bool?> checkNetwork({required int platform});
  void showToast({required String content, required int platform});
  Future<Widget> initializeConfig();
  void payWithUpi(
      {required String upiId,
      required String name,
      required String amount,
      required String cur,
      required String note,
      required int platform});
}

class NewsRepoImpl extends NewsRepo {
  final plugin = MvvmPlugin();
  final remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<List<NewsModel>> fetchData(
      {required String category, required int platform}) async {
    final uri = Uri.parse("https://inshorts.deta.dev/news?category=$category");
    late Response response;
    try {
       await http.get(uri).then((value) {
        if (value.statusCode == 200) {
          response = value;
        }
      });
    } catch (e) {
      showToast(content: "Failed to fetch data", platform: platform);
    }
    List data = jsonDecode(response.body)["data"];
    return data.map((news) => NewsModel.fromJson(news)).toList(growable: true);
  }

  @override
  Future<void> launchURL({required String uri, required int platform}) async {
    try {
      plugin.launchUrl(url: uri);
    } on PlatformException {
      showToast(content: "Not able to access link", platform: platform);
    }
  }

  @override
  void exportData(List<NewsModel> data, int platform) {
    try {
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.xlsx";
      final excel = Excel.createExcel();
      final sheet = excel.sheets[excel.getDefaultSheet() as String];
      if (sheet != null) {
        int column = 0;
        int row = 0;
        int max = 0;
        for (var x in data) {
          column = 0;
          var y = x.toJson();
          if (row == 0) {
            y.forEach((key, value) {
              switch (value.runtimeType) {
                case Null:
                  break;
                case List:
                  sheet
                      .cell(CellIndex.indexByColumnRow(
                          columnIndex: column, rowIndex: row++))
                      .value = key;
                  for (var i in value) {
                    sheet
                        .cell(CellIndex.indexByColumnRow(
                            columnIndex: column, rowIndex: row++))
                        .value = i;
                  }
                  if (row > max) max = row;
                  row = 0;
                  column++;
                  break;
                case String:
                  sheet
                      .cell(CellIndex.indexByColumnRow(
                          columnIndex: column, rowIndex: row++))
                      .value = key;
                  sheet
                      .cell(CellIndex.indexByColumnRow(
                          columnIndex: column, rowIndex: row))
                      .value = value;

                  row = 0;
                  column++;
                  break;

                default:
                  Map<String, dynamic> data = value as Map<String, dynamic>;
                  data.forEach((key, value) {
                    sheet
                        .cell(CellIndex.indexByColumnRow(
                            columnIndex: column, rowIndex: row++))
                        .value = key;

                    if (value.runtimeType == bool) {
                      bool data = value as bool;
                      sheet
                          .cell(CellIndex.indexByColumnRow(
                              columnIndex: column, rowIndex: row))
                          .value = data ? "True" : "False";
                    } else {
                      sheet
                          .cell(CellIndex.indexByColumnRow(
                              columnIndex: column, rowIndex: row))
                          .value = value;
                    }

                    row = 0;
                    column++;
                  });
                  break;
              }
            });
            row = max + 1;
            column = 0;
          } else {
            int a = row;

            y.forEach((key, value) {
              switch (value.runtimeType) {
                case Null:
                  break;
                case List:
                  for (var y in value) {
                    sheet
                        .cell(
                          CellIndex.indexByColumnRow(
                              columnIndex: column, rowIndex: row++),
                        )
                        .value = y;
                  }
                  if (row > max) max = row;
                  row = a;
                  column++;
                  break;
                case String:
                  sheet
                      .cell(CellIndex.indexByColumnRow(
                          columnIndex: column, rowIndex: row++))
                      .value = value;
                  if (row > max) max = row;
                  row = a;
                  column++;
                  break;
                default:
                  Map<String, dynamic> data = value as Map<String, dynamic>;
                  data.forEach((key, value) {
                    if (value.runtimeType == bool) {
                      bool data = value as bool;
                      sheet
                          .cell(CellIndex.indexByColumnRow(
                              columnIndex: column, rowIndex: row))
                          .value = data ? "True" : "False";
                    } else {
                      sheet
                          .cell(CellIndex.indexByColumnRow(
                              columnIndex: column, rowIndex: row))
                          .value = value;
                    }
                    if (row > max) max = row;
                    row = a;
                    column++;
                  });
                  break;
              }
            });
            row = max + 1;
            column = 0;
          }
        }
        excel.save(fileName: fileName);
        _saveExcel(excel, fileName, platform);
      }
    } catch (e) {
      showToast(content: "Export failed", platform: platform);
    }
  }

  @override
  void storeNewsCard(
      {required GlobalKey<State<StatefulWidget>> key,
      required int platform}) async {
    try {
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      Timer(
        const Duration(seconds: 1),
        () => boundary!.toImage(pixelRatio: 1080).then(
              (image) => image.toByteData(format: ImageByteFormat.png).then(
                (byteData) async {
                  final imageBytes = byteData!.buffer.asUint8List();
                  if (imageBytes.isNotEmpty) {
                    final directory = platform == 1
                        ? await getExternalStorageDirectory()
                        : await getApplicationDocumentsDirectory();
                    File('${directory!.path}/${DateTime.now().millisecondsSinceEpoch}.png')
                        .create()
                        .then(
                          (filepath) =>
                              filepath.writeAsBytes(imageBytes).whenComplete(
                                    () => showToast(
                                        content: "Card saved to storage",
                                        platform: platform),
                                  ),
                        );
                  }
                },
              ),
            ),
      );
    } catch (e) {
      showToast(content: "Failed to store news card", platform: platform);
    }
  }

  @override
  void payWithUpi(
      {required String upiId,
      required String name,
      required String amount,
      required String cur,
      required String note,
      required int platform}) {
    try {
      plugin.payWithUpi(
          url: "upi://pay?pa=$upiId&pn=$name&tn=$note&am=$amount&cu=$cur");
    } on PlatformException {
      showToast(
          content: "Filed to open payment application", platform: platform);
    }
  }

  @override
  Future<bool?> checkNetwork({required int platform}) async {
    switch (platform) {
      case 1:
        // Web
        return true;
      case 2:
        // Android
        try {
          return plugin.checkNetwork().then(
            (checkNet) {
              if (checkNet != null) {
                if (checkNet) {
                  showToast(
                      content: "Connection is available", platform: platform);
                } else {
                  showToast(
                      content: "Connection is not available",
                      platform: platform);
                }
              }
              plugin.telephoneDetail();
              return checkNet;
            },
          );
        } on PlatformException {
          return false;
        }
      case 3:
        // IOS
        return true;
      case 4:
        // Windows
        return true;
      default:
        return false;
    }
  }

  @override
  void showToast({required String content, required int platform}) {
    switch (platform) {
      case 1:
        // Web
        break;
      case 2:
        // Android
        try {
          plugin.showToast(content: content);
        } on PlatformException {}
        break;
      case 3:
        //IOS
        break;
      case 4:
        // Windows
        break;
    }
  }

  @override
  Future<Widget> initializeConfig() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 1),
        minimumFetchInterval: const Duration(seconds: 1),
      ),
    );
    return await remoteConfig.fetchAndActivate().then(
          (value) => _metaDataToWidget(
            metaData: remoteConfig.getString("banner"),
          ),
        );
  }

  _metaDataToWidget({required String metaData}) {
    Map<String, dynamic> data = jsonDecode(metaData);
    return Text(
      data["country"],
      style: GoogleFonts.ptSerif(fontSize: 20.0),
    );
  }

  _directoryPath({required int platform}) async {
    String directory = "";
    platform == 1
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory()
            .then((value) => directory = value.path);
    return directory;
  }

  _saveExcel(Excel excel, String fileName, int platform) async {
    try {
      //request for storage permission
      var res = await Permission.storage.request();
      // print("Manage: ${res2.}");
      //"/storage/emulated/0/Download/"  download folder address
      //excel2.xlsx is the file name "feel free to change the file name to anything you want"
      String directory = _directoryPath(platform: platform);
      // File file = File(("/storage/emulated/0/MVVM/$fileName"));
      File file = File(("$directory/$fileName"));
      if (res.isGranted) {
        file.exists().then((value) {
          if (!value) {
            file
              ..createSync(recursive: true)
              ..writeAsBytesSync(excel.encode()!);
            showToast(content: "Export successfully", platform: platform);
          } else {
            showToast(content: "Same file already exist", platform: platform);
          }
        });
      } else {
        showToast(content: "Permission denied", platform: platform);
      }
    } catch (e) {
      showToast(content: "Export failed", platform: platform);
    }
  }
}
