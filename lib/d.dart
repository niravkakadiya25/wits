/// recipePhoto : "we"
/// steps : [{"imageurl":"imageurl","description":"description","title":"title","shareUrl":"shareUrl","nid":"nid"}]

class D {
  D({
      String? recipePhoto, 
      List<Steps>? steps,}){
    _recipePhoto = recipePhoto;
    _steps = steps;
}

  D.fromJson(dynamic json) {
    _recipePhoto = json['recipePhoto'];
    if (json['steps'] != null) {
      _steps = [];
      json['steps'].forEach((v) {
        _steps?.add(Steps.fromJson(v));
      });
    }
  }
  String? _recipePhoto;
  List<Steps>? _steps;

  String? get recipePhoto => _recipePhoto;
  List<Steps>? get steps => _steps;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['recipePhoto'] = _recipePhoto;
    if (_steps != null) {
      map['steps'] = _steps?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// imageurl : "imageurl"
/// description : "description"
/// title : "title"
/// shareUrl : "shareUrl"
/// nid : "nid"

class Steps {
  Steps({
      String? imageurl, 
      String? description, 
      String? title, 
      String? shareUrl, 
      String? nid,}){
    _imageurl = imageurl;
    _description = description;
    _title = title;
    _shareUrl = shareUrl;
    _nid = nid;
}

  Steps.fromJson(dynamic json) {
    _imageurl = json['imageurl'];
    _description = json['description'];
    _title = json['title'];
    _shareUrl = json['shareUrl'];
    _nid = json['nid'];
  }
  String? _imageurl;
  String? _description;
  String? _title;
  String? _shareUrl;
  String? _nid;

  String? get imageurl => _imageurl;
  String? get description => _description;
  String? get title => _title;
  String? get shareUrl => _shareUrl;
  String? get nid => _nid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imageurl'] = _imageurl;
    map['description'] = _description;
    map['title'] = _title;
    map['shareUrl'] = _shareUrl;
    map['nid'] = _nid;
    return map;
  }

}