import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdRequestFactory {
  const AdRequestFactory._();

  static AdRequest collapsible({
    required String placement,
    bool freshRequestId = false,
  }) {
    final extras = <String, String>{
      'collapsible': placement,
    };
    if (freshRequestId) {
      extras['collapsible_request_id'] =
          DateTime.now().microsecondsSinceEpoch.toString();
    }
    return AdRequest(extras: extras);
  }

  static AdRequest collapsibleBottom({bool freshRequestId = false}) =>
      collapsible(placement: 'bottom', freshRequestId: freshRequestId);

  static AdRequest collapsibleTop({bool freshRequestId = false}) =>
      collapsible(placement: 'top', freshRequestId: freshRequestId);
}