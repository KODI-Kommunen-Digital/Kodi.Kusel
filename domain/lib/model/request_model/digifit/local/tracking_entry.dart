  import 'package:core/base_model.dart';

  class TrackerEntry extends BaseModel<TrackerEntry> {
    final int setComplete;
    final int locationId;
    final String createdAt;
    final String updatedAt;
    final List<String> setTimeList;

    TrackerEntry({
      this.setComplete = 0,
      this.locationId = 0,
      this.createdAt = '',
      this.updatedAt = '',
      this.setTimeList = const [],
    });

    @override
    Map<String, dynamic> toJson() {
      return {
        'setComplete': setComplete,
        'locationId': locationId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'setTimeList': setTimeList,
      };
    }

    @override
    TrackerEntry fromJson(Map<String, dynamic> json) {
      final times = <String>[];

      final rawTimeList = json['setTimeList'];
      if (rawTimeList != null && rawTimeList is List) {
        for (final item in rawTimeList) {
          times.add(item.toString());
        }
      }

      return TrackerEntry(
        setComplete: json['setComplete'] ?? 0,
        locationId: json['locationId'] ?? 0,
        createdAt: json['createdAt']?.toString() ?? '',
        updatedAt: json['updatedAt']?.toString() ?? '',
        setTimeList: times,
      );
    }
  }
