import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_web/app/model/asset.dart';

class HomeController extends GetxController {
  var boPhanvalue = 'All'.obs;
  var futureGetByBoPhan =
      FirebaseFirestore.instance.collection('asset').limit(1).get().obs;
  RxInt rowsOffset = 0.obs;
  RxInt rowsPerPage = PaginatedDataTable.defaultRowsPerPage.obs;
  RxList<Asset> list = <Asset>[].obs;
  RxInt totalItem = 0.obs;
  RxString countTotal = ''.obs;
  @override
  void onInit() {
    super.onInit();
    // getDataByBophan(boPhanvalue.value);
  }

  @override
  void onReady() {
    super.onReady();
    // getCountTotal();
  }

  @override
  void onClose() {}

  Stream<QuerySnapshot> getData() {
    return FirebaseFirestore.instance
        .collection('asset')
        .limit(100)
        .snapshots();
  }

  getDataByBophan(String bophan) {
    if (bophan.trim() == 'All') {
      futureGetByBoPhan.value =
          FirebaseFirestore.instance.collection('asset').limit(10).get();
    } else {
      futureGetByBoPhan.value = FirebaseFirestore.instance
          .collection('asset')
          .where('location', isEqualTo: bophan)
          .limit(10)
          .get();
    }
    update();
  }

  Future<List<String>> getListBoPhan() async {
    List<String> list = snapshortToListAsset(
        await FirebaseFirestore.instance.collection('location').get());
    return list;
  }

  List<String> snapshortToListAsset(
      QuerySnapshot<Map<String, dynamic>> snapshort) {
    List<String> list = ['All'];
    snapshort.docs.forEach((element) {
      if (element.exists) {
        list.add(element['location']);
      }
    });
    return list;
  }

  Future<List<Asset>> getAllAsset(String bophan) async {
    QuerySnapshot snapshot = bophan == 'All'
        ? await FirebaseFirestore.instance
            .collection('asset')
            .where('scanned', isEqualTo: true)
            .get()
        : await FirebaseFirestore.instance
            .collection('asset')
            .where('scanned', isEqualTo: true)
            .where('location', isEqualTo: bophan)
            .get();
    List<Asset> list = [];
    if (snapshot.docs.isNotEmpty) {
      snapshot.docs.forEach((element) {
        if (element.exists) {
          list.add(Asset.fromMap(element.data()));
        }
      });
    }
    return list;
  }

  Future<dynamic> getAllAssetCount() async {
    QuerySnapshot<Map<String, dynamic>> snapshotCount = await FirebaseFirestore
        .instance
        .collection('asset')
        .get()
        .catchError((error) {
      print(error);
      return null;
    });

    return '${snapshotCount.docs.length}';
  }

  getCountTotal() async {
    dynamic data = await getAllAssetCount();
    if (data != null) {
      countTotal.value = '$data';
    }
  }
}
