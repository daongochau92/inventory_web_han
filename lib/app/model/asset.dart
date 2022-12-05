class Asset {
  int id;
  String stt;
  String location;
  String section;
  String boPhanQuanLy;
  String nguoisudung;
  String nguoisudungNew;
  String maTaiSan;
  String loai;
  String tenTaiSan;
  String loaiTaiSanNew;
  String moTa;
  String ngayNhap;
  String ghichu;
  bool scanned;
  String notfound;
  String ngayscand;
  String noiScand;

  Asset({
    this.id,
    this.stt,
    this.location,
    this.section,
    this.boPhanQuanLy,
    this.nguoisudung,
    this.nguoisudungNew,
    this.maTaiSan,
    this.loai,
    this.tenTaiSan,
    this.loaiTaiSanNew,
    this.moTa,
    this.ngayNhap,
    this.ghichu,
    this.scanned,
    this.notfound,
    this.ngayscand,
    this.noiScand,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'stt': stt,
      'location': location,
      'section': section,
      'boPhanQuanLy': boPhanQuanLy,
      'nguoisudung': nguoisudung,
      'nguoisudungNew': nguoisudungNew,
      'maTaiSan': maTaiSan,
      'loai': loai,
      'tenTaiSan': tenTaiSan,
      'loaiTaiSanNew': loaiTaiSanNew,
      'moTa': moTa,
      'ngayNhap': ngayNhap,
      'ghichu': ghichu,
      'scanned': scanned,
      'notfound': notfound,
      'ngayscand': ngayscand,
      'noiScand': noiScand
    };
    return map;
  }

  Asset.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    stt = map['stt'];
    location = map['location'];
    section = map['section'];
    boPhanQuanLy = map['boPhanQuanLy'];
    nguoisudung = map['nguoisudung'];
    nguoisudungNew = map['nguoisudungNew'];
    maTaiSan = map['maTaiSan'];
    loai = map['loai'];
    tenTaiSan = map['tenTaiSan'];
    loaiTaiSanNew = map['loaiTaiSanNew'];
    moTa = map['moTa'];
    ngayNhap = map['ngayNhap'];
    ghichu = map['ghichu'];
    scanned = map['scanned'];
    notfound = map['notfound'];
    ngayscand = map['ngayscand'];
    noiScand = map['noiScand'];
  }
}
