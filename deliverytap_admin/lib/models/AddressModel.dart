import 'package:deliverytap_admin/utils/ModelKeys.dart';

class AddressModel {
  List<AddressResult>? results;
  String? status;

  AddressModel({this.results, this.status});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      results: json[AddressKey.results] != null ? (json[AddressKey.results] as List).map((i) => AddressResult.fromJson(i)).toList() : null,
      status: json[AddressKey.status],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[AddressKey.status] = this.status;
    if (this.results != null) {
      data[AddressKey.results] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddressResult {
  List<AddressComponent>? address_components;
  String? formatted_address;
  Geometry? geometry;
  String? place_id;

  AddressResult({this.address_components, this.formatted_address, this.geometry, this.place_id});

  factory AddressResult.fromJson(Map<String, dynamic> json) {
    return AddressResult(
      address_components: json[AddressResultKey.address_components] != null ? (json[AddressResultKey.address_components] as List).map((i) => AddressComponent.fromJson(i)).toList() : null,
      formatted_address: json[AddressResultKey.formatted_address],
      geometry: json[AddressResultKey.geometry] != null ? Geometry.fromJson(json[AddressResultKey.geometry]) : null,
      place_id: json[AddressResultKey.place_id],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[AddressResultKey.formatted_address] = this.formatted_address;
    data[AddressResultKey.place_id] = this.place_id;
    if (this.address_components != null) {
      data[AddressResultKey.address_components] = this.address_components!.map((v) => v.toJson()).toList();
    }
    if (this.geometry != null) {
      data[AddressResultKey.geometry] = this.geometry!.toJson();
    }
    return data;
  }
}

class AddressComponent {
  String? long_name;
  String? short_name;
  List<String>? types;

  AddressComponent({this.long_name, this.short_name, this.types});

  factory AddressComponent.fromJson(Map<String, dynamic> json) {
    return AddressComponent(
      long_name: json[AddressComponentKey.long_name],
      short_name: json[AddressComponentKey.short_name],
      types: json[AddressComponentKey.types] != null ? List<String>.from(json[AddressComponentKey.types]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[AddressComponentKey.long_name] = this.long_name;
    data[AddressComponentKey.short_name] = this.short_name;
    data[AddressComponentKey.types] = this.types;
    return data;
  }
}

class Geometry {
  Location? location;

  Geometry({this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: json[GeometryKey.location] != null ? Location.fromJson(json[GeometryKey.location]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data[GeometryKey.location] = this.location!.toJson();
    }
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json[LocationKey.lat],
      lng: json[LocationKey.lng],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[LocationKey.lat] = this.lat;
    data[LocationKey.lng] = this.lng;
    return data;
  }
}
