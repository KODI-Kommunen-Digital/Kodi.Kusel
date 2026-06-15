import 'package:core/base_model.dart';

class WeatherResponseModel implements BaseModel<WeatherResponseModel> {
  WeatherLocationModel? location;
  WeatherCurrentModel? current;
  WeatherForecastDetailsModel? forecast;

  WeatherResponseModel({this.location, this.current, this.forecast});

  @override
  WeatherResponseModel fromJson(Map<String, dynamic> json) {
    return WeatherResponseModel(
      location: json['location'] != null ? WeatherLocationModel().fromJson(json['location']) : null,
      current: json['current'] != null ? WeatherCurrentModel().fromJson(json['current']) : null,
      forecast: json['forecast'] != null ? WeatherForecastDetailsModel().fromJson(json['forecast']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'location': location?.toJson(),
    'current': current?.toJson(),
    'forecast': forecast?.toJson(),
  };
}

class WeatherLocationModel implements BaseModel<WeatherLocationModel> {
  String? name;
  String? region;
  String? country;
  double? lat;
  double? lon;
  String? tzId;
  int? localtimeEpoch;
  String? localtime;

  WeatherLocationModel({
    this.name,
    this.region,
    this.country,
    this.lat,
    this.lon,
    this.tzId,
    this.localtimeEpoch,
    this.localtime,
  });

  @override
  WeatherLocationModel fromJson(Map<String, dynamic> json) {
    return WeatherLocationModel(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      tzId: json['tz_id'],
      localtimeEpoch: json['localtime_epoch'],
      localtime: json['localtime'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'region': region,
    'country': country,
    'lat': lat,
    'lon': lon,
    'tz_id': tzId,
    'localtime_epoch': localtimeEpoch,
    'localtime': localtime,
  };
}

class WeatherCurrentModel implements BaseModel<WeatherCurrentModel> {
  double? tempC;
  double? tempF;
  bool? isDay;
  WeatherConditionModel? condition;

  WeatherCurrentModel({this.tempC, this.tempF, this.isDay, this.condition});

  @override
  WeatherCurrentModel fromJson(Map<String, dynamic> json) {
    return WeatherCurrentModel(
      tempC: (json['temp_c'] as num?)?.toDouble(),
      tempF: (json['temp_f'] as num?)?.toDouble(),
      isDay: json['is_day'] == 1,
      condition: json['condition'] != null ? WeatherConditionModel().fromJson(json['condition']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'temp_c': tempC,
    'temp_f': tempF,
    'is_day': isDay == true ? 1 : 0,
    'condition': condition?.toJson(),
  };
}

class WeatherConditionModel implements BaseModel<WeatherConditionModel> {
  String? text;
  String? icon;
  int? code;

  WeatherConditionModel({this.text, this.icon, this.code});

  @override
  WeatherConditionModel fromJson(Map<String, dynamic> json) {
    return WeatherConditionModel(
      text: json['text'],
      icon: json['icon'],
      code: json['code'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'text': text,
    'icon': icon,
    'code': code,
  };
}

class WeatherForecastDetailsModel implements BaseModel<WeatherForecastDetailsModel> {
  List<WeatherForecastDayModel>? forecastday;

  WeatherForecastDetailsModel({this.forecastday});

  @override
  WeatherForecastDetailsModel fromJson(Map<String, dynamic> json) {
    return WeatherForecastDetailsModel(
      forecastday: (json['forecastday'] as List<dynamic>?)
          ?.map((e) => WeatherForecastDayModel().fromJson(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'forecastday': forecastday?.map((e) => e.toJson()).toList(),
  };
}

class WeatherForecastDayModel implements BaseModel<WeatherForecastDayModel> {
  String? date;
  int? dateEpoch;
  WeatherDayModel? day;

  WeatherForecastDayModel({this.date, this.dateEpoch, this.day});

  @override
  WeatherForecastDayModel fromJson(Map<String, dynamic> json) {
    return WeatherForecastDayModel(
      date: json['date'],
      dateEpoch: json['date_epoch'],
      day: json['day'] != null ? WeatherDayModel().fromJson(json['day']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'date': date,
    'date_epoch': dateEpoch,
    'day': day?.toJson(),
  };
}

class WeatherDayModel implements BaseModel<WeatherDayModel> {
  double? maxtempC;
  double? mintempC;
  double? avgtempC;
  double? maxwindKph;
  double? totalprecipMm;
  double? avgvisKm;
  double? avghumidity;
  WeatherConditionModel? condition;

  WeatherDayModel({
    this.maxtempC,
    this.mintempC,
    this.avgtempC,
    this.maxwindKph,
    this.totalprecipMm,
    this.avgvisKm,
    this.avghumidity,
    this.condition,
  });

  @override
  WeatherDayModel fromJson(Map<String, dynamic> json) {
    return WeatherDayModel(
      maxtempC: (json['maxtemp_c'] as num?)?.toDouble(),
      mintempC: (json['mintemp_c'] as num?)?.toDouble(),
      avgtempC: (json['avgtemp_c'] as num?)?.toDouble(),
      maxwindKph: (json['maxwind_kph'] as num?)?.toDouble(),
      totalprecipMm: (json['totalprecip_mm'] as num?)?.toDouble(),
      avgvisKm: (json['avgvis_km'] as num?)?.toDouble(),
      avghumidity: (json['avghumidity'] as num?)?.toDouble(),
      condition: json['condition'] != null ? WeatherConditionModel().fromJson(json['condition']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'maxtemp_c': maxtempC,
    'mintemp_c': mintempC,
    'avgtemp_c': avgtempC,
    'maxwind_kph': maxwindKph,
    'totalprecip_mm': totalprecipMm,
    'avgvis_km': avgvisKm,
    'avghumidity': avghumidity,
    'condition': condition?.toJson(),
  };
}
