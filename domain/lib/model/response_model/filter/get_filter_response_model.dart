import 'package:core/base_model.dart';

class GetFilterResponseModel implements BaseModel<GetFilterResponseModel> {
  String? status;
  FilterData? data;

  GetFilterResponseModel({this.status, this.data});

  @override
  GetFilterResponseModel fromJson(Map<String, dynamic> json) {
    return GetFilterResponseModel(
      status: json['status'],
      data: json['data'] != null ? FilterData().fromJson(json['data']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.toJson(),
    };
  }
}

class FilterData implements BaseModel<FilterData> {
  FilterSection? period;
  FilterSection? categories;
  FilterSection? cities;

  FilterData({this.period, this.categories, this.cities});

  @override
  FilterData fromJson(Map<String, dynamic> json) {
    return FilterData(
      period: json['Period'] != null ? FilterSection().fromJson(json['Period']) : null,
      categories: json['categories'] != null ? FilterSection().fromJson(json['categories']) : null,
      cities: json['cities'] != null ? FilterSection().fromJson(json['cities']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'Period': period?.toJson(),
      'categories': categories?.toJson(),
      'cities': cities?.toJson(),
    };
  }
}

class FilterSection implements BaseModel<FilterSection> {
  String? name;
  List<FilterItem>? data;

  FilterSection({this.name, this.data});

  @override
  FilterSection fromJson(Map<String, dynamic> json) {
    List<FilterItem>? list;
    if (json['data'] != null) {
      list = [];
      for (var item in json['data']) {
        list.add(FilterItem().fromJson(item));
      }
    }

    return FilterSection(
      name: json['name'],
      data: list,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class FilterItem  implements BaseModel<FilterItem> {
  final int? id;
  final String? name;
  final String? value;

  const FilterItem({this.id, this.name, this.value});

  @override
  FilterItem fromJson(Map<String, dynamic> json) {
    return FilterItem(
      id: json['id'],
      name: json['name'],
      value: json['value'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
    };
  }
}
