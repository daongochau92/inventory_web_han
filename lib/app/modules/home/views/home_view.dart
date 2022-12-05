import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:inventory_web/app/model/asset.dart';
import 'package:inventory_web/app/util/LoadingDialog.dart';
import 'package:inventory_web/app/util/util.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    // List<String> listMenu = [
    //   'Upload file excel',
    //   'Export Data',
    // ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory for HAN'),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              Center(
                child: Container(
                  height: 30,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Obx(
                    () => controller.totalItem.value != 0
                        ? Center(
                            // child: Text('${controller.totalItem.value}'),
                            child: Text(
                                'fb${controller.countTotal.value} - ${controller.totalItem.value}'),
                          )
                        : Container(),
                  ),
                ),
              ),
            ],
          ),
          // PopupMenuButton<String>(
          //   child: Icon(
          //     Icons.more_vert,
          //   ),
          //   onSelected: (value) async {
          //     switch (value) {
          //       case 'Upload CCDC+TSCĐ':
          //         // showDialogUploadFileExcel(context);
          //         handleReadExcel(context);
          //         break;
          //       case 'Upload Location+Department':
          //         // showDialogUploadFileExcel(context);
          //         handleReadExcelLocationDepartment(context);
          //         break;
          //       case 'Export Data':
          //         createExcel(context);
          //         break;

          //       default:
          //     }
          //   },
          //   itemBuilder: (context) => listMenu
          //       .map(
          //         (choice) => PopupMenuItem<String>(
          //           value: choice,
          //           child: Text(choice),
          //         ),
          //       )
          //       .toList(),
          // ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Text('Bộ phận quản lý: '),
                  FutureBuilder<List<String>>(
                    future: controller.getListBoPhan(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<String> list = [];
                        list = snapshot.data;
                        if (list.isNotEmpty) {
                          controller.boPhanvalue.value = list[0];
                        } else {
                          return Text('Không có dữ liệu');
                        }
                        return Obx(
                          () => DropdownButton(
                            value: controller.boPhanvalue.value,
                            items: list
                                .map(
                                  (strBophan) => DropdownMenuItem(
                                    value: strBophan,
                                    child: Text(
                                      strBophan,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              controller.boPhanvalue.value = value;
                              // controller.getDataByBophan(value);
                            },
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    onPressed: () {
                      handleReadExcel(context);
                    },
                    child: Text('Upload CCDC+TSCĐ',
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    onPressed: () {
                      handleReadExcelLocationDepartment(context);
                    },
                    child: Text('Upload Location + Department + Kind',
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                    onPressed: () {
                      createExcel(context);
                    },
                    child: Text(
                      'Export Kế Toán',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                    onPressed: () {
                      createExcelBase(context);
                    },
                    child: Text(
                      'Export Base',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              // Obx(
              //   () => Container(
              //     height: 800,
              //     child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              //       future: controller.futureGetByBoPhan.value,
              //       builder: (context, snapshot) {
              //         if (snapshot.connectionState == ConnectionState.waiting) {
              //           return Center(child: CircularProgressIndicator());
              //         } else if (snapshot.hasData) {
              //           snapshot.data.docs.forEach((element) {
              //             if (element.exists) {
              //               controller.list.add(Asset.fromMap(element.data()));
              //             }
              //           });
              //           print(controller.rowsOffset.value);
              //           print(controller.rowsPerPage.value);
              //           return NativeDataTable.builder(
              //             firstRowIndex: controller.rowsOffset.value,
              //             rowsPerPage: controller.rowsPerPage.value,
              //             columns: [
              //               DataColumn(label: Text('Bo phan')),
              //               DataColumn(label: Text('Ma san pham'))
              //             ],
              //             totalItems: 50,
              //             itemCount: controller.list.length ?? 0,
              //             itemBuilder: (index) => DataRow(
              //               cells: [
              //                 DataCell(Text(controller.list[index].boPhanQuanLy)),
              //                 DataCell(Text(controller.list[index].maTaiSan)),
              //               ],
              //             ),
              //             handleNext: () {
              //               print(controller.rowsOffset.value);
              //               controller.rowsOffset.value +=
              //                   controller.rowsPerPage.value;
              //               controller.list.value += [
              //                 Asset(boPhanQuanLy: 'hhee', maTaiSan: 'hihi')
              //               ];
              //               print(controller.rowsOffset.value);
              //             },
              //             handlePrevious: () {
              //               controller.rowsOffset.value -=
              //                   controller.rowsPerPage.value;
              //             },
              //             onRowsPerPageChanged: (int value) {
              //               controller.rowsPerPage.value = value;
              //               print("New Rows: $value");
              //             },
              //           );
              //         }
              //         if (snapshot.hasError) {}
              //         return Center(child: CircularProgressIndicator());
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  createExcel(BuildContext context) async {
    LoadingDialog.showLoadingDialog(context, 'Please wait');
    List<Asset> list =
        await controller.getAllAsset(controller.boPhanvalue.value);
    await createExcelFile(list);
    LoadingDialog.hideLoadingDialog(context);
  }

  createExcelBase(BuildContext context) async {
    LoadingDialog.showLoadingDialog(context, 'Please wait');
    List<Asset> list =
        await controller.getAllAsset(controller.boPhanvalue.value);
    await createExcelFileBase(list);
    LoadingDialog.hideLoadingDialog(context);
  }

  handleReadExcel(BuildContext context) async {
    LoadingDialog.showLoadingDialog(context, "waiting");
    Uint8List uint8list = await getDir();
    if (uint8list != null) {
      controller.totalItem.value = readFileExcel(uint8list);
    }
    // await controller.getCountTotal();
    LoadingDialog.hideLoadingDialog(context);
    successSnackbar('Upload thành công');
  }

  handleReadExcelLocationDepartment(BuildContext context) async {
    LoadingDialog.showLoadingDialog(context, "waiting");
    Uint8List uint8list = await getDir();
    if (uint8list != null) {
      readLocationDepartment(uint8list);
    }
    LoadingDialog.hideLoadingDialog(context);
    successSnackbar('Upload thành công');
  }
}
