import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kusel/common_widgets/web_view_page.dart';
import 'package:kusel/screens/all_city/all_city_screen.dart';
import 'package:kusel/screens/all_city/all_city_screen_controller.dart';
import 'package:kusel/screens/all_event/all_event_screen.dart';
import 'package:kusel/screens/all_event/all_event_screen_param.dart';
import 'package:kusel/screens/all_municipality/all_municipality_provider.dart';
import 'package:kusel/screens/all_municipality/all_municipality_screen.dart';
import 'package:kusel/screens/auth/forgot_password/forgot_password_screen.dart';
import 'package:kusel/screens/auth/signin/signin_screen.dart';
import 'package:kusel/screens/auth/signup/signup_screen.dart';
import 'package:kusel/screens/dashboard/dashboard_screen.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/all_games/params/all_game_params.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/common_navigation/game_registry.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/game_details/details_screen.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/game_details/params/details_params.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/game_list/list_screen.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/digifit_exercise_detail_screen.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/params/digifit_exercise_details_params.dart';
import 'package:kusel/screens/digifit_screens/digifit_fav_screen/digifit_fav_Screen.dart';
import 'package:kusel/screens/digifit_screens/digifit_overview/digifit_overview_screen.dart';
import 'package:kusel/screens/digifit_screens/digifit_overview/params/digifit_overview_params.dart';
import 'package:kusel/screens/digifit_screens/digifit_qr_scanner/digifit_qr_scanner_screen.dart';
import 'package:kusel/screens/digifit_screens/digifit_start/digifit_information_screen.dart';
import 'package:kusel/screens/digifit_screens/digifit_trophies/digifit_trophies_screen.dart';
import 'package:kusel/screens/event/event_detail_screen.dart';
import 'package:kusel/screens/event/event_detail_screen_controller.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';
import 'package:kusel/screens/explore/explore_screen.dart';
import 'package:kusel/screens/favorite/favorites_list_screen.dart';
import 'package:kusel/screens/favourite_city/favourite_city_screen.dart';
import 'package:kusel/screens/feedback/feedback_screen.dart';
import 'package:kusel/screens/fliter_screen/filter_screen.dart';
import 'package:kusel/screens/full_image/full_image_screen.dart';
import 'package:kusel/screens/highlight/highlight_screen.dart';
import 'package:kusel/screens/home/home_screen.dart';
import 'package:kusel/screens/kusel_setting_screen/kusel_fav_screen.dart';
import 'package:kusel/screens/kusel_setting_screen/kusel_setting_screen.dart';
import 'package:kusel/screens/kusel_setting_screen/legal_policy_screen.dart';
import 'package:kusel/screens/kusel_setting_screen/profile_setting_screen.dart';
import 'package:kusel/screens/location/location_screen.dart';
import 'package:kusel/screens/mein_ort/mein_ort_screen.dart';
import 'package:kusel/screens/mobility_screen/mobility_screen.dart';
import 'package:kusel/screens/municipal_party_detail/municipal_detail_screen.dart';
import 'package:kusel/screens/municipal_party_detail/widget/municipal_detail_screen_params.dart';
import 'package:kusel/screens/new_filter_screen/category_filter_screen.dart';
import 'package:kusel/screens/new_filter_screen/location_and_distance_filter_screen.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_params.dart';
import 'package:kusel/screens/no_network/network_status_screen.dart';
import 'package:kusel/screens/onboarding/onboarding_finish_page.dart';
import 'package:kusel/screens/onboarding/onboarding_loading_page.dart';
import 'package:kusel/screens/onboarding/onboarding_name_page.dart';
import 'package:kusel/screens/onboarding/onboarding_option_page.dart';
import 'package:kusel/screens/onboarding/onboarding_preferences_page.dart';
import 'package:kusel/screens/onboarding/onboarding_start_page.dart';
import 'package:kusel/screens/onboarding/onboarding_type_page.dart';
import 'package:kusel/screens/ort_detail/ort_detail_screen.dart';
import 'package:kusel/screens/ort_detail/ort_detail_screen_params.dart';
import 'package:kusel/screens/participate_screen/participate_screen.dart';
import 'package:kusel/screens/profile/profile_screen.dart';
import 'package:kusel/screens/reset_password/reset_password_screen.dart';
import 'package:kusel/screens/search/search_screen.dart';
import 'package:kusel/screens/search_result/search_result_screen.dart';
import 'package:kusel/screens/search_result/search_result_screen_parameter.dart';
import 'package:kusel/screens/settings/settings_screen.dart';
import 'package:kusel/screens/splash/splash_screen.dart';
import 'package:kusel/screens/sub_category/sub_category_screen.dart';
import 'package:kusel/screens/sub_category/sub_category_screen_parameter.dart';
import 'package:kusel/screens/tourism/tourism_screen.dart';
import 'package:kusel/screens/virtual_town_hall/virtual_town_hall_screen.dart';

