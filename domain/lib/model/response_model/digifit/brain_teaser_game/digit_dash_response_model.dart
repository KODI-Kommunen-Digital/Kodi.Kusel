import 'package:core/base_model.dart';

class DigitDashResponseModel extends BaseModel<DigitDashResponseModel> {
  final DigitDashData? data;
  final String? status;

  DigitDashResponseModel({
    this.data,
    this.status,
  });

  @override
  DigitDashResponseModel fromJson(Map<String, dynamic> json) {
    return DigitDashResponseModel(
      data: DigitDashData.fromJson(json['data'] ?? {}),
      status: json['status'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'status': status,
    };
  }
}

class DigitDashData {
  final String? subDescription;
  final DigitDashGrid grid;
  final int initial;
  final String? targetCondition;
  final List<int> forbiddenNumbers;
  final int timer;
  final int sessionId;
  final int activityId;

  DigitDashData({
    required this.grid,
    required this.initial,
    required this.targetCondition,
    required this.forbiddenNumbers,
    required this.timer,
    required this.sessionId,
    required this.activityId,
    this.subDescription,
  });

  factory DigitDashData.fromJson(Map<String, dynamic> json) {
    final gridJson = json['grid'];
    final forbiddenList = <int>[];

    final rawForbidden = json['forbiddenNumbers'];
    if (rawForbidden is Iterable) {
      for (final element in rawForbidden) {
        if (element is int) {
          forbiddenList.add(element);
        } else if (element is String) {
          final parsed = int.tryParse(element);
          if (parsed != null) forbiddenList.add(parsed);
        }
      }
    }

    return DigitDashData(
      grid: gridJson is Map<String, dynamic>
          ? DigitDashGrid.fromJson(gridJson)
          : DigitDashGrid(row: 0, col: 0),
      initial: json['initial'] is int ? json['initial'] : 0,
      targetCondition:
          json['targetCondition'] is String ? json['targetCondition'] : null,
      forbiddenNumbers: forbiddenList,
      timer: json['timer'] is int ? json['timer'] : 0,
      sessionId: json['sessionId'] is int ? json['sessionId'] : 0,
      activityId: json['activityId'] is int ? json['activityId'] : 0,
      subDescription:
          json['subDescription'] is String ? json['subDescription'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grid': grid.toJson(),
      'initial': initial,
      'targetCondition': targetCondition,
      'forbiddenNumbers': forbiddenNumbers,
      'timer': timer,
      'sessionId': sessionId,
      'activityId': activityId,
      'subDescription': subDescription,
    };
  }
}

class DigitDashGrid {
  final int row;
  final int col;

  DigitDashGrid({
    required this.row,
    required this.col,
  });

  factory DigitDashGrid.fromJson(Map<String, dynamic> json) {
    return DigitDashGrid(
      row: json['row'] is int ? json['row'] : 0,
      col: json['col'] is int ? json['col'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'row': row,
      'col': col,
    };
  }
}
