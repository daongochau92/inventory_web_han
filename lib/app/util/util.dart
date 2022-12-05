import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventory_web/app/model/asset.dart';

int readFileExcel(Uint8List uint8list) {
  Excel excel = Excel.decodeBytes(uint8list);
  Map<String, Sheet> table = excel.tables;

  CollectionReference collectionAsset =
      FirebaseFirestore.instance.collection('asset');
  List<Asset> listUpload = [];
  int index = 1;
  //CCDC
  Sheet sheet = table["CCDC"];
  for (int row = 3; row < sheet.maxRows; row++) {
    List<Data> dataRow = sheet.row(row);
    if (getCellValue(dataRow[4]) == '') {
      continue;
    }
    var asset = Asset(
      stt: "${index++}",
      boPhanQuanLy: getCellValue(dataRow[1]),
      // boPhanQuanLy: '',
      nguoisudung: getCellValue(dataRow[2]),
      maTaiSan: getCellValue(dataRow[4]),
      tenTaiSan: getCellValue(dataRow[5]),
      moTa: getCellValue(dataRow[6]),
      ngayNhap: getCellValue(dataRow[8]),
      ghichu: getCellValue(dataRow[10]),
      // location: getCellValue(dataRow[1]),
      location: '',
      section: getCellValue(dataRow[2]),
      loai: 'CCDC',
      scanned: false,
      notfound: '',
      ngayscand: '',
      noiScand: '',
    );
    listUpload.add(asset);
    // collectionAsset.add(asset.toMap()).catchError((error) {
    //   print(error.toString());
    // });
  }
  //TSCD
  index = 1;
  Sheet sheet2 = table["TSCĐ"];
  for (int row = 4; row < sheet2.maxRows; row++) {
    List<Data> dataRow = sheet2.row(row);
    if (getCellValue(dataRow[2]) == '') {
      continue;
    }
    var asset = Asset(
      stt: "${index++}",
      boPhanQuanLy: getCellValue(dataRow[1]),
      // boPhanQuanLy: '',
      nguoisudung: '',
      maTaiSan: getCellValue(dataRow[2]),
      tenTaiSan: getCellValue(dataRow[3]),
      moTa: getCellValue(dataRow[4]),
      ngayNhap: getCellValue(dataRow[5]),
      ghichu: '',
      // location: getCellValue(dataRow[1]),
      location: '',
      section: '',
      loai: 'TSCĐ',
      scanned: false,
      notfound: '',
      ngayscand: '',
      noiScand: '',
    );
    // collectionAsset.add(asset.toMap()).catchError((error) {
    //   print(error.toString());
    // });
    listUpload.add(asset);
  }

  for (int i = 0; i < listUpload.length; i++) {
    collectionAsset.add(listUpload[i].toMap()).catchError((error) {
      print(error.toString());
    });
  }
  return listUpload.length;
  // List<String> results = [];
  // results =
  //     listUpload.map<String>((e) => e.boPhanQuanLy).toList().toSet().toList();
  // CollectionReference collectionLocation =
  //     FirebaseFirestore.instance.collection('location');
  // for (int i = 0; i < results.length; i++) {
  //   collectionLocation.add({'location': results[i]}).catchError((error) {
  //     print(error.toString());
  //   });
  // }
}

readLocationDepartment(Uint8List uint8list) {
  Excel excel = Excel.decodeBytes(uint8list);
  Map<String, Sheet> table = excel.tables;

  addLocationDepartmentToFirebase(
    collectionName: 'location',
    sheetName: 'Location',
    table: table,
  );
  addLocationDepartmentToFirebase(
    collectionName: 'department',
    sheetName: 'Department',
    table: table,
  );
  addLocationDepartmentToFirebase(
    collectionName: 'kind',
    sheetName: 'Kind',
    table: table,
  );
}

addLocationDepartmentToFirebase(
    {String collectionName, String sheetName, Map<String, Sheet> table}) {
  CollectionReference collectionLocationHCM =
      FirebaseFirestore.instance.collection(collectionName);
  List<String> listUpload = [];

  Sheet sheet = table[sheetName];
  for (int row = 1; row < sheet.maxRows; row++) {
    List<Data> dataRow = sheet.row(row);
    if (getCellValue(dataRow[1]) == '') {
      continue;
    }
    listUpload.add(getCellValue(dataRow[1]));
  }
  for (int i = 0; i < listUpload.length; i++) {
    collectionLocationHCM
        .add({collectionName: listUpload[i]}).catchError((onError) {
      print(onError.toString());
    });
  }
}

