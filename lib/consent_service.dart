import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Requests Google UMP consent and shows the form when required.
/// Timeouts apply only to network/load steps — not while the user reads the form.
Future<void> requestConsentAndShowForm({
  Duration loadTimeout = const Duration(seconds: 15),
}) async {
  final consentInfo = ConsentInformation.instance;

  try {
    await _requestConsentInfoUpdate(consentInfo).timeout(loadTimeout);
  } on TimeoutException {
    debugPrint('Consent: info update timed out, continuing');
    return;
  } catch (e, st) {
    debugPrint('Consent: info update error — $e\n$st');
    return;
  }

  try {
    final status = await consentInfo.getConsentStatus();
    final formAvailable = await consentInfo.isConsentFormAvailable();

    debugPrint('Consent: status=$status, formAvailable=$formAvailable');

    if (status != ConsentStatus.required || !formAvailable) {
      debugPrint('Consent: no form needed, continuing');
      return;
    }

    ConsentForm form;
    try {
      form = await _loadConsentForm().timeout(loadTimeout);
    } on TimeoutException {
      debugPrint('Consent: form load timed out, continuing');
      return;
    }

    // No timeout here — user may take as long as they need on the form.
    await _showConsentForm(form);
  } catch (e, st) {
    debugPrint('Consent: error — $e\n$st');
  }
}

Future<void> _requestConsentInfoUpdate(ConsentInformation consentInfo) {
  final completer = Completer<void>();

  consentInfo.requestConsentInfoUpdate(
    ConsentRequestParameters(),
    () {
      if (!completer.isCompleted) completer.complete();
    },
    (FormError error) {
      debugPrint('Consent info update error: ${error.message}');
      if (!completer.isCompleted) completer.complete();
    },
  );

  return completer.future;
}

Future<ConsentForm> _loadConsentForm() {
  final completer = Completer<ConsentForm>();

  ConsentForm.loadConsentForm(
    (ConsentForm form) {
      if (!completer.isCompleted) completer.complete(form);
    },
    (FormError error) {
      debugPrint('Consent form load error: ${error.message}');
      if (!completer.isCompleted) {
        completer.completeError(
          Exception('Consent form load failed: ${error.message}'),
        );
      }
    },
  );

  return completer.future;
}

Future<void> _showConsentForm(ConsentForm form) {
  final completer = Completer<void>();

  form.show((FormError? error) {
    if (error != null) {
      debugPrint('Consent form dismiss error: ${error.message}');
    } else {
      debugPrint('Consent form dismissed by user');
    }
    if (!completer.isCompleted) completer.complete();
  });

  return completer.future;
}
