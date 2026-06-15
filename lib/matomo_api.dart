import 'package:matomo_tracker/matomo_tracker.dart';

class MatomoService {
  static const String category_core_screens = 'App Hauptbildschirme';

  static const String action_onboarding_screen = 'Onboarding Bildschirm besucht';
  static const String action_home_screen = 'Startseite besucht';
  static const String action_explore_screen = 'Entdecken Bildschirm besucht';
  static const String action_search_screen = 'Suchbildschirm besucht';
  static const String action_location_screen = 'Standort Bildschirm besucht';
  static const String action_profile_screen = 'Profilbildschirm besucht';
  static const String action_login_screen = 'Login Bildschirm besucht';
  static const String action_signup_screen = 'Registrierung Bildschirm besucht';
  static const String action_favourite_events_screen = 'Favoriten Veranstaltungen Bildschirm besucht';
  static const String action_event_details_screen = 'Veranstaltungsdetails Bildschirm besucht';
  static const String action_virtual_townhall_screen = 'Virtuelle Bürgerversammlung besucht';
  static const String action_mein_ort_screen = 'Mein Ort Bildschirm besucht';
  static const String action_mobility_screen = 'Mobilität Bildschirm besucht';
  static const String action_tourism_screen = 'Tourismus Bildschirm besucht';
  static const String action_participate_screen = 'Mitmachen Bildschirm besucht';
  static const String action_feedback_screen = 'Feedback Bildschirm besucht';

  static const String category_digifit = 'Digifit Bereich';

  static const String action_digifit_overview_screen = 'Digifit Übersicht besucht';
  static const String action_brain_teaser_screen = 'Gehirntraining Bildschirm besucht';
  static const String action_digifit_exercise_screen = 'Digifit Übungsbildschirm besucht';
  static const String action_digifit_exercise_detail_screen = 'Digifit Übungsdetails besucht';
  static const String action_digifit_qr_screen = 'Digifit QR-Code Bildschirm besucht';
  static const String action_digifit_trophies_screen = 'Digifit Trophäen Bildschirm besucht';


  static const String category_authentication = 'Authentifizierung und Konto';

  static const String action_login = 'Login durchgeführt';
  static const String action_signup = 'Registrierung abgeschlossen';
  static const String action_logout = 'Logout durchgeführt';
  static const String action_forgot_password = 'Passwort zurückgesetzt';
  static const String action_profile_update = 'Profil aktualisiert';
  static const String action_delete_account = 'Konto gelöscht';
  static const String action_onboarding_completed = 'Onboarding abgeschlossen';


  static const String category_engagement = 'App Nutzung';

  static const String action_favourite_added = 'Veranstaltung zu Favoriten hinzugefügt';
  static const String action_favourite_removed = 'Veranstaltung aus Favoriten entfernt';
  static const String action_feedback_submitted = 'Feedback gesendet';


  static const String category_digifit_actions = 'Digifit Aktivitäten';

  static const String action_digifit_exercise_completed = 'Digifit Übung abgeschlossen';
  static const String action_digifit_game_played = 'Digifit Spiel gespielt';
  static const String action_qr_scanned = 'QR-Code gescannt';
  static const String action_trophy_earned = 'Trophäe erhalten';

  /// Initialize Matomo
  static Future<void> initialize({
    required String siteId,
    required String url,
  }) async {
    await MatomoTracker.instance.initialize(
      siteId: siteId,
      url: url,
    );
  }

  /// Set logged-in user ID
  static void setUserId(String userId) {
    MatomoTracker.instance.setVisitorUserId(userId);
  }

  /// Clear user ID on logout
  static void clearUser() {
    MatomoTracker.instance.setVisitorUserId(null);
  }

  /// Generic event tracker
  static void trackEvent({
    required String eventName,
    required String category,
    required String action,
    int value = 1,
    Map<String, String>? dimensions,
  }) {
    MatomoTracker.instance.trackEvent(
      eventInfo: EventInfo(
        category: category,
        action: action,
        name: eventName,
        value: value,
      ),
      dimensions: dimensions,
    );
  }

  static void trackLoginSuccess({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);

    trackEvent(
      eventName: "loginSuccess",
      dimensions: dimensions,
      category: category_authentication,
      action: action_login,
    );
  }


  // ---------------- CORE SCREENS ----------------

  static void trackLoginViewed({
    Map<String, String>? dimensions,
  }) {
    trackEvent(
      eventName: "loginScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_login_screen,
    );
  }