String getCellValue(Data data) {
  try {
    if (data.value.toString() == 'null') {
      return '';
    }
    return data.value.toString().trim();
  } catch (e) {
    return '';
  }
}

Future<Uint8List> getDir() async {
  FilePickerResult result = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

  if (result != null) {
    Uint8List uploadfile = result.files.single.bytes;

    return uploadfile;
  } else {
    // User canceled the picker
  }
  return null;
}

void successSnackbar(String msg) {
  return Get.snackbar('$msg', "Success !",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green[400],
      colorText: Colors.white);
}

void errorSnackbar(String msg) {
  return Get.snackbar('$msg', "Error !",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[400],
      colorText: Colors.white);
}

Future createExcelFile(List<Asset> dataSource) async {
  try {
    ByteData data = await rootBundle.load("assets/file.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = await compute(_decodeButyes, bytes);

    Future.wait([handleData(excel, dataSource)]).then((value) async {
      List<int> bytes = value[0];
      final content = base64Encode(bytes);
      AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,$content")
        ..setAttribute("download", "output.xlsx")
        ..click();
    }).catchError((e) {
      return Future.error(e);
    });
  } catch (e) {
    return Future.error(e);
  }
}

Future createExcelFileBase(List<Asset> dataSource) async {
  try {
    ByteData data = await rootBundle.load("assets/base.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = await compute(_decodeButyes, bytes);

    Future.wait([handleDataBase(excel, dataSource)]).then((value) async {
      List<int> bytes = value[0];
      final content = base64Encode(bytes);
      AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,$content")
        ..setAttribute("download", "output.xlsx")
        ..click();
    }).catchError((e) {
      return Future.error(e);
    });
  } catch (e) {
    return Future.error(e);
  }
}

Excel _decodeButyes(var bytes) {
  return Excel.decodeBytes(bytes);
}

Future<List<int>> handleDataBase(Excel excel, List<Asset> dataSource) async {
  dataSource.sort((a, b) => a.ngayscand.compareTo(b.ngayscand));

  Sheet sheetCcDc = excel['Exported'];

  _fetchDataBase(dataSource, sheetCcDc);

  var value = await excel.encode();

  return value;
}

Future<List<int>> handleData(Excel excel, List<Asset> dataSource) async {
  List<Asset> listFixed =
      dataSource.where((element) => element.loai == 'TSCĐ').toList();
  List<Asset> listEquipment =
      dataSource.where((element) => element.loai == 'CCDC').toList();
  listFixed.sort((a, b) => a.ngayscand.compareTo(b.ngayscand));
  listEquipment.sort((a, b) => a.ngayscand.compareTo(b.ngayscand));

  Sheet sheetCcDc = excel['CCDC'];
  Sheet sheetTsCd = excel['TSCĐ'];

  _fetchData(listFixed, sheetTsCd);
  _fetchData(listEquipment, sheetCcDc);

  var value = await excel.encode();

  return value;
}

void _fetchData(List<Asset> lstData, Sheet sheet) {
  CellStyle cellStyle0 = CellStyle(
      bold: false,
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      textWrapping: TextWrapping.WrapText);
  CellStyle cellStyle1 = CellStyle(horizontalAlign: HorizontalAlign.Center);
  CellStyle cellStyle2 = CellStyle(
    bold: false,
    horizontalAlign: HorizontalAlign.Center,
  );
  int index = 13;
  int no = 1;

  sheet.cell(CellIndex.indexByString('A4'))
    ..value =
        '- Thời điểm kiểm kê: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}';

  sheet.merge(CellIndex.indexByString('I1'), CellIndex.indexByString('K1'),
      customValue: "Mẫu số 05 - VT");
  sheet.merge(CellIndex.indexByString('I2'), CellIndex.indexByString('K3'),
      customValue:
          '(Ban hành theo Thông tư số 200/2014/TT-BTC \n Ngày 22/12/2014 của Bộ Tài chính)');
  sheet.cell(CellIndex.indexByString('I1')).cellStyle = cellStyle0;
  sheet.cell(CellIndex.indexByString('I2')).cellStyle = cellStyle0;

  for (var i = 0; i < lstData.length; i++) {
    sheet.cell(CellIndex.indexByString('A$index'))..value = no++;
    sheet.cell(CellIndex.indexByString('B$index'))..value = lstData[i].location;
    sheet.cell(CellIndex.indexByString('C$index'))..value = lstData[i].noiScand;
    sheet.cell(CellIndex.indexByString('D$index'))
      ..value = lstData[i].nguoisudungNew;
    sheet.cell(CellIndex.indexByString('E$index'))..value = lstData[i].maTaiSan;
    sheet.cell(CellIndex.indexByString('F$index'))..value = lstData[i].loai;
    sheet.cell(CellIndex.indexByString('G$index'))
      ..value = lstData[i].tenTaiSan;
    sheet.cell(CellIndex.indexByString('H$index'))..value = lstData[i].moTa;
    sheet.cell(CellIndex.indexByString('I$index'))..value = lstData[i].ngayNhap;
    sheet.cell(CellIndex.indexByString('J$index'))..value = lstData[i].ghichu;
    sheet.cell(CellIndex.indexByString('K$index'))
      ..value = lstData[i].ngayscand;
    sheet.cell(CellIndex.indexByString('L$index'))
      ..value = lstData[i].boPhanQuanLy;
    sheet.cell(CellIndex.indexByString('M$index'))
      ..value = lstData[i].nguoisudung;
    index++;

    if (i == lstData.length - 1) {
      index += 4;
      sheet.merge(CellIndex.indexByString('A$index'),
          CellIndex.indexByString('G$index'),
          customValue: "Tổ kiểm kê");
      sheet.cell(CellIndex.indexByString('A$index')).cellStyle = cellStyle1;

      sheet.cell(CellIndex.indexByString('I$index'))..value = "Ban giám đốc";
      sheet.cell(CellIndex.indexByString('I$index')).cellStyle = cellStyle1;

      index += 6;
      sheet.merge(CellIndex.indexByString('A$index'),
          CellIndex.indexByString('G$index'),
          customValue:
              'Trần Thanh Tùng                 Nguyễn Quang Quý                 Nguyễn Hòa Trung Dũng                Nguyễn Thị Trang                Đặng Thị Như Nguyệt');

      sheet.cell(CellIndex.indexByString('I$index'))..value = "Tôn Thất Hưng";
      sheet.cell(CellIndex.indexByString('A$index')).cellStyle = cellStyle2;
      sheet.cell(CellIndex.indexByString('I$index')).cellStyle = cellStyle2;
    }
  }
}

void _fetchDataBase(List<Asset> lstData, Sheet sheet) {
  int index = 2;

  for (var i = 0; i < lstData.length; i++) {
    sheet.cell(CellIndex.indexByString('A$index'))
      ..value = lstData[i].tenTaiSan;
    sheet.cell(CellIndex.indexByString('B$index'))..value = lstData[i].maTaiSan;
    // sheet.cell(CellIndex.indexByString('C$index'))
    //   ..value = lstData[i].boPhanQuanLy;
    sheet.cell(CellIndex.indexByString('D$index'))..value = lstData[i].noiScand;
    sheet.cell(CellIndex.indexByString('E$index'))
      ..value = lstData[i].loaiTaiSanNew;
    sheet.cell(CellIndex.indexByString('F$index'))
      ..value = lstData[i].nguoisudungNew;
    // sheet.cell(CellIndex.indexByString('G$index'))
    //   ..value = lstData[i].tenTaiSan;
    // sheet.cell(CellIndex.indexByString('H$index'))..value = lstData[i].moTa;
    sheet.cell(CellIndex.indexByString('I$index'))..value = lstData[i].ngayNhap;
    // sheet.cell(CellIndex.indexByString('J$index'))..value = lstData[i].ghichu;
    sheet.cell(CellIndex.indexByString('K$index'))..value = "In Use";
    sheet.cell(CellIndex.indexByString('L$index'))..value = lstData[i].moTa;
    sheet.cell(CellIndex.indexByString('M$index'))
      ..value = lstData[i].boPhanQuanLy;
    sheet.cell(CellIndex.indexByString('N$index'))
      ..value = lstData[i].nguoisudung;
    sheet.cell(CellIndex.indexByString('O$index'))..value = lstData[i].ghichu;
    sheet.cell(CellIndex.indexByString('P$index'))..value = lstData[i].location;
    sheet.cell(CellIndex.indexByString('Q$index'))
      ..value = lstData[i].ngayscand;
    index++;
  }
}
