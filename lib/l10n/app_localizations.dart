import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Flutter Localization'**
  String get welcome;

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Heidi'**
  String get app_title;

  /// No description provided for @enter_email_id.
  ///
  /// In en, this message translates to:
  /// **'Email or Username'**
  String get enter_email_id;

  /// No description provided for @email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get email_required;

  /// No description provided for @password_required.
  ///
  /// In en, this message translates to:
  /// **'password is required'**
  String get password_required;

  /// No description provided for @password_required_error.
  ///
  /// In en, this message translates to:
  /// **'Password must be 8+ characters, include upper/lowercase,\na number, and a special character'**
  String get password_required_error;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'SignUp'**
  String get signup;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @roleId.
  ///
  /// In en, this message translates to:
  /// **'Role ID'**
  String get roleId;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @forgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgot;

  /// No description provided for @email_send.
  ///
  /// In en, this message translates to:
  /// **'Email has been send'**
  String get email_send;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, Please try again later'**
  String get something_went_wrong;

  /// No description provided for @highlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get highlights;

  /// No description provided for @category_heading.
  ///
  /// In en, this message translates to:
  /// **'What is there to discover'**
  String get category_heading;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'language'**
  String get change_language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get select_language;

  /// No description provided for @medieval_market.
  ///
  /// In en, this message translates to:
  /// **'Medieval market'**
  String get medieval_market;

  /// No description provided for @public_transport_offer.
  ///
  /// In en, this message translates to:
  /// **'Public transport offer'**
  String get public_transport_offer;

  /// No description provided for @next_dates.
  ///
  /// In en, this message translates to:
  /// **'Next dates'**
  String get next_dates;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @enter_search_term.
  ///
  /// In en, this message translates to:
  /// **'Enter search term'**
  String get enter_search_term;

  /// No description provided for @feedback_heading.
  ///
  /// In en, this message translates to:
  /// **'What do you think of the app?'**
  String get feedback_heading;

  /// No description provided for @feedback_description.
  ///
  /// In en, this message translates to:
  /// **'Is there anything missing or have you noticed something? Let us know so we can continually improve the app.'**
  String get feedback_description;

  /// No description provided for @send_feedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get send_feedback;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get no_data;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @all_events.
  ///
  /// In en, this message translates to:
  /// **'View all events'**
  String get all_events;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @target_group.
  ///
  /// In en, this message translates to:
  /// **'Target Group'**
  String get target_group;

  /// No description provided for @ort.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get ort;

  /// No description provided for @perimeter.
  ///
  /// In en, this message translates to:
  /// **'Perimeter'**
  String get perimeter;

  /// No description provided for @sort_by.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sort_by;

  /// No description provided for @actuality.
  ///
  /// In en, this message translates to:
  /// **'Actuality'**
  String get actuality;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @log_in_sign_up.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP | LOG IN'**
  String get log_in_sign_up;

  /// No description provided for @near_you.
  ///
  /// In en, this message translates to:
  /// **'Near you'**
  String get near_you;

  /// No description provided for @to_map_view.
  ///
  /// In en, this message translates to:
  /// **'To map view'**
  String get to_map_view;

  /// No description provided for @map_fav.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get map_fav;

  /// No description provided for @map_calendar.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get map_calendar;

  /// No description provided for @map_restaurant.
  ///
  /// In en, this message translates to:
  /// **'Gastronomy'**
  String get map_restaurant;

  /// No description provided for @select_environment.
  ///
  /// In en, this message translates to:
  /// **'Select Environment'**
  String get select_environment;

  /// No description provided for @search_heading.
  ///
  /// In en, this message translates to:
  /// **'How can I help you?\nJust ask me anything.'**
  String get search_heading;

  /// No description provided for @near_me.
  ///
  /// In en, this message translates to:
  /// **'What\'s near me'**
  String get near_me;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @recent_search.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recent_search;

  /// No description provided for @search_result.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get search_result;

  /// No description provided for @check_your_email.
  ///
  /// In en, this message translates to:
  /// **'A link has been send to your email, please verify'**
  String get check_your_email;

  /// No description provided for @lets_get_started.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started'**
  String get lets_get_started;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @another_time.
  ///
  /// In en, this message translates to:
  /// **'Another time'**
  String get another_time;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @what_may_i_call_you.
  ///
  /// In en, this message translates to:
  /// **'What may I call you?'**
  String get what_may_i_call_you;

  /// No description provided for @your_name.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get your_name;

  /// No description provided for @ich_text.
  ///
  /// In en, this message translates to:
  /// **'I ...'**
  String get ich_text;

  /// No description provided for @i_live_in_district.
  ///
  /// In en, this message translates to:
  /// **'I live in the district...'**
  String get i_live_in_district;

  /// No description provided for @i_am_visiting_the_district.
  ///
  /// In en, this message translates to:
  /// **'I am visiting the district ...'**
  String get i_am_visiting_the_district;

  /// No description provided for @i_live_in_district_onborading_type_page.
  ///
  /// In en, this message translates to:
  /// **'live here in the district'**
  String get i_live_in_district_onborading_type_page;

  /// No description provided for @welcome_text.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome_text;

  /// No description provided for @welcome_para_first.
  ///
  /// In en, this message translates to:
  /// **'In order to offer you tailored content from the region that will also interest you, we would need a little information.'**
  String get welcome_para_first;

  /// No description provided for @welcome_para_second.
  ///
  /// In en, this message translates to:
  /// **'This information is voluntary and can be skipped. You can adjust it at any time in the settings.'**
  String get welcome_para_second;

  /// No description provided for @live_here.
  ///
  /// In en, this message translates to:
  /// **'live in'**
  String get live_here;

  /// No description provided for @spend_my_free_time_here.
  ///
  /// In en, this message translates to:
  /// **'Spend my free time in'**
  String get spend_my_free_time_here;

  /// No description provided for @your_place_of_residence.
  ///
  /// In en, this message translates to:
  /// **'Your place of residence'**
  String get your_place_of_residence;

  /// No description provided for @select_residence.
  ///
  /// In en, this message translates to:
  /// **'Select residence'**
  String get select_residence;

  /// No description provided for @alone.
  ///
  /// In en, this message translates to:
  /// **'Alone'**
  String get alone;

  /// No description provided for @for_two.
  ///
  /// In en, this message translates to:
  /// **'For two'**
  String get for_two;

  /// No description provided for @with_dog.
  ///
  /// In en, this message translates to:
  /// **'With dog'**
  String get with_dog;

  /// No description provided for @barrierearm.
  ///
  /// In en, this message translates to:
  /// **'Low barrier'**
  String get barrierearm;

  /// No description provided for @with_my_family.
  ///
  /// In en, this message translates to:
  /// **'With my family'**
  String get with_my_family;

  /// No description provided for @your_location.
  ///
  /// In en, this message translates to:
  /// **'Your location (optional)'**
  String get your_location;

  /// No description provided for @almost_there.
  ///
  /// In en, this message translates to:
  /// **'Almost there, '**
  String get almost_there;

  /// No description provided for @what_interest_you.
  ///
  /// In en, this message translates to:
  /// **'! What interests you in the district?'**
  String get what_interest_you;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @preparing_the_app_text.
  ///
  /// In en, this message translates to:
  /// **'I\'m now preparing the app for you.\nThis will take a moment.'**
  String get preparing_the_app_text;

  /// No description provided for @i_have_prepared_everything_text.
  ///
  /// In en, this message translates to:
  /// **'I\'ve prepared everything for you.\nHave fun!'**
  String get i_have_prepared_everything_text;

  /// No description provided for @continue_to_homepage.
  ///
  /// In en, this message translates to:
  /// **'Continue to the homepage'**
  String get continue_to_homepage;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @thanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks'**
  String get thanks;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @field_updated_message.
  ///
  /// In en, this message translates to:
  /// **'Field Updated Successfully'**
  String get field_updated_message;

  /// No description provided for @enter_name.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get enter_name;

  /// No description provided for @enter_username.
  ///
  /// In en, this message translates to:
  /// **'Enter Username'**
  String get enter_username;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enter_email;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @enter_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get enter_phone_number;

  /// No description provided for @enter_description.
  ///
  /// In en, this message translates to:
  /// **'Enter Description'**
  String get enter_description;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @enter_website.
  ///
  /// In en, this message translates to:
  /// **'Enter Website'**
  String get enter_website;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @please_select_the_field.
  ///
  /// In en, this message translates to:
  /// **'Please complete the form'**
  String get please_select_the_field;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @enter_title.
  ///
  /// In en, this message translates to:
  /// **'Enter Title'**
  String get enter_title;

  /// No description provided for @feedback_sent_successfully.
  ///
  /// In en, this message translates to:
  /// **'Feedback sent successfully'**
  String get feedback_sent_successfully;

  /// No description provided for @barrier_free.
  ///
  /// In en, this message translates to:
  /// **'Barrier-free'**
  String get barrier_free;

  /// No description provided for @dogs_allow.
  ///
  /// In en, this message translates to:
  /// **'Dogs allowed'**
  String get dogs_allow;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @weekend.
  ///
  /// In en, this message translates to:
  /// **'Weekend'**
  String get weekend;

  /// No description provided for @next_7_days.
  ///
  /// In en, this message translates to:
  /// **'Next 7 days'**
  String get next_7_days;

  /// No description provided for @next_30_days.
  ///
  /// In en, this message translates to:
  /// **'Next 30 days'**
  String get next_30_days;

  /// No description provided for @define_period.
  ///
  /// In en, this message translates to:
  /// **'Define period'**
  String get define_period;

  /// No description provided for @as_a_couple.
  ///
  /// In en, this message translates to:
  /// **'As a couple'**
  String get as_a_couple;

  /// No description provided for @with_children.
  ///
  /// In en, this message translates to:
  /// **'With children'**
  String get with_children;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @seniors.
  ///
  /// In en, this message translates to:
  /// **'Senior citizen'**
  String get seniors;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @select_start_date.
  ///
  /// In en, this message translates to:
  /// **'Select start date'**
  String get select_start_date;

  /// No description provided for @select_end_date.
  ///
  /// In en, this message translates to:
  /// **'Select end date'**
  String get select_end_date;

  /// No description provided for @please_select_start_and_end_date.
  ///
  /// In en, this message translates to:
  /// **'Please select start and end date'**
  String get please_select_start_and_end_date;

  /// No description provided for @today_its_going_to_be.
  ///
  /// In en, this message translates to:
  /// **'It’s going to be sunny today!'**
  String get today_its_going_to_be;

  /// No description provided for @virtual_town_hall.
  ///
  /// In en, this message translates to:
  /// **'Virtual Town Hall'**
  String get virtual_town_hall;

  /// No description provided for @my_town.
  ///
  /// In en, this message translates to:
  /// **'Hometown'**
  String get my_town;

  /// No description provided for @tourism_and_leisure.
  ///
  /// In en, this message translates to:
  /// **'Tourism and Leisure'**
  String get tourism_and_leisure;

  /// No description provided for @mobility.
  ///
  /// In en, this message translates to:
  /// **'Mobility'**
  String get mobility;

  /// No description provided for @get_involved.
  ///
  /// In en, this message translates to:
  /// **'GET INVOLVED'**
  String get get_involved;

  /// No description provided for @sunny.
  ///
  /// In en, this message translates to:
  /// **'Sunny'**
  String get sunny;

  /// No description provided for @find_out_how_to.
  ///
  /// In en, this message translates to:
  /// **'Find out how to get there here.'**
  String get find_out_how_to;

  /// No description provided for @read_more.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get read_more;

  /// No description provided for @places_of_the_community.
  ///
  /// In en, this message translates to:
  /// **'Places of the community'**
  String get places_of_the_community;

  /// No description provided for @show_all_locations.
  ///
  /// In en, this message translates to:
  /// **'Show all locations'**
  String get show_all_locations;

  /// No description provided for @all_news.
  ///
  /// In en, this message translates to:
  /// **'View all news'**
  String get all_news;

  /// No description provided for @municipality.
  ///
  /// In en, this message translates to:
  /// **'municipality'**
  String get municipality;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @visit_website.
  ///
  /// In en, this message translates to:
  /// **'Visit website'**
  String get visit_website;

  /// No description provided for @associated_municipalities.
  ///
  /// In en, this message translates to:
  /// **'Associated municipalities'**
  String get associated_municipalities;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @event_text.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get event_text;

  /// No description provided for @feedback_text.
  ///
  /// In en, this message translates to:
  /// **'I have read the privacy policy'**
  String get feedback_text;

  /// No description provided for @imprint_page.
  ///
  /// In en, this message translates to:
  /// **'Imprint Page'**
  String get imprint_page;

  /// No description provided for @terms_of_use.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get terms_of_use;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @view_ort.
  ///
  /// In en, this message translates to:
  /// **'View Ort'**
  String get view_ort;

  /// No description provided for @soon_service.
  ///
  /// In en, this message translates to:
  /// **'Soon service will be availbale'**
  String get soon_service;

  /// No description provided for @cities.
  ///
  /// In en, this message translates to:
  /// **'Cities'**
  String get cities;

  /// No description provided for @my_place.
  ///
  /// In en, this message translates to:
  /// **'Hometown'**
  String get my_place;

  /// No description provided for @show_all_places.
  ///
  /// In en, this message translates to:
  /// **'Show all places'**
  String get show_all_places;

  /// No description provided for @mein_ort_display_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the overview page for your places in the Kuseler Land – your guide to the places in the region.'**
  String get mein_ort_display_message;

  /// No description provided for @hiking_trails.
  ///
  /// In en, this message translates to:
  /// **'Hiking trails app'**
  String get hiking_trails;

  /// No description provided for @discover_kusel_on_foot.
  ///
  /// In en, this message translates to:
  /// **'Discover Kusel on foot'**
  String get discover_kusel_on_foot;

  /// No description provided for @our_offers.
  ///
  /// In en, this message translates to:
  /// **'Our offers'**
  String get our_offers;

  /// No description provided for @your_contact_persons.
  ///
  /// In en, this message translates to:
  /// **'Your contact persons'**
  String get your_contact_persons;

  /// No description provided for @participate.
  ///
  /// In en, this message translates to:
  /// **'Participate'**
  String get participate;

  /// No description provided for @register_here.
  ///
  /// In en, this message translates to:
  /// **'LogIn here'**
  String get register_here;

  /// No description provided for @develop_kusel_together_text.
  ///
  /// In en, this message translates to:
  /// **'We want to further develop the Kusel district together.'**
  String get develop_kusel_together_text;

  /// No description provided for @sunday_text.
  ///
  /// In en, this message translates to:
  /// **'Su'**
  String get sunday_text;

  /// No description provided for @monday_text.
  ///
  /// In en, this message translates to:
  /// **'Mo'**
  String get monday_text;

  /// No description provided for @tuesday_text.
  ///
  /// In en, this message translates to:
  /// **'Tu'**
  String get tuesday_text;

  /// No description provided for @wednesday_text.
  ///
  /// In en, this message translates to:
  /// **'We'**
  String get wednesday_text;

  /// No description provided for @thursday_text.
  ///
  /// In en, this message translates to:
  /// **'Th'**
  String get thursday_text;

  /// No description provided for @friday_text.
  ///
  /// In en, this message translates to:
  /// **'Fr'**
  String get friday_text;

  /// No description provided for @saturday_text.
  ///
  /// In en, this message translates to:
  /// **'Sa'**
  String get saturday_text;

  /// No description provided for @current_events.
  ///
  /// In en, this message translates to:
  /// **'Current Events'**
  String get current_events;

  /// No description provided for @accessible.
  ///
  /// In en, this message translates to:
  /// **'Accessible'**
  String get accessible;

  /// No description provided for @reachable_by_public_transport.
  ///
  /// In en, this message translates to:
  /// **'Reachable by public transport'**
  String get reachable_by_public_transport;

  /// No description provided for @free_of_charge.
  ///
  /// In en, this message translates to:
  /// **'Free of charge'**
  String get free_of_charge;

  /// No description provided for @bookable_online.
  ///
  /// In en, this message translates to:
  /// **'Bookable online'**
  String get bookable_online;

  /// No description provided for @open_air.
  ///
  /// In en, this message translates to:
  /// **'Open air'**
  String get open_air;

  /// No description provided for @card_payment_possible.
  ///
  /// In en, this message translates to:
  /// **'Card payment possible'**
  String get card_payment_possible;

  /// No description provided for @is_required.
  ///
  /// In en, this message translates to:
  /// **'is Required'**
  String get is_required;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @name_or_email.
  ///
  /// In en, this message translates to:
  /// **'Name or Email'**
  String get name_or_email;

  /// No description provided for @kusel.
  ///
  /// In en, this message translates to:
  /// **'Kusel'**
  String get kusel;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @favourite_places.
  ///
  /// In en, this message translates to:
  /// **'Favourite places'**
  String get favourite_places;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get delete_account;

  /// No description provided for @success_delete_account_message.
  ///
  /// In en, this message translates to:
  /// **'You account has been deleted successfully'**
  String get success_delete_account_message;

  /// No description provided for @edit_onboarding_details.
  ///
  /// In en, this message translates to:
  /// **'Edit User details'**
  String get edit_onboarding_details;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @delete_account_information.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get delete_account_information;

  /// No description provided for @digifit_parcours.
  ///
  /// In en, this message translates to:
  /// **'Digifit Parcours'**
  String get digifit_parcours;

  /// No description provided for @scan_exercise.
  ///
  /// In en, this message translates to:
  /// **'Scan exercise'**
  String get scan_exercise;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @trophies.
  ///
  /// In en, this message translates to:
  /// **'Trophies'**
  String get trophies;

  /// No description provided for @brain_teasers.
  ///
  /// In en, this message translates to:
  /// **'Brain Teasers'**
  String get brain_teasers;

  /// No description provided for @points_and_trophy.
  ///
  /// In en, this message translates to:
  /// **'Points & Trophies'**
  String get points_and_trophy;

  /// No description provided for @show_course.
  ///
  /// In en, this message translates to:
  /// **'Show course'**
  String get show_course;

  /// No description provided for @scan_the_qr_text.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code at the training station'**
  String get scan_the_qr_text;

  /// No description provided for @link_copy_to_clipboard.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get link_copy_to_clipboard;

  /// No description provided for @privacy_policy_error_msg.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Privacy Policy to continue.'**
  String get privacy_policy_error_msg;

  /// No description provided for @digifit.
  ///
  /// In en, this message translates to:
  /// **'Digifit'**
  String get digifit;

  /// No description provided for @closes_at.
  ///
  /// In en, this message translates to:
  /// **'Closes at'**
  String get closes_at;

  /// No description provided for @clock.
  ///
  /// In en, this message translates to:
  /// **'Clock'**
  String get clock;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @people_with_disabilities.
  ///
  /// In en, this message translates to:
  /// **'People with disabilities'**
  String get people_with_disabilities;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @digifit_open_exercise.
  ///
  /// In en, this message translates to:
  /// **'Open exercise'**
  String get digifit_open_exercise;

  /// No description provided for @digifit_completed_exercise.
  ///
  /// In en, this message translates to:
  /// **'Completed exercise'**
  String get digifit_completed_exercise;

  /// No description provided for @digifit_recommended_exercise.
  ///
  /// In en, this message translates to:
  /// **' Recommended:'**
  String get digifit_recommended_exercise;

  /// No description provided for @digifit_exercise_set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get digifit_exercise_set;

  /// No description provided for @digifit_exercise_reps.
  ///
  /// In en, this message translates to:
  /// **'Reps.'**
  String get digifit_exercise_reps;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @validation_falied_message.
  ///
  /// In en, this message translates to:
  /// **'Invalid scan. Unable to start session.'**
  String get validation_falied_message;

  /// No description provided for @session_start.
  ///
  /// In en, this message translates to:
  /// **'Session has been started'**
  String get session_start;

  /// No description provided for @goal_achieved.
  ///
  /// In en, this message translates to:
  /// **'Goal has already been achieved'**
  String get goal_achieved;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @digifit_success_card_title.
  ///
  /// In en, this message translates to:
  /// **'Great perseverance!'**
  String get digifit_success_card_title;

  /// No description provided for @digifit_success_card_desp.
  ///
  /// In en, this message translates to:
  /// **'Now complete the exercise to collect your points.'**
  String get digifit_success_card_desp;

  /// No description provided for @digifit_abort.
  ///
  /// In en, this message translates to:
  /// **'Abort'**
  String get digifit_abort;

  /// No description provided for @digifit_abort_exercise_title.
  ///
  /// In en, this message translates to:
  /// **'Abort Exercise?'**
  String get digifit_abort_exercise_title;

  /// No description provided for @digifit_abort_exercise_desp.
  ///
  /// In en, this message translates to:
  /// **'The current exercise is not yet completed. Do you really want to abort and go back?'**
  String get digifit_abort_exercise_desp;

  /// No description provided for @digifit_latest_trophies.
  ///
  /// In en, this message translates to:
  /// **'Latest trophies'**
  String get digifit_latest_trophies;

  /// No description provided for @digifit_all_trophies.
  ///
  /// In en, this message translates to:
  /// **'All trophies'**
  String get digifit_all_trophies;

  /// No description provided for @digifit_trophies_received.
  ///
  /// In en, this message translates to:
  /// **'Trophies received'**
  String get digifit_trophies_received;

  /// No description provided for @digifit_trophies_load_more.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get digifit_trophies_load_more;

  /// No description provided for @digifit_trophies_show_less.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get digifit_trophies_show_less;

  /// No description provided for @digifit_trophies_open.
  ///
  /// In en, this message translates to:
  /// **'open'**
  String get digifit_trophies_open;

  /// No description provided for @digifit_exercise_details_open_station.
  ///
  /// In en, this message translates to:
  /// **'Open stations in the course'**
  String get digifit_exercise_details_open_station;

  /// No description provided for @digifit_exercise_details_start_session.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get digifit_exercise_details_start_session;

  /// No description provided for @location_map_news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get location_map_news;

  /// No description provided for @location_map_events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get location_map_events;

  /// No description provided for @location_map_clubs.
  ///
  /// In en, this message translates to:
  /// **'Clubs'**
  String get location_map_clubs;

  /// No description provided for @location_map_regional_products.
  ///
  /// In en, this message translates to:
  /// **'Regional Products'**
  String get location_map_regional_products;

  /// No description provided for @location_map_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get location_map_search;

  /// No description provided for @location_map_new_citizen.
  ///
  /// In en, this message translates to:
  /// **'New citizen info'**
  String get location_map_new_citizen;

  /// No description provided for @location_map_lost_and_found.
  ///
  /// In en, this message translates to:
  /// **'Lost and Found'**
  String get location_map_lost_and_found;

  /// No description provided for @location_map_company_portraits.
  ///
  /// In en, this message translates to:
  /// **'Company portraits'**
  String get location_map_company_portraits;

  /// No description provided for @location_map_transport.
  ///
  /// In en, this message translates to:
  /// **'Carpooling'**
  String get location_map_transport;

  /// No description provided for @location_map_offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get location_map_offers;

  /// No description provided for @location_map_eat_drink.
  ///
  /// In en, this message translates to:
  /// **'Eat or Drink'**
  String get location_map_eat_drink;

  /// No description provided for @location_map_free_time.
  ///
  /// In en, this message translates to:
  /// **'Freetime and Tourism'**
  String get location_map_free_time;

  /// No description provided for @location_map_highlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get location_map_highlights;

  /// No description provided for @location_map_poi.
  ///
  /// In en, this message translates to:
  /// **'POI'**
  String get location_map_poi;

  /// No description provided for @mobility_centre.
  ///
  /// In en, this message translates to:
  /// **'Mobility centre'**
  String get mobility_centre;

  /// No description provided for @home_screen_today_event.
  ///
  /// In en, this message translates to:
  /// **'Today\'s events'**
  String get home_screen_today_event;

  /// No description provided for @brain_teasers_list_title.
  ///
  /// In en, this message translates to:
  /// **'Brain teasers'**
  String get brain_teasers_list_title;

  /// No description provided for @show_all_events.
  ///
  /// In en, this message translates to:
  /// **'Show all events'**
  String get show_all_events;

  /// No description provided for @events_in_your_area.
  ///
  /// In en, this message translates to:
  /// **'Events in your area'**
  String get events_in_your_area;

  /// No description provided for @new_municipality.
  ///
  /// In en, this message translates to:
  /// **'Collective municipality'**
  String get new_municipality;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @location_and_distance.
  ///
  /// In en, this message translates to:
  /// **'Location and distance'**
  String get location_and_distance;

  /// No description provided for @location_distance.
  ///
  /// In en, this message translates to:
  /// **'Location/Distance'**
  String get location_distance;

  /// No description provided for @maximum_characters.
  ///
  /// In en, this message translates to:
  /// **'Maximum 300 characters allowed.'**
  String get maximum_characters;

  /// No description provided for @regarding.
  ///
  /// In en, this message translates to:
  /// **'Regarding'**
  String get regarding;

  /// No description provided for @feedback_about_app.
  ///
  /// In en, this message translates to:
  /// **'Feedback about app'**
  String get feedback_about_app;

  /// No description provided for @infrastructure_and_public_space.
  ///
  /// In en, this message translates to:
  /// **'Infrastructure & Public Space'**
  String get infrastructure_and_public_space;

  /// No description provided for @transportation_and_mobility.
  ///
  /// In en, this message translates to:
  /// **'Transport & Mobility'**
  String get transportation_and_mobility;

  /// No description provided for @cleanliness_and_environment.
  ///
  /// In en, this message translates to:
  /// **'Cleanliness & Environment'**
  String get cleanliness_and_environment;

  /// No description provided for @digital_services_and_app_functionality.
  ///
  /// In en, this message translates to:
  /// **'Digital Services & App Functionality'**
  String get digital_services_and_app_functionality;

  /// No description provided for @disruptions_and_damage.
  ///
  /// In en, this message translates to:
  /// **'Disruptions & Damage'**
  String get disruptions_and_damage;

  /// No description provided for @citizen_services_and_administration.
  ///
  /// In en, this message translates to:
  /// **'Citizen Services & Administration'**
  String get citizen_services_and_administration;

  /// No description provided for @general_feedback.
  ///
  /// In en, this message translates to:
  /// **'General Feedback'**
  String get general_feedback;

  /// No description provided for @games_stamps_desc.
  ///
  /// In en, this message translates to:
  /// **'You can collect these stamps here'**
  String get games_stamps_desc;

  /// No description provided for @stamps_achievements.
  ///
  /// In en, this message translates to:
  /// **'My achievements'**
  String get stamps_achievements;

  /// No description provided for @choose_level.
  ///
  /// In en, this message translates to:
  /// **'Choose a level'**
  String get choose_level;

  /// No description provided for @more_games.
  ///
  /// In en, this message translates to:
  /// **'More games'**
  String get more_games;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get try_again;

  /// No description provided for @abort_game.
  ///
  /// In en, this message translates to:
  /// **'Abort BoldiFinder Game?'**
  String get abort_game;

  /// No description provided for @abort_game_desc.
  ///
  /// In en, this message translates to:
  /// **'The current Game is not yet completed. Do you really want to abort and go back?'**
  String get abort_game_desc;

  /// No description provided for @level_complete.
  ///
  /// In en, this message translates to:
  /// **'Level Complete!'**
  String get level_complete;

  /// No description provided for @level_complete_desc.
  ///
  /// In en, this message translates to:
  /// **'To start the next level, please click OK to go back.'**
  String get level_complete_desc;

  /// No description provided for @all_level_complete.
  ///
  /// In en, this message translates to:
  /// **'All level\'s are completed, please click OK to go back.'**
  String get all_level_complete;

  /// No description provided for @successful_game_title.
  ///
  /// In en, this message translates to:
  /// **'Super!'**
  String get successful_game_title;

  /// No description provided for @successful_game_desc_for_level_1.
  ///
  /// In en, this message translates to:
  /// **'Are you ready for Level 2?'**
  String get successful_game_desc_for_level_1;

  /// No description provided for @successful_game_desc_for_level_2.
  ///
  /// In en, this message translates to:
  /// **'Are you ready for Level 3?'**
  String get successful_game_desc_for_level_2;

  /// No description provided for @successful_game_desc_for_level_3.
  ///
  /// In en, this message translates to:
  /// **'All Level\'s are completed'**
  String get successful_game_desc_for_level_3;

  /// No description provided for @error_game_title.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately wrong'**
  String get error_game_title;

  /// No description provided for @error_game_des.
  ///
  /// In en, this message translates to:
  /// **'Try again right away!'**
  String get error_game_des;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @profile_setting.
  ///
  /// In en, this message translates to:
  /// **'Profile Setting'**
  String get profile_setting;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @confirm_new_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirm_new_password;

  /// No description provided for @at_least_8_character.
  ///
  /// In en, this message translates to:
  /// **'at least 8 characters'**
  String get at_least_8_character;

  /// No description provided for @contains_letters_and_numbers.
  ///
  /// In en, this message translates to:
  /// **'contain letters and numbers'**
  String get contains_letters_and_numbers;

  /// No description provided for @contains_upper_case_and_lower_case.
  ///
  /// In en, this message translates to:
  /// **'contains uppercase and lowercase'**
  String get contains_upper_case_and_lower_case;

  /// No description provided for @contains_special_character.
  ///
  /// In en, this message translates to:
  /// **'contains special character'**
  String get contains_special_character;

  /// No description provided for @current_password.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get current_password;

  /// No description provided for @update_password.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get update_password;

  /// No description provided for @field_cannot_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Field cannot be empty'**
  String get field_cannot_be_empty;

  /// No description provided for @password_is_not_same_as_new_password.
  ///
  /// In en, this message translates to:
  /// **'Password is not same as new password'**
  String get password_is_not_same_as_new_password;

  /// No description provided for @reset_password_success.
  ///
  /// In en, this message translates to:
  /// **'Password has been successfully reset'**
  String get reset_password_success;

  /// No description provided for @abort_math_hunt_game.
  ///
  /// In en, this message translates to:
  /// **'Abort MathHunt Game?'**
  String get abort_math_hunt_game;

  /// No description provided for @math_hunt_game_desc.
  ///
  /// In en, this message translates to:
  /// **'Ready for some mental arithmetic?'**
  String get math_hunt_game_desc;

  /// No description provided for @flip_catch_desc.
  ///
  /// In en, this message translates to:
  /// **'Ready for Flip Catch?'**
  String get flip_catch_desc;

  /// No description provided for @abort_flip_catch.
  ///
  /// In en, this message translates to:
  /// **'Abort Flip Catch?'**
  String get abort_flip_catch;

  /// No description provided for @my_profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get my_profile;

  /// No description provided for @my_fav.
  ///
  /// In en, this message translates to:
  /// **'My favorites'**
  String get my_fav;

  /// No description provided for @rubber_stamp.
  ///
  /// In en, this message translates to:
  /// **'Rubber Stamp'**
  String get rubber_stamp;

  /// No description provided for @treasure_pass.
  ///
  /// In en, this message translates to:
  /// **'Treasure pass'**
  String get treasure_pass;

  /// No description provided for @data_protection_information.
  ///
  /// In en, this message translates to:
  /// **'Data Protection'**
  String get data_protection_information;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'App-Version'**
  String get app_version;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @edit_interest_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit interest profile'**
  String get edit_interest_profile;

  /// No description provided for @location_sharing.
  ///
  /// In en, this message translates to:
  /// **'Location sharing'**
  String get location_sharing;

  /// No description provided for @an.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get an;

  /// No description provided for @digit_dash_game_desc.
  ///
  /// In en, this message translates to:
  /// **'Ready for DigitDash?'**
  String get digit_dash_game_desc;

  /// No description provided for @abort_digit_dash.
  ///
  /// In en, this message translates to:
  /// **'Abort Digit Dash?'**
  String get abort_digit_dash;

  /// No description provided for @digit_dash_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'note'**
  String get digit_dash_dialog_title;

  /// No description provided for @digit_dash_dialog_forbidden_desc.
  ///
  /// In en, this message translates to:
  /// **'The following numbers are forbidden! You must NOT touch them, but skip them. Remember them well!'**
  String get digit_dash_dialog_forbidden_desc;

  /// No description provided for @digit_dash_dialog_target_desc_odd.
  ///
  /// In en, this message translates to:
  /// **'Only tap the ODD numbers in order!'**
  String get digit_dash_dialog_target_desc_odd;

  /// No description provided for @digit_dash_dialog_target_desc_even.
  ///
  /// In en, this message translates to:
  /// **'Only tap the EVEN numbers in order!'**
  String get digit_dash_dialog_target_desc_even;

  /// No description provided for @understood.
  ///
  /// In en, this message translates to:
  /// **'understood'**
  String get understood;

  /// No description provided for @odd_blue.
  ///
  /// In en, this message translates to:
  /// **'ODD_BLUE'**
  String get odd_blue;

  /// No description provided for @even_red.
  ///
  /// In en, this message translates to:
  /// **'EVEN_RED'**
  String get even_red;

  /// No description provided for @select_image.
  ///
  /// In en, this message translates to:
  /// **'Select Missing Image'**
  String get select_image;

  /// No description provided for @abort_pictures_game.
  ///
  /// In en, this message translates to:
  /// **'Abort Picture\'s Game'**
  String get abort_pictures_game;

  /// No description provided for @details_scanner.
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get details_scanner;

  /// No description provided for @correct_answer.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct_answer;

  /// No description provided for @wrong_answer.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get wrong_answer;

  /// No description provided for @digifit_completed_top.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get digifit_completed_top;

  /// No description provided for @feedback_message.
  ///
  /// In en, this message translates to:
  /// **'message'**
  String get feedback_message;

  /// No description provided for @name_char_validation_msg.
  ///
  /// In en, this message translates to:
  /// **'Only alphabets and single spaces are allowed'**
  String get name_char_validation_msg;

  /// No description provided for @name_char_allowed_msg.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters long'**
  String get name_char_allowed_msg;

  /// No description provided for @feedback_setting.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback_setting;

  /// No description provided for @all_events_filter.
  ///
  /// In en, this message translates to:
  /// **'All events'**
  String get all_events_filter;

  /// No description provided for @our_recommendations.
  ///
  /// In en, this message translates to:
  /// **'Our Recommendations'**
  String get our_recommendations;

  /// No description provided for @digifit_end_game.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get digifit_end_game;

  /// No description provided for @digifit_end_exercise.
  ///
  /// In en, this message translates to:
  /// **'Quit exercise'**
  String get digifit_end_exercise;

  /// No description provided for @digifit_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get digifit_continue;

  /// No description provided for @digift_continue_exercise.
  ///
  /// In en, this message translates to:
  /// **'Continue exercise'**
  String get digift_continue_exercise;

  /// No description provided for @confirm_selection.
  ///
  /// In en, this message translates to:
  /// **'Confirm selection'**
  String get confirm_selection;

  /// No description provided for @selected_text.
  ///
  /// In en, this message translates to:
  /// **'Selected text:'**
  String get selected_text;

  /// No description provided for @selected_desc.
  ///
  /// In en, this message translates to:
  /// **'Is this the word you want to select?'**
  String get selected_desc;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @game_start_at.
  ///
  /// In en, this message translates to:
  /// **'The game starts at:'**
  String get game_start_at;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
