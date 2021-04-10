class Asset {
  // 資産
  String asset;
  // 付属品
  List<String> accessorise;
  // 管理番号
  String control;
  // 管理期限
  DateTime? deadline;
  // 識別番号
  String identification;
  // QR番号
  String qr;
  // 管理状態
  int status;
  // アラーム
  DateTime? aram;
  // 使用者
  String user;
  // 管理者
  String owner;
  // 管理者部署
  String ownerGroup;
  Asset(
      this.asset,
      this.accessorise,
      this.control,
      this.deadline,
      this.identification,
      this.qr,
      this.status,
      this.aram,
      this.user,
      this.owner,
      this.ownerGroup);
}
