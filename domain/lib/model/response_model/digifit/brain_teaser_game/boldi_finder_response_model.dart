import 'package:core/base_model.dart';

class BoldiFinderResponseModel extends BaseModel<BoldiFinderResponseModel> {
  final BoldFinderDataModel? data;
  final String? status;

  BoldiFinderResponseModel({this.data, this.status});

  @override
  BoldiFinderResponseModel fromJson(Map<String, dynamic> json) {
    return BoldiFinderResponseModel(
      data: json['data'] != null
          ? BoldFinderDataModel().fromJson(json['data'])
          : null,
      status: json['status'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'status': status,
      };
}

class BoldFinderDataModel extends BaseModel<BoldFinderDataModel> {
  final String? subDescription;
  final GridModel? grid;
  final PositionModel? startPosition;
  final PositionModel? finalPosition;
  final List<String>? steps;
  final int? totalSteps;
  final int? timer;
  final int? sessionId;
  final int? activityId;

  BoldFinderDataModel(
      {this.grid,
      this.startPosition,
      this.finalPosition,
      this.steps,
      this.totalSteps,
      this.timer,
      this.sessionId,
      this.activityId,
      this.subDescription});

  @override
  BoldFinderDataModel fromJson(Map<String, dynamic> json) {
    return BoldFinderDataModel(
      grid: json['grid'] != null ? GridModel().fromJson(json['grid']) : null,
      startPosition: json['startPosition'] != null
          ? PositionModel().fromJson(json['startPosition'])
          : null,
      finalPosition: json['finalPosition'] != null
          ? PositionModel().fromJson(json['finalPosition'])
          : null,
      steps: json['steps'] != null ? List<String>.from(json['steps']) : null,
      totalSteps: json['totalSteps'],
      timer: json['timer'],
      sessionId: json['sessionId'],
      activityId: json['activityId'],
      subDescription: json['subDescription'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'grid': grid?.toJson(),
        'startPosition': startPosition?.toJson(),
        'finalPosition': finalPosition?.toJson(),
        'steps': steps,
        'totalSteps': totalSteps,
        'timer': timer,
        'sessionId': sessionId,
        'activityId': activityId,
        'subDescription': subDescription,
      };
}

class GridModel extends BaseModel<GridModel> {
  final int? row;
  final int? col;

  GridModel({this.row, this.col});

  @override
  GridModel fromJson(Map<String, dynamic> json) {
    return GridModel(
      row: json['row'],
      col: json['col'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'row': row,
        'col': col,
      };
}

class PositionModel extends BaseModel<PositionModel> {
  final int? row;
  final int? col;

  PositionModel({this.row, this.col});

  @override
  PositionModel fromJson(Map<String, dynamic> json) {
    return PositionModel(
      row: json['row'],
      col: json['col'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'row': row,
        'col': col,
      };
}
