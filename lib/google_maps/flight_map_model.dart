import 'package:google_maps_flutter/google_maps_flutter.dart';

class FlightMap {
  String country;
  Detail detail;
  double lat;
  double long;

  FlightMap({this.country, this.detail, this.lat, this.long});

  FlightMap.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    detail = json['detail'] != null ? Detail.fromJson(json['detail']) : null;
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['country'] = country;
    if (detail != null) {
      data['detail'] = detail.toJson();
    }
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}

class Detail {
  String description;
  String name;
  String photoUrl;
  String status;
  List<Tags> tags;

  Detail({this.description, this.name, this.photoUrl, this.status, this.tags});

  Detail.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    name = json['name'];
    photoUrl = json['photoUrl'];
    status = json['status'];
    if (json['tags'] != null) {
      tags = List<Tags>();
      json['tags'].forEach((v) {
        tags.add(Tags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['description'] = description;
    data['name'] = name;
    data['photoUrl'] = photoUrl;
    data['status'] = status;
    if (tags != null) {
      data['tags'] = tags.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tags {
  int id;
  String name;

  Tags({this.id, this.name});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

extension FlightLatLong on FlightMap {
  LatLng get latlong => LatLng(lat, long);
}
