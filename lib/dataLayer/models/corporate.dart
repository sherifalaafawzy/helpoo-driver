
class Corporate {
  int? id;
  String? en_name;
  String? ar_name;
  int? discount_ratio;
  bool? deferredPayment;
  bool? cash;
  bool? cardToDriver;
  bool? online;



  Corporate.fromJson(Map json) {
    id = json['id'];
    en_name = json['en_name'];
    ar_name = json['ar_name'];
    discount_ratio = json['discount_ratio'];
    deferredPayment = json['deferredPayment'];
    cash = json['cash'];
    cardToDriver = json['cardToDriver'];
    online = json['online'];
  }

}