// Top‑level GoRouter provider with root key and initial location
final mobileRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: splashScreenPath,
    debugLogDiagnostics: true,
    routes: goRouteList,
  );
});

// Path constants
const splashScreenPath = "/";
const signInScreenPath = "/signInScreen";
const signUpScreenPath = "/signUpScreen";
const eventDetailScreenPath = "/eventScreenPath";
const forgotPasswordPath = "/forgotPasswordPath";
const highlightScreenPath = "/highlightScreenPath";
const subCategoryScreenPath = "/subCategoryPath";
const selectedEventListScreenPath = "/eventListScreenPath";
const filterScreenPath = "/filterScreenPath";
const searchResultScreenPath = "/searchResultScreenPath";
const onboardingLoadingPagePath = "/onboardingLoadingPagePath";
const onboardingFinishPagePath = "/onboardingFinishPagePath";
const onboardingStartPagePath = "/onboardingStartPagePath";
const onboardingNamePagePath = "/onboardingNamePagePath";
const onboardingOptionPagePath = "/onboardingOptionPagePath";
const onboardingTypePagePath = "/onboardingTypePagePath";
const onboardingPreferencesPagePath = "/onboardingPreferencesPagePath";
const profileScreenPath = "/profileScreenPath";
const favoritesListScreenPath = "/favoritesListScreenPath";
const favouriteCityScreenPath = "/favouriteCityScreenPath";
const feedbackScreenPath = "/feedbackScreenPath";
const allEventScreenPath = "/allEventScreen";
const municipalDetailScreenPath = "/municipalDetailScreenPath";
const allCityScreenPath = "/allCityScreenPath";
const allMunicipalityScreenPath = "/allMunicipalityScreenPath";
const ortDetailScreenPath = "/ortDetailScreenPath";
const newFilterScreenPath = "/newFilterScreen";
const categoryFilterScreenPath = "/categoryFilterScreen";
const locationDistanceScreenPath = "/locationDistanceScreen";

// Bottom Nav & Explore sub‑routes paths
const homeScreenPath = "/homeScreenPath";
const exploreScreenPath = "/exploreScreenPath";
const searchScreenPath = "/searchScreenPath";
const locationScreenPath = "/locationScreenPath";
const kuselSettingScreenPath = "/settingScreenPath";

// BECAUSE WE ARE USING STATEFUL SHELL ROUTING i.e; we are not putting forward slash
const tourismScreenPath = "tourismScreenPath";
const virtualTownHallScreenPath = "virtualTownHallScreenPath";
const meinOrtScreenPath = "meinOrtScreenPath";
const mobilityScreenPath = "mobilityScreenPath";
const participateScreenPath = "participateScreenPath";
const digifitStartScreenPath = "digifitStartScreenPath";
const digifitTrophiesScreenPath = "digifitTrophiesScreenPath";
const brainTeasersGameListScreenPath = "brainTeasersGameListScreenPath";

// DigiFit screen path
const digifitOverViewScreenPath = "/digifitOverViewScreenPath";
const digifitQRScannerScreenPath = "/digifitQRScannerScreenPath";
const digifitExerciseDetailScreenPath = "/digifitExerciseDetailScreenPath";
const digifitFavScreenPath = "/digifitFavScreen";

// Game's screen Path
const brainTeaserGameDetailsScreenPath = "/brainTeasersGameDetailsScreenPath";
const String boldiFinderScreenPath = '/boldi-finder';
const String matheJagdScreenPath = '/mathe-jagd';
const String flipCatchScreenPath = '/flip-catch';
const String digitDashScreenPath = '/digit-dash';
const String bilderSpielScreenPath = '/bilder-spiel';

const webViewPagePath = "/webViewPagePath";
const fullImageScreenPath = '/fullImageScreenPath';

const subShellFeedbackScreenPath = "feedbackScreen";

const resetPasswordScreenPath = "/resetPasswordScreen;";

// setting screen
const kuselFavScreenPath = "kuselFavScreen";
const legalPolicyScreenPath = "/legalPolicyScreen";
const profileSettingScreenPath = "profileSettingScreen";

final exploreSubScreenRoutes = [
  tourismScreenPath,
  virtualTownHallScreenPath,
  meinOrtScreenPath,
  mobilityScreenPath,
  participateScreenPath,
  digifitStartScreenPath,
  digifitTrophiesScreenPath,
  brainTeasersGameListScreenPath,
];

