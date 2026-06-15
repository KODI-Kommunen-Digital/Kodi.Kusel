import 'package:core/base_model.dart';
import 'package:domain/model/request_model/digifit/local/tracking_entry.dart';

class DigifitBulkTrackingRequestModel extends BaseModel<DigifitBulkTrackingRequestModel> {
  final List<Map<String, List<TrackerEntry>>> data;

  DigifitBulkTrackingRequestModel({this.data = const []});

  @override
  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> resultList = [];

    for (final mapEntry in data) {
      final Map<String, dynamic> convertedMap = {};

      mapEntry.forEach((key, valueList) {
        final List<Map<String, dynamic>> jsonList = [];
        for (final entry in valueList) {
          jsonList.add(entry.toJson());
        }
        convertedMap[key] = jsonList;
      });

      resultList.add(convertedMap);
    }

    return {'data': resultList};
  }

  @override
  DigifitBulkTrackingRequestModel fromJson(Map<String, dynamic> json) {
    final List<Map<String, List<TrackerEntry>>> resultList = [];

    final rawList = json['data'];
    if (rawList is List) {
      for (final item in rawList) {
        final Map<String, List<TrackerEntry>> entryMap = {};

        if (item is Map) {
          item.forEach((key, value) {
            final List<TrackerEntry> trackers = [];

            if (value is List) {
              for (final entryJson in value) {
                if (entryJson is Map<String, dynamic>) {
                  trackers.add(TrackerEntry().fromJson(entryJson));
                }
              }
            }

            entryMap[key.toString()] = trackers;
          });
        }

        resultList.add(entryMap);
      }
    }

    return DigifitBulkTrackingRequestModel(data: resultList);
  }
}