  static void trackOnboardingScreenViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "onboardingScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_onboarding_screen,
    );
  }

  static void trackHomeScreenViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "homeScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_home_screen,
    );
  }

  static void trackExploreScreenViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "exploreScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_explore_screen,
    );
  }

  static void trackSearchScreenViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "searchScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_search_screen,
    );
  }

  static void trackLocationScreenViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "locationScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_location_screen,
    );
  }

  static void trackProfileScreenViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "profileScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_profile_screen,
    );
  }

  static void trackFavouriteEventsScreenViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "favouriteEventsScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_favourite_events_screen,
    );
  }

  static void trackEventDetailsScreenViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "eventDetailsScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_event_details_screen,
    );
  }

  static void trackVirtualTownhallScreenViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "virtualTownhallScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_virtual_townhall_screen,
    );
  }

  static void trackMeinOrtScreenViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "meinOrtScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_mein_ort_screen,
    );
  }

  static void trackMobilityScreenViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "mobilityScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_mobility_screen,
    );
  }

  static void trackTourismScreenViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "tourismScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_tourism_screen,
    );
  }

  static void trackParticipateScreenViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "participateScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_participate_screen,
    );
  }

  static void trackFeedbackScreenViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "feedbackScreenViewed",
      dimensions: dimensions,
      category: category_core_screens,
      action: action_feedback_screen,
    );
  }

  // ---------------- AUTHENTICATION ----------------

  static void trackLogin({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);
    trackEvent(
      eventName: "login",
      dimensions: dimensions,
      category: category_authentication,
      action: action_login,
    );
  }

  static void trackSignup({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);
    trackEvent(
      eventName: "signup",
      dimensions: dimensions,
      category: category_authentication,
      action: action_signup,
    );
  }

  static void trackLogout({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    trackEvent(
      eventName: "logout",
      category: category_authentication,
      action: action_logout,
    );
    clearUser();
  }

  static void trackForgotPassword({
    Map<String, String>? dimensions,
  }) {
    trackEvent(
      eventName: "forgotPassword",
      dimensions: dimensions,
      category: category_authentication,
      action: action_forgot_password,
    );
  }

  static void trackProfileUpdated({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);
    trackEvent(
      eventName: "profileUpdated",
      dimensions: dimensions,
      category: category_authentication,
      action: action_profile_update,
    );
  }

  static void trackDeleteAccount({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);
    trackEvent(
      eventName: "deleteAccount",
      dimensions: dimensions,
      category: category_authentication,
      action: action_delete_account,
    );
  }

  static void trackOnboardingCompletedAuth({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);
    trackEvent(
      eventName: "onboardingCompleted",
      dimensions: dimensions,
      category: category_authentication,
      action: action_onboarding_completed,
    );
  }

  // ---------------- ENGAGEMENT ----------------

  static void trackFavouriteAdded({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);
    trackEvent(
      eventName: "favouriteAdded",
      dimensions: dimensions,
      category: category_engagement,
      action: action_favourite_added,
    );
  }

  static void trackFavouriteRemoved({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);
    trackEvent(
      eventName: "favouriteRemoved",
      dimensions: dimensions,
      category: category_engagement,
      action: action_favourite_removed,
    );
  }

  static void trackFeedbackSubmitted({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);
    trackEvent(
      eventName: "feedbackSubmitted",
      dimensions: dimensions,
      category: category_engagement,
      action: action_feedback_submitted,
    );
  }

  // ---------------- DIGIFIT SCREENS ----------------

  static void trackDigifitOverviewViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "digifitOverviewViewed",
      dimensions: dimensions,
      category: category_digifit,
      action: action_digifit_overview_screen,
    );
  }

  static void trackBrainTeaserViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "brainTeaserViewed",
      dimensions: dimensions,
      category: category_digifit,
      action: action_brain_teaser_screen,
    );
  }

  static void trackDigifitExerciseViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "digifitExerciseViewed",
      dimensions: dimensions,
      category: category_digifit,
      action: action_digifit_exercise_screen,
    );
  }

  static void trackDigifitExerciseDetailViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "digifitExerciseDetailViewed",
      dimensions: dimensions,
      category: category_digifit,
      action: action_digifit_exercise_detail_screen,
    );
  }

  static void trackDigifitQrViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "digifitQrViewed",
      dimensions: dimensions,
      category: category_digifit,
      action: action_digifit_qr_screen,
    );
  }

  static void trackDigifitTrophiesViewed({Map<String, String>? dimensions}) {
    trackEvent(
      eventName: "digifitTrophiesViewed",
      dimensions: dimensions,
      category: category_digifit,
      action: action_digifit_trophies_screen,
    );
  }

  // ---------------- DIGIFIT ACTIONS ----------------

  static void trackDigifitExerciseCompleted({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);
    trackEvent(
      eventName: "digifitExerciseCompleted",
      dimensions: dimensions,
      category: category_digifit_actions,
      action: action_digifit_exercise_completed,
    );
  }

  static void trackDigifitGamePlayed({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);
    trackEvent(
      eventName: "digifitGamePlayed",
      dimensions: dimensions,
      category: category_digifit_actions,
      action: action_digifit_game_played,
    );
  }

  static void trackQrScanned({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);
    trackEvent(
      eventName: "qrScanned",
      dimensions: dimensions,
      category: category_digifit_actions,
      action: action_qr_scanned,
    );
  }

  static void trackTrophyEarned({
    required String userId,
    Map<String, String>? dimensions,
  }) {
    setUserId(userId);
    trackEvent(
      eventName: "trophyEarned",
      dimensions: dimensions,
      category: category_digifit_actions,
      action: action_trophy_earned,
    );
  }
}