// Full route list
List<RouteBase> goRouteList = [
  // Auth & misc screens
  GoRoute(path: splashScreenPath, builder: (_, __) => SplashScreen()),
  GoRoute(path: feedbackScreenPath, builder: (_, __) => FeedbackScreen()),
  GoRoute(path: signInScreenPath, builder: (_, __) => SignInScreen()),
  GoRoute(path: signUpScreenPath, builder: (_, __) => SignupScreen()),
  GoRoute(
      path: eventDetailScreenPath,
      builder: (_, state) => EventDetailScreen(
          eventScreenParams: state.extra as EventDetailScreenParams)),
  GoRoute(
      path: selectedEventListScreenPath,
      builder: (_, state) => SelectedEventListScreen(
          eventListScreenParameter:
              state.extra as SelectedEventListScreenParameter)),
  GoRoute(path: forgotPasswordPath, builder: (_, __) => ForgotPasswordScreen()),
  GoRoute(
      path: subCategoryScreenPath,
      builder: (_, state) => SubCategoryScreen(
          subCategoryScreenParameters:
              state.extra as SubCategoryScreenParameters)),
  GoRoute(path: highlightScreenPath, builder: (_, __) => HighlightScreen()),
  GoRoute(path: filterScreenPath, builder: (_, __) => FilterScreen()),
  GoRoute(
      path: searchResultScreenPath,
      builder: (_, state) => SearchResultScreen(
          searchResultScreenParameter:
              state.extra as SearchResultScreenParameter)),
  GoRoute(
      path: onboardingLoadingPagePath,
      builder: (_, __) => OnboardingLoadingPage()),
  GoRoute(
      path: onboardingFinishPagePath,
      builder: (_, __) => OnboardingFinishPage()),

  GoRoute(
      path: onboardingStartPagePath, builder: (_, __) => OnboardingStartPage()),

  GoRoute(
      path: onboardingNamePagePath, builder: (_, __) => OnBoardingNamePage()),

  GoRoute(
      path: onboardingOptionPagePath,
      builder: (_, __) => OnboardingOptionPage()),

  GoRoute(
      path: onboardingTypePagePath, builder: (_, __) => OnboardingTypePage()),

  GoRoute(
      path: onboardingPreferencesPagePath,
      builder: (_, __) => OnBoardingPreferencesPage()),

  GoRoute(path: profileScreenPath, builder: (_, __) => ProfileScreen()),
  GoRoute(
      path: favoritesListScreenPath, builder: (_, __) => FavoritesListScreen()),
  GoRoute(
      path: favouriteCityScreenPath, builder: (_, __) => FavouriteCityScreen()),
  GoRoute(
      path: allEventScreenPath,
      builder: (_, state) => AllEventScreen(
            allEventScreenParam: state.extra as AllEventScreenParam,
          )),
  GoRoute(
      path: municipalDetailScreenPath,
      builder: (_, state) => MunicipalDetailScreen(
          municipalDetailScreenParams:
              state.extra as MunicipalDetailScreenParams)),
  GoRoute(
      path: allCityScreenPath,
      builder: (_, state) => AllCityScreen(
          allCityScreenParams: state.extra as AllCityScreenParams)),
  GoRoute(
      path: ortDetailScreenPath,
      builder: (_, state) => OrtDetailScreen(
          ortDetailScreenParams: state.extra as OrtDetailScreenParams)),
  GoRoute(
      path: allMunicipalityScreenPath,
      builder: (_, state) => AllMunicipalityScreen(
          municipalityScreenParams: state.extra as MunicipalityScreenParams)),
  GoRoute(
      path: favouriteCityScreenPath, builder: (_, __) => FavouriteCityScreen()),

  GoRoute(
      path: resetPasswordScreenPath, builder: (_, __) => ResetPasswordScreen()),

  GoRoute(
      path: digifitOverViewScreenPath,
      builder: (_, state) => DigifitOverviewScreen(
          digifitOverviewScreenParams:
              state.extra as DigifitOverviewScreenParams)),
  GoRoute(
      path: digifitQRScannerScreenPath,
      builder: (_, __) => DigifitQRScannerScreen()),

  GoRoute(
      path: digifitExerciseDetailScreenPath,
      builder: (_, state) => DigifitExerciseDetailScreen(
            digifitExerciseDetailsParams:
                state.extra as DigifitExerciseDetailsParams,
          )),

  GoRoute(
      path: legalPolicyScreenPath,
      builder: (_, state) => LegalPolicyScreen(
            legalPolicyScreenParams: state.extra as LegalPolicyScreenParams,
          )),

  GoRoute(
      path: brainTeaserGameDetailsScreenPath,
      builder: (_, state) => BrainTeaserGameDetailsScreen(
            brainTeaserGameDetailsParams:
                state.extra as BrainTeaserGameDetailsParams,
          )),

  GoRoute(
    path: boldiFinderScreenPath,
    builder: (context, state) {
      final params = state.extra as AllGameParams?;
      return GameRegistry.getGameScreen(1, params);
    },
  ),

  GoRoute(
    path: flipCatchScreenPath,
    builder: (context, state) {
      final params = state.extra as AllGameParams?;
      return GameRegistry.getGameScreen(2, params);
    },
  ),

  GoRoute(
    path: matheJagdScreenPath,
    builder: (context, state) {
      final params = state.extra as AllGameParams?;
      return GameRegistry.getGameScreen(3, params);
    },
  ),

  GoRoute(
    path: digitDashScreenPath,
    builder: (context, state) {
      final params = state.extra as AllGameParams?;
      return GameRegistry.getGameScreen(4, params);
    },
  ),

  GoRoute(
    path: bilderSpielScreenPath,
    builder: (context, state) {
      final params = state.extra as AllGameParams?;
      return GameRegistry.getGameScreen(5, params);
    },
  ),

  GoRoute(
      path: webViewPagePath,
      builder: (_, state) =>
          WebViewPage(webViewParams: state.extra as WebViewParams)),
  GoRoute(
      path: fullImageScreenPath,
      builder: (_, state) => FullImageScreen(
          fullImageScreenParams: state.extra as FullImageScreenParams)),

  GoRoute(
      path: newFilterScreenPath,
      builder: (_, state) => NewFilterScreen(
            params: state.extra as NewFilterScreenParams,
          )),

  GoRoute(
      path: categoryFilterScreenPath,
      builder: (_, state) => CategoryFilterScreen(
            categoryScreenParams: state.extra as CategoryScreenParams,
          )),

  GoRoute(
      path: locationDistanceScreenPath,
      builder: (_, state) => LocationAndDistanceFilterScreen()),

  GoRoute(
      path: digifitFavScreenPath, builder: (_, state) => DigifitFavScreen()),

  // Dashboard + tabs
  dashboardRoutes,
];

// Dashboard Route list
final dashboardRoutes = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return DashboardScreen(
      child: navigationShell,
    );
  },
  branches: [
    //  Home Tab
    StatefulShellBranch(
      routes: [
        GoRoute(
            path: homeScreenPath,
            builder: (_, __) => HomeScreen(),
            routes: [
              GoRoute(
                path: subShellFeedbackScreenPath,
                builder: (_, __) => const FeedbackScreen(),
              ),
            ]),
      ],
    ),
    //  Explore Tab + sub routes
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: exploreScreenPath,
          builder: (_, __) => const ExploreScreen(),
          routes: [
            GoRoute(
              path: subShellFeedbackScreenPath,
              builder: (_, __) => const FeedbackScreen(),
            ),
            GoRoute(
              path: tourismScreenPath,
              builder: (_, __) => const TourismScreen(),
            ),
            GoRoute(
              path: virtualTownHallScreenPath,
              builder: (_, __) => const VirtualTownHallScreen(),
            ),
            GoRoute(
              path: mobilityScreenPath,
              builder: (_, __) => const MobilityScreen(),
            ),
            GoRoute(
              path: meinOrtScreenPath,
              builder: (_, __) => const MeinOrtScreen(),
            ),
            GoRoute(
              path: digifitStartScreenPath,
              builder: (_, __) => const DigifitInformationScreen(),
            ),
            GoRoute(
                path: digifitTrophiesScreenPath,
                builder: (_, __) => DigifitTrophiesScreen()),
            GoRoute(
                path: brainTeasersGameListScreenPath,
                builder: (_, __) => const BrainTeaserGameListScreen()),
            GoRoute(
              path: participateScreenPath,
              builder: (_, __) => const ParticipateScreen(),
            ),
          ],
        ),
      ],
    ),
    // Search Tab
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: searchScreenPath,
          builder: (_, __) => const SearchScreen(),
        ),
      ],
    ),
    // Location Tab
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: locationScreenPath,
          builder: (_, __) => const LocationScreen(),
        ),
      ],
    ),
    //  Settings Tab
    StatefulShellBranch(
      routes: [
        GoRoute(
            path: kuselSettingScreenPath,
            builder: (_, __) => KuselSettingScreen(), //const SettingsScreen()
            routes: [
              GoRoute(
                path: kuselFavScreenPath,
                builder: (_, __) => const KuselFavScreen(),
              ),
              GoRoute(
                path: subShellFeedbackScreenPath,
                builder: (_, __) => const FeedbackScreen(),
              ),
              GoRoute(
                path: profileSettingScreenPath,
                builder: (_, __) => const ProfileSettingScreen(),
              )
            ]),
      ],
    ),
  ],
);
