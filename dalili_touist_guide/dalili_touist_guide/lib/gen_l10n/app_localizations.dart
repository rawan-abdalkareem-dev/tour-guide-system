import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
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
/// import 'gen_l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Tourist Guide'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Discover Syria\'s Landmarks'**
  String get appTagline;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Syria'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover the most beautiful tourist landmarks, restaurants, and historic places'**
  String get welcomeSubtitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View More'**
  String get viewMore;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

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

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get bookings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support & Help'**
  String get support;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @guestLogin.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get guestLogin;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully'**
  String get loginSuccess;

  /// No description provided for @signupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get signupSuccess;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get logoutSuccess;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search for places, cities...'**
  String get searchPlaceholder;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @popularPlaces.
  ///
  /// In en, this message translates to:
  /// **'Popular Landmarks'**
  String get popularPlaces;

  /// No description provided for @recommendedPlaces.
  ///
  /// In en, this message translates to:
  /// **'Recommended Places'**
  String get recommendedPlaces;

  /// No description provided for @allPlaces.
  ///
  /// In en, this message translates to:
  /// **'All Landmarks'**
  String get allPlaces;

  /// No description provided for @historicalPlaces.
  ///
  /// In en, this message translates to:
  /// **'Historical Places'**
  String get historicalPlaces;

  /// No description provided for @naturePlaces.
  ///
  /// In en, this message translates to:
  /// **'Nature & Parks'**
  String get naturePlaces;

  /// No description provided for @religiousPlaces.
  ///
  /// In en, this message translates to:
  /// **'Religious Landmarks'**
  String get religiousPlaces;

  /// No description provided for @foodPlaces.
  ///
  /// In en, this message translates to:
  /// **'Restaurants & Cafes'**
  String get foodPlaces;

  /// No description provided for @noPlacesFound.
  ///
  /// In en, this message translates to:
  /// **'No places found'**
  String get noPlacesFound;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @openNow.
  ///
  /// In en, this message translates to:
  /// **'Open Now'**
  String get openNow;

  /// No description provided for @closedNow.
  ///
  /// In en, this message translates to:
  /// **'Closed Now'**
  String get closedNow;

  /// No description provided for @aboutPlace.
  ///
  /// In en, this message translates to:
  /// **'About this place'**
  String get aboutPlace;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @openingHours.
  ///
  /// In en, this message translates to:
  /// **'Opening Hours'**
  String get openingHours;

  /// No description provided for @ticketPrice.
  ///
  /// In en, this message translates to:
  /// **'Ticket Price'**
  String get ticketPrice;

  /// No description provided for @freeEntry.
  ///
  /// In en, this message translates to:
  /// **'Free Entry'**
  String get freeEntry;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// No description provided for @addedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// No description provided for @removedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @newBooking.
  ///
  /// In en, this message translates to:
  /// **'New Reservation'**
  String get newBooking;

  /// No description provided for @bookVisit.
  ///
  /// In en, this message translates to:
  /// **'Book a Visit'**
  String get bookVisit;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @bookingDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get bookingDate;

  /// No description provided for @bookingTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get bookingTime;

  /// No description provided for @numberOfVisitors.
  ///
  /// In en, this message translates to:
  /// **'Number of Visitors'**
  String get numberOfVisitors;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Special Notes'**
  String get notes;

  /// No description provided for @bookingStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get bookingStatus;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel Booking'**
  String get cancelBooking;

  /// No description provided for @cancelBookingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this booking?'**
  String get cancelBookingConfirm;

  /// No description provided for @bookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking submitted successfully!'**
  String get bookingSuccess;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking has been cancelled'**
  String get bookingCancelled;

  /// No description provided for @noBookingsFound.
  ///
  /// In en, this message translates to:
  /// **'No bookings found'**
  String get noBookingsFound;

  /// No description provided for @settingsAndPreferences.
  ///
  /// In en, this message translates to:
  /// **'Settings & Preferences'**
  String get settingsAndPreferences;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'All settings saved successfully ✅'**
  String get settingsSaved;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose preferred interface language'**
  String get languageSubtitle;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @fontSizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control overall app font scale'**
  String get fontSizeSubtitle;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get vibration;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationsDisabled;

  /// No description provided for @vibrationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback enabled'**
  String get vibrationEnabled;

  /// No description provided for @vibrationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback disabled'**
  String get vibrationDisabled;

  /// No description provided for @fontSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get fontSizeSmall;

  /// No description provided for @fontSizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get fontSizeMedium;

  /// No description provided for @fontSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get fontSizeLarge;

  /// No description provided for @resetDefaults.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings to Default'**
  String get resetDefaults;

  /// No description provided for @resetDefaultsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all settings to defaults?'**
  String get resetDefaultsConfirm;

  /// No description provided for @resetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Settings reset to defaults 🔄'**
  String get resetSuccess;

  /// No description provided for @mapType.
  ///
  /// In en, this message translates to:
  /// **'Map Type'**
  String get mapType;

  /// No description provided for @mapTypeNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal (Streets & Cities)'**
  String get mapTypeNormal;

  /// No description provided for @mapTypeSatellite.
  ///
  /// In en, this message translates to:
  /// **'Satellite (Nature)'**
  String get mapTypeSatellite;

  /// No description provided for @mapTypeTerrain.
  ///
  /// In en, this message translates to:
  /// **'Terrain (Mountains & Plains)'**
  String get mapTypeTerrain;

  /// No description provided for @mapTypeHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid (Satellite + Streets)'**
  String get mapTypeHybrid;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About Tourist Guide'**
  String get aboutApp;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faq;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @feedbackSent.
  ///
  /// In en, this message translates to:
  /// **'Feedback sent successfully'**
  String get feedbackSent;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @adminBookings.
  ///
  /// In en, this message translates to:
  /// **'Manage Bookings'**
  String get adminBookings;

  /// No description provided for @adminPlaces.
  ///
  /// In en, this message translates to:
  /// **'Manage Places'**
  String get adminPlaces;

  /// No description provided for @adminCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get adminCategories;

  /// No description provided for @adminOnly.
  ///
  /// In en, this message translates to:
  /// **'This section is restricted to administrators'**
  String get adminOnly;

  /// No description provided for @totalPlaces.
  ///
  /// In en, this message translates to:
  /// **'Total Places'**
  String get totalPlaces;

  /// No description provided for @totalBookings.
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get totalBookings;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @clientPreviewMode.
  ///
  /// In en, this message translates to:
  /// **'Client Preview Mode'**
  String get clientPreviewMode;

  /// No description provided for @guideText.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get guideText;

  /// No description provided for @discoverPlaces.
  ///
  /// In en, this message translates to:
  /// **'Discover Places'**
  String get discoverPlaces;

  /// No description provided for @makeMemories.
  ///
  /// In en, this message translates to:
  /// **'Make Unforgettable Memories'**
  String get makeMemories;

  /// No description provided for @startExploring.
  ///
  /// In en, this message translates to:
  /// **'Start Exploring'**
  String get startExploring;

  /// No description provided for @changeBackground.
  ///
  /// In en, this message translates to:
  /// **'Change Background'**
  String get changeBackground;

  /// No description provided for @noFavoritePlaces.
  ///
  /// In en, this message translates to:
  /// **'No favorite places yet'**
  String get noFavoritePlaces;

  /// No description provided for @addFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add places to your favorites from the home screen'**
  String get addFavoritesSubtitle;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @noCategoryPlaces.
  ///
  /// In en, this message translates to:
  /// **'No places in this category'**
  String get noCategoryPlaces;

  /// No description provided for @moreComingSoon.
  ///
  /// In en, this message translates to:
  /// **'More will be added soon'**
  String get moreComingSoon;

  /// No description provided for @phoneNumberNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'No phone number available for this place'**
  String get phoneNumberNotAvailable;

  /// No description provided for @cannotCallNumber.
  ///
  /// In en, this message translates to:
  /// **'Cannot call this number'**
  String get cannotCallNumber;

  /// No description provided for @cannotOpenMap.
  ///
  /// In en, this message translates to:
  /// **'Cannot open map'**
  String get cannotOpenMap;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied! You can paste it anywhere'**
  String get linkCopied;

  /// No description provided for @shareError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while sharing'**
  String get shareError;

  /// No description provided for @sharePlace.
  ///
  /// In en, this message translates to:
  /// **'Share Place'**
  String get sharePlace;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy Link'**
  String get copyLink;

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Discover more services and features'**
  String get aboutAppDescription;

  /// No description provided for @customizeApp.
  ///
  /// In en, this message translates to:
  /// **'Customize app to your liking'**
  String get customizeApp;

  /// No description provided for @aboutAppTitle.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutAppTitle;

  /// No description provided for @aboutAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn about the app and its version'**
  String get aboutAppSubtitle;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @shareAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share the app with your friends'**
  String get shareAppSubtitle;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @rateAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your experience with 5 stars ⭐'**
  String get rateAppSubtitle;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'View privacy policy'**
  String get privacyPolicySubtitle;

  /// No description provided for @termsOfServiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View terms of service'**
  String get termsOfServiceSubtitle;

  /// No description provided for @changeAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get changeAppLanguage;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @releaseDate.
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get releaseDate;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @syria.
  ///
  /// In en, this message translates to:
  /// **'Syria'**
  String get syria;

  /// No description provided for @teamDalili.
  ///
  /// In en, this message translates to:
  /// **'Dalili Team'**
  String get teamDalili;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @manageAccountAndSettings.
  ///
  /// In en, this message translates to:
  /// **'Manage your account and settings'**
  String get manageAccountAndSettings;

  /// No description provided for @quickStats.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get quickStats;

  /// No description provided for @myAccountHeader.
  ///
  /// In en, this message translates to:
  /// **'My Personal Account'**
  String get myAccountHeader;

  /// No description provided for @appSettingsHeader.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettingsHeader;

  /// No description provided for @generalHeader.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalHeader;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @infoCopied.
  ///
  /// In en, this message translates to:
  /// **'Place details copied to clipboard!'**
  String get infoCopied;

  /// No description provided for @pasteAnywhere.
  ///
  /// In en, this message translates to:
  /// **'You can paste it in any app'**
  String get pasteAnywhere;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @mapLocationHelp.
  ///
  /// In en, this message translates to:
  /// **'Tap to view location on map'**
  String get mapLocationHelp;

  /// No description provided for @mapLabel.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapLabel;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @bookingsListRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Bookings list refreshed'**
  String get bookingsListRefreshed;

  /// No description provided for @noBookingsSection.
  ///
  /// In en, this message translates to:
  /// **'No bookings in this section'**
  String get noBookingsSection;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location:'**
  String get locationLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get dateLabel;

  /// No description provided for @peopleLabel.
  ///
  /// In en, this message translates to:
  /// **'people'**
  String get peopleLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email:'**
  String get emailLabel;

  /// No description provided for @clientUidLabel.
  ///
  /// In en, this message translates to:
  /// **'Client ID:'**
  String get clientUidLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone:'**
  String get phoneLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes:'**
  String get notesLabel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount:'**
  String get amountLabel;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get currencySymbol;

  /// No description provided for @bookingConfirmedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed successfully'**
  String get bookingConfirmedSuccess;

  /// No description provided for @markCompleted.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get markCompleted;

  /// No description provided for @bookingCompletedInfo.
  ///
  /// In en, this message translates to:
  /// **'Booking marked as completed'**
  String get bookingCompletedInfo;

  /// No description provided for @bookingCancelledInfo.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled'**
  String get bookingCancelledInfo;

  /// No description provided for @loginToBook.
  ///
  /// In en, this message translates to:
  /// **'Please log in to book'**
  String get loginToBook;

  /// No description provided for @bookingFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Book a Visit'**
  String get bookingFormTitle;

  /// No description provided for @visitorName.
  ///
  /// In en, this message translates to:
  /// **'Visitor Name'**
  String get visitorName;

  /// No description provided for @visitorPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get visitorPhone;

  /// No description provided for @visitDate.
  ///
  /// In en, this message translates to:
  /// **'Visit Date'**
  String get visitDate;

  /// No description provided for @visitTime.
  ///
  /// In en, this message translates to:
  /// **'Visit Time'**
  String get visitTime;

  /// No description provided for @numberOfPeople.
  ///
  /// In en, this message translates to:
  /// **'Number of People'**
  String get numberOfPeople;

  /// No description provided for @notesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Any special requests or notes...'**
  String get notesPlaceholder;

  /// No description provided for @submitBooking.
  ///
  /// In en, this message translates to:
  /// **'Submit Booking'**
  String get submitBooking;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Interactive Map'**
  String get mapTitle;

  /// No description provided for @searchMapPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search on map...'**
  String get searchMapPlaceholder;

  /// No description provided for @supportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get supportTitle;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get howCanWeHelp;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faqTitle;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Control Panel'**
  String get adminDashboardTitle;

  /// No description provided for @managePlacesTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Places'**
  String get managePlacesTitle;

  /// No description provided for @manageCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get manageCategoriesTitle;

  /// No description provided for @addPlace.
  ///
  /// In en, this message translates to:
  /// **'Add Place'**
  String get addPlace;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @placeName.
  ///
  /// In en, this message translates to:
  /// **'Place Name'**
  String get placeName;

  /// No description provided for @placeCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get placeCategory;

  /// No description provided for @placeCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get placeCity;

  /// No description provided for @imageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// No description provided for @placeDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get placeDescription;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @placeAdded.
  ///
  /// In en, this message translates to:
  /// **'Place added successfully'**
  String get placeAdded;

  /// No description provided for @placeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Place updated successfully'**
  String get placeUpdated;

  /// No description provided for @placeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Place deleted successfully'**
  String get placeDeleted;

  /// No description provided for @deletePlaceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this place?'**
  String get deletePlaceConfirm;

  /// No description provided for @categoryAdded.
  ///
  /// In en, this message translates to:
  /// **'Category added successfully'**
  String get categoryAdded;

  /// No description provided for @categoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Category deleted successfully'**
  String get categoryDeleted;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @loginSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to enjoy all app features'**
  String get loginSubTitle;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join us and start discovering Syria'**
  String get createAccountSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings & Preferences'**
  String get settingsTitle;

  /// No description provided for @saveSettingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save settings'**
  String get saveSettingsTooltip;

  /// No description provided for @appPreferencesSection.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferencesSection;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable dark theme for app screens'**
  String get darkModeSubtitle;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications & Alerts'**
  String get notificationsTitle;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive alerts about new landmarks and tour offers'**
  String get notificationsSubtitle;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Geographic Location'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow app to access location to show nearest landmarks'**
  String get locationPermissionSubtitle;

  /// No description provided for @vibrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback on button clicks'**
  String get vibrationSubtitle;

  /// No description provided for @mapTypeSection.
  ///
  /// In en, this message translates to:
  /// **'Map Style'**
  String get mapTypeSection;

  /// No description provided for @mapTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Map Type'**
  String get mapTypeTitle;

  /// No description provided for @mapTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Geographic style used in landmarks map'**
  String get mapTypeSubtitle;

  /// No description provided for @fontSizeSection.
  ///
  /// In en, this message translates to:
  /// **'Font Size & Scaling'**
  String get fontSizeSection;

  /// No description provided for @dataManagementSection.
  ///
  /// In en, this message translates to:
  /// **'Data Management & Sync'**
  String get dataManagementSection;

  /// No description provided for @autoSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto Save & Instant Sync'**
  String get autoSaveTitle;

  /// No description provided for @autoSaveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Instant save of bookings and favorites locally'**
  String get autoSaveSubtitle;

  /// No description provided for @clearFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Favorites'**
  String get clearFavoritesTitle;

  /// No description provided for @clearFavoritesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all saved landmarks from favorites'**
  String get clearFavoritesSubtitle;

  /// No description provided for @clearBadge.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearBadge;

  /// No description provided for @offlineDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline Data Readiness'**
  String get offlineDataTitle;

  /// No description provided for @offlineDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check local storage of landmarks and categories'**
  String get offlineDataSubtitle;

  /// No description provided for @checkBadge.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get checkBadge;

  /// No description provided for @cleanCacheTitle.
  ///
  /// In en, this message translates to:
  /// **'Clean Cache & Memory'**
  String get cleanCacheTitle;

  /// No description provided for @cleanCacheSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clear cached images to boost app performance'**
  String get cleanCacheSubtitle;

  /// No description provided for @cleanBadge.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get cleanBadge;

  /// No description provided for @aboutAndSupportSection.
  ///
  /// In en, this message translates to:
  /// **'About App & Help'**
  String get aboutAndSupportSection;

  /// No description provided for @appVersionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'1.0.0 — Syrian Tourist Edition 🇸🇾'**
  String get appVersionSubtitle;

  /// No description provided for @privacyTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Terms of Use'**
  String get privacyTermsTitle;

  /// No description provided for @privacyTermsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'User safety policies and terms of service'**
  String get privacyTermsSubtitle;

  /// No description provided for @rateAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate App on Store'**
  String get rateAppTitle;

  /// No description provided for @supportContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Help Center & Support'**
  String get supportContactTitle;

  /// No description provided for @supportContactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Direct contact with Syria tourist guide team'**
  String get supportContactSubtitle;

  /// No description provided for @adminPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin System Panel'**
  String get adminPanelTitle;

  /// No description provided for @adminPanelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bookings management, places CRUD, and analytics'**
  String get adminPanelSubtitle;

  /// No description provided for @manageBadge.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manageBadge;

  /// No description provided for @resetAllSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset All Settings'**
  String get resetAllSettingsTitle;

  /// No description provided for @resetAllSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore default theme, font size, notifications, and options'**
  String get resetAllSettingsSubtitle;

  /// No description provided for @resetBadge.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetBadge;

  /// No description provided for @clearFavoritesConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Favorites List'**
  String get clearFavoritesConfirmTitle;

  /// No description provided for @clearFavoritesConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all landmarks from your favorites list?'**
  String get clearFavoritesConfirmMessage;

  /// No description provided for @favoritesClearedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Favorites cleared successfully 🗑️'**
  String get favoritesClearedSuccess;

  /// No description provided for @noFavoritesToClear.
  ///
  /// In en, this message translates to:
  /// **'Favorites list is already empty'**
  String get noFavoritesToClear;

  /// No description provided for @offlineDataStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline Data Status'**
  String get offlineDataStatusTitle;

  /// No description provided for @offlineDataReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'All places and categories are loaded and ready offline ✅'**
  String get offlineDataReadyMessage;

  /// No description provided for @cacheCleanedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Image cache cleared successfully! Performance boosted 🚀'**
  String get cacheCleanedSuccess;

  /// No description provided for @resetConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings Confirmation'**
  String get resetConfirmTitle;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @myFavoritesCount.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get myFavoritesCount;

  /// No description provided for @myBookingsCount.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get myBookingsCount;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active User'**
  String get statusActive;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile Information'**
  String get editProfileTitle;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name, email, and phone number'**
  String get editProfileSubtitle;

  /// No description provided for @notificationsSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control alerts and sounds'**
  String get notificationsSettingsSubtitle;

  /// No description provided for @themeSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dark mode and display options'**
  String get themeSettingsSubtitle;

  /// No description provided for @supportSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get support and FAQ'**
  String get supportSettingsSubtitle;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout Confirmation'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get logoutConfirmMessage;

  /// No description provided for @fontSizeCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Font Size & Scaling'**
  String get fontSizeCardTitle;

  /// No description provided for @fontSizeCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scale font size across all app screens'**
  String get fontSizeCardSubtitle;

  /// No description provided for @livePreviewText.
  ///
  /// In en, this message translates to:
  /// **'Live Preview: Your comprehensive guide to Syrian landmarks 🇸🇾'**
  String get livePreviewText;

  /// No description provided for @devTeam.
  ///
  /// In en, this message translates to:
  /// **'Development Team'**
  String get devTeam;

  /// No description provided for @devTeamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tourist Guide — Smart Tourism Experience'**
  String get devTeamSubtitle;

  /// No description provided for @readPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to read local privacy commitments'**
  String get readPrivacySubtitle;

  /// No description provided for @readTermsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to view terms of service'**
  String get readTermsSubtitle;

  /// No description provided for @rateAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Share your rating to help us improve ⭐'**
  String get rateAppDescription;

  /// No description provided for @shareAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Share Syrian tourism guide with friends & family 📲'**
  String get shareAppDescription;

  /// No description provided for @restoreDefaults.
  ///
  /// In en, this message translates to:
  /// **'Restore Default App Settings'**
  String get restoreDefaults;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @cleanNow.
  ///
  /// In en, this message translates to:
  /// **'Clean Now'**
  String get cleanNow;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @registeredPlaces.
  ///
  /// In en, this message translates to:
  /// **'Registered Landmarks'**
  String get registeredPlaces;

  /// No description provided for @availableCategories.
  ///
  /// In en, this message translates to:
  /// **'Available Categories'**
  String get availableCategories;

  /// No description provided for @savedBookings.
  ///
  /// In en, this message translates to:
  /// **'Saved Bookings'**
  String get savedBookings;

  /// No description provided for @howWasYourExperience.
  ///
  /// In en, this message translates to:
  /// **'How was your experience with Tourist Guide?'**
  String get howWasYourExperience;

  /// No description provided for @ratingImpactMessage.
  ///
  /// In en, this message translates to:
  /// **'Your rating helps improve guide quality and provide precise info about Syria landmarks:'**
  String get ratingImpactMessage;

  /// No description provided for @sendRating.
  ///
  /// In en, this message translates to:
  /// **'Send Rating'**
  String get sendRating;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @thanksForRating.
  ///
  /// In en, this message translates to:
  /// **'Thanks for sharing your rating ❤️'**
  String get thanksForRating;

  /// No description provided for @sharePromoText.
  ///
  /// In en, this message translates to:
  /// **'Discover the beauty and charm of Syria with the \"Tourist Guide\" app 🇸🇾✨\n\nYour comprehensive and reliable guide to historical landmarks, authentic Syrian restaurants, hotels, and activities with booking options and offline maps!\n\nDownload the app now and enjoy a unique tour across Syria.'**
  String get sharePromoText;

  /// No description provided for @copyText.
  ///
  /// In en, this message translates to:
  /// **'Copy Text'**
  String get copyText;

  /// No description provided for @shareCopiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Share text copied to clipboard successfully 📋'**
  String get shareCopiedSuccess;

  /// No description provided for @privacyIntro.
  ///
  /// In en, this message translates to:
  /// **'At \"Tourist Guide\", user privacy and security are our highest priority:'**
  String get privacyIntro;

  /// No description provided for @privacyBullet1Title.
  ///
  /// In en, this message translates to:
  /// **'Secure Local Storage'**
  String get privacyBullet1Title;

  /// No description provided for @privacyBullet1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'All your data (bookings, favorites, settings) is stored locally on your device only.'**
  String get privacyBullet1Subtitle;

  /// No description provided for @privacyBullet2Title.
  ///
  /// In en, this message translates to:
  /// **'Password Encryption'**
  String get privacyBullet2Title;

  /// No description provided for @privacyBullet2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Passwords are encrypted with SHA-256 and never stored in plain text.'**
  String get privacyBullet2Subtitle;

  /// No description provided for @privacyBullet3Title.
  ///
  /// In en, this message translates to:
  /// **'Location Permission'**
  String get privacyBullet3Title;

  /// No description provided for @privacyBullet3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Location permission is only used to compute distances and show nearby places with your consent.'**
  String get privacyBullet3Subtitle;

  /// No description provided for @privacyBullet4Title.
  ///
  /// In en, this message translates to:
  /// **'No Tracking or Ads'**
  String get privacyBullet4Title;

  /// No description provided for @privacyBullet4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'The app contains no third-party tracking libraries or commercial ads.'**
  String get privacyBullet4Subtitle;

  /// No description provided for @iUnderstand.
  ///
  /// In en, this message translates to:
  /// **'I Understand'**
  String get iUnderstand;

  /// No description provided for @termsIntro.
  ///
  /// In en, this message translates to:
  /// **'Welcome to \"Tourist Guide\". Your use of the app implies agreement to the following terms:'**
  String get termsIntro;

  /// No description provided for @termsBullet1Title.
  ///
  /// In en, this message translates to:
  /// **'Guidance Purposes'**
  String get termsBullet1Title;

  /// No description provided for @termsBullet1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Data, images, and geographic information are provided for guidance and tourism purposes.'**
  String get termsBullet1Subtitle;

  /// No description provided for @termsBullet2Title.
  ///
  /// In en, this message translates to:
  /// **'Booking Nature'**
  String get termsBullet2Title;

  /// No description provided for @termsBullet2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'In-app bookings are organizational for users and admin, without electronic payment.'**
  String get termsBullet2Subtitle;

  /// No description provided for @termsBullet3Title.
  ///
  /// In en, this message translates to:
  /// **'Protecting Heritage'**
  String get termsBullet3Title;

  /// No description provided for @termsBullet3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'The app urges visitors of Syrian historical landmarks to preserve their cleanliness and safety.'**
  String get termsBullet3Subtitle;

  /// No description provided for @termsBullet4Title.
  ///
  /// In en, this message translates to:
  /// **'Legal Compliance'**
  String get termsBullet4Title;

  /// No description provided for @termsBullet4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Users commit to complying with applicable laws and regulations in the Syrian Arab Republic.'**
  String get termsBullet4Subtitle;

  /// No description provided for @iAgree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get iAgree;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @trips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get trips;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @spending.
  ///
  /// In en, this message translates to:
  /// **'Spending'**
  String get spending;

  /// No description provided for @myTrips.
  ///
  /// In en, this message translates to:
  /// **'My Trips'**
  String get myTrips;

  /// No description provided for @viewTripsHistory.
  ///
  /// In en, this message translates to:
  /// **'View your trips history'**
  String get viewTripsHistory;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @aboutAppShort.
  ///
  /// In en, this message translates to:
  /// **'A comprehensive tourist guide application for Syrian landmarks.'**
  String get aboutAppShort;

  /// No description provided for @privacyItem1.
  ///
  /// In en, this message translates to:
  /// **'Location - Only used to show nearby places'**
  String get privacyItem1;

  /// No description provided for @privacyItem2.
  ///
  /// In en, this message translates to:
  /// **'Personal Data - Never shared with third parties'**
  String get privacyItem2;

  /// No description provided for @privacyItem3.
  ///
  /// In en, this message translates to:
  /// **'Security - All data is encrypted and protected'**
  String get privacyItem3;

  /// No description provided for @privacyItem4.
  ///
  /// In en, this message translates to:
  /// **'You can clear your data at any time from settings'**
  String get privacyItem4;

  /// No description provided for @termsItem1.
  ///
  /// In en, this message translates to:
  /// **'Use the app for personal purposes only'**
  String get termsItem1;

  /// No description provided for @termsItem2.
  ///
  /// In en, this message translates to:
  /// **'Do not misuse displayed information'**
  String get termsItem2;

  /// No description provided for @termsItem3.
  ///
  /// In en, this message translates to:
  /// **'Comply with country regulations and laws'**
  String get termsItem3;

  /// No description provided for @termsItem4.
  ///
  /// In en, this message translates to:
  /// **'Information is provided for guidance'**
  String get termsItem4;

  /// No description provided for @sharingAppProgress.
  ///
  /// In en, this message translates to:
  /// **'Sharing app...'**
  String get sharingAppProgress;

  /// No description provided for @thanksRatingToast.
  ///
  /// In en, this message translates to:
  /// **'Thank you for rating the app ⭐'**
  String get thanksRatingToast;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @tryChangingSearch.
  ///
  /// In en, this message translates to:
  /// **'Try changing your search terms or category'**
  String get tryChangingSearch;

  /// No description provided for @placesCountSuffix.
  ///
  /// In en, this message translates to:
  /// **'places'**
  String get placesCountSuffix;

  /// No description provided for @bookingsCountSuffix.
  ///
  /// In en, this message translates to:
  /// **'bookings'**
  String get bookingsCountSuffix;

  /// No description provided for @peopleCountSuffix.
  ///
  /// In en, this message translates to:
  /// **'people'**
  String get peopleCountSuffix;

  /// No description provided for @resetFilter.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetFilter;

  /// No description provided for @noBookingsCategory.
  ///
  /// In en, this message translates to:
  /// **'No bookings in this category'**
  String get noBookingsCategory;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @explorePlaces.
  ///
  /// In en, this message translates to:
  /// **'Explore Places'**
  String get explorePlaces;

  /// No description provided for @noBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can book tourist places from the details page'**
  String get noBookingsSubtitle;

  /// No description provided for @noBookingsInFilter.
  ///
  /// In en, this message translates to:
  /// **'No bookings in this category'**
  String get noBookingsInFilter;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get showAll;

  /// No description provided for @confirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancellation'**
  String get confirmCancel;

  /// No description provided for @cannotCancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cannot cancel this booking currently'**
  String get cannotCancelBooking;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalPrice;

  /// No description provided for @peopleSuffix.
  ///
  /// In en, this message translates to:
  /// **'people'**
  String get peopleSuffix;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get currency;

  /// No description provided for @visitDateSection.
  ///
  /// In en, this message translates to:
  /// **'📅 Visit Date'**
  String get visitDateSection;

  /// No description provided for @visitDateSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred visit date'**
  String get visitDateSectionSubtitle;

  /// No description provided for @visitTimeSection.
  ///
  /// In en, this message translates to:
  /// **'🕒 Visit Time'**
  String get visitTimeSection;

  /// No description provided for @visitTimeSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a convenient time slot'**
  String get visitTimeSectionSubtitle;

  /// No description provided for @numberOfVisitorsSection.
  ///
  /// In en, this message translates to:
  /// **'👥 Number of Visitors'**
  String get numberOfVisitorsSection;

  /// No description provided for @numberOfVisitorsSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your party size'**
  String get numberOfVisitorsSectionSubtitle;

  /// No description provided for @contactDataSection.
  ///
  /// In en, this message translates to:
  /// **'📝 Contact Information'**
  String get contactDataSection;

  /// No description provided for @contactDataSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'To confirm booking and reach you easily'**
  String get contactDataSectionSubtitle;

  /// No description provided for @selectVisitDate.
  ///
  /// In en, this message translates to:
  /// **'Select Visit Date'**
  String get selectVisitDate;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @dayAfterTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Day After Tomorrow'**
  String get dayAfterTomorrow;

  /// No description provided for @customDate.
  ///
  /// In en, this message translates to:
  /// **'Custom Date'**
  String get customDate;

  /// No description provided for @morningSlots.
  ///
  /// In en, this message translates to:
  /// **'Morning Slots:'**
  String get morningSlots;

  /// No description provided for @eveningSlots.
  ///
  /// In en, this message translates to:
  /// **'Afternoon & Evening Slots:'**
  String get eveningSlots;

  /// No description provided for @onePerson.
  ///
  /// In en, this message translates to:
  /// **'1 Person'**
  String get onePerson;

  /// No description provided for @twoPeople.
  ///
  /// In en, this message translates to:
  /// **'2 People'**
  String get twoPeople;

  /// No description provided for @holderNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking Name*'**
  String get holderNameLabel;

  /// No description provided for @holderNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get holderNameHint;

  /// No description provided for @holderNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter booking name'**
  String get holderNameRequired;

  /// No description provided for @contactPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone / Contact Number*'**
  String get contactPhoneLabel;

  /// No description provided for @contactPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 0991234567 or +963...'**
  String get contactPhoneHint;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get phoneRequired;

  /// No description provided for @phoneTooShort.
  ///
  /// In en, this message translates to:
  /// **'Phone number is too short'**
  String get phoneTooShort;

  /// No description provided for @bookingEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (for booking confirmation)'**
  String get bookingEmailLabel;

  /// No description provided for @extraNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes (Optional)'**
  String get extraNotesLabel;

  /// No description provided for @extraNotesHint.
  ///
  /// In en, this message translates to:
  /// **'View table, special occasion, child seat...'**
  String get extraNotesHint;

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Estimated Booking Summary'**
  String get summaryTitle;

  /// No description provided for @visitDateTime.
  ///
  /// In en, this message translates to:
  /// **'Visit Date & Time'**
  String get visitDateTime;

  /// No description provided for @pricePerPerson.
  ///
  /// In en, this message translates to:
  /// **'Price per Person'**
  String get pricePerPerson;

  /// No description provided for @expectedTotalPrice.
  ///
  /// In en, this message translates to:
  /// **'Estimated Total Price'**
  String get expectedTotalPrice;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @confirmBookingFree.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking (Free)'**
  String get confirmBookingFree;

  /// No description provided for @referenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference No: #'**
  String get referenceNumber;

  /// No description provided for @landmark.
  ///
  /// In en, this message translates to:
  /// **'📍 Landmark'**
  String get landmark;

  /// No description provided for @appointment.
  ///
  /// In en, this message translates to:
  /// **'📅 Appointment'**
  String get appointment;

  /// No description provided for @visitors.
  ///
  /// In en, this message translates to:
  /// **'👥 Visitors'**
  String get visitors;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'💰 Total'**
  String get total;

  /// No description provided for @bookingUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Your booking is currently under review, you will be notified upon confirmation.'**
  String get bookingUnderReview;

  /// No description provided for @doneAndFollowBookings.
  ///
  /// In en, this message translates to:
  /// **'Done & View Bookings'**
  String get doneAndFollowBookings;

  /// No description provided for @locationOnMap.
  ///
  /// In en, this message translates to:
  /// **'Location on Map'**
  String get locationOnMap;

  /// No description provided for @nearbyPlaces.
  ///
  /// In en, this message translates to:
  /// **'Nearby Places'**
  String get nearbyPlaces;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @supportHeaderNote.
  ///
  /// In en, this message translates to:
  /// **'We are here to help you 24/7'**
  String get supportHeaderNote;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @attachmentsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'File attachments feature coming soon 📎'**
  String get attachmentsComingSoon;

  /// No description provided for @writeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Write your message...'**
  String get writeMessageHint;

  /// No description provided for @initialSupportGreeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Help & Support! 👋\nHow can we help you today?'**
  String get initialSupportGreeting;

  /// No description provided for @clearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear Chat'**
  String get clearChat;

  /// No description provided for @supportInfo.
  ///
  /// In en, this message translates to:
  /// **'Support Information'**
  String get supportInfo;

  /// No description provided for @clearChatConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all messages?'**
  String get clearChatConfirm;

  /// No description provided for @chatCleared.
  ///
  /// In en, this message translates to:
  /// **'Chat cleared'**
  String get chatCleared;

  /// No description provided for @workingHours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get workingHours;

  /// No description provided for @workingHoursValue.
  ///
  /// In en, this message translates to:
  /// **'24/7 All Week'**
  String get workingHoursValue;

  /// No description provided for @responseTime.
  ///
  /// In en, this message translates to:
  /// **'Response Time'**
  String get responseTime;

  /// No description provided for @responseTimeValue.
  ///
  /// In en, this message translates to:
  /// **'Within 5 minutes'**
  String get responseTimeValue;

  /// No description provided for @resetPasswordSentInfo.
  ///
  /// In en, this message translates to:
  /// **'A password reset link will be sent to your email'**
  String get resetPasswordSentInfo;

  /// No description provided for @enterEmailAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter email and password'**
  String get enterEmailAndPassword;

  /// No description provided for @adminWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Admin Dashboard 🛡️'**
  String get adminWelcomeMessage;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check credentials'**
  String get loginFailed;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @gmail.
  ///
  /// In en, this message translates to:
  /// **'Gmail'**
  String get gmail;

  /// No description provided for @systemOverview.
  ///
  /// In en, this message translates to:
  /// **'System Overview'**
  String get systemOverview;

  /// No description provided for @pendingBookings.
  ///
  /// In en, this message translates to:
  /// **'Pending Bookings'**
  String get pendingBookings;

  /// No description provided for @placesAndRestaurants.
  ///
  /// In en, this message translates to:
  /// **'Places & Restaurants'**
  String get placesAndRestaurants;

  /// No description provided for @guideCategories.
  ///
  /// In en, this message translates to:
  /// **'Guide Categories'**
  String get guideCategories;

  /// No description provided for @totalEstimatedRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Estimated Revenue'**
  String get totalEstimatedRevenue;

  /// No description provided for @adminActions.
  ///
  /// In en, this message translates to:
  /// **'Admin Actions'**
  String get adminActions;

  /// No description provided for @manageBookingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View, confirm, and cancel customer bookings'**
  String get manageBookingsSubtitle;

  /// No description provided for @managePlacesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View, add, edit, and delete places and restaurants'**
  String get managePlacesSubtitle;

  /// No description provided for @manageCategoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add, edit, and delete tourist guide categories'**
  String get manageCategoriesSubtitle;

  /// No description provided for @clientPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore app features and booking experience as client'**
  String get clientPreviewSubtitle;

  /// No description provided for @recentBookings.
  ///
  /// In en, this message translates to:
  /// **'Recent Bookings'**
  String get recentBookings;

  /// No description provided for @noBookingsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No bookings registered currently'**
  String get noBookingsRegistered;

  /// No description provided for @adminBadge.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminBadge;

  /// No description provided for @editPlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Place Details'**
  String get editPlaceTitle;

  /// No description provided for @addPlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Place'**
  String get addPlaceTitle;

  /// No description provided for @basicInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInfoSection;

  /// No description provided for @placeNameArLabel.
  ///
  /// In en, this message translates to:
  /// **'Place / Restaurant Name (Arabic)*'**
  String get placeNameArLabel;

  /// No description provided for @enterPlaceNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter place name'**
  String get enterPlaceNameError;

  /// No description provided for @placeNameEnLabel.
  ///
  /// In en, this message translates to:
  /// **'Place Name (English)'**
  String get placeNameEnLabel;

  /// No description provided for @selectCategoryError.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get selectCategoryError;

  /// No description provided for @cityRegionLabel.
  ///
  /// In en, this message translates to:
  /// **'City / Governorate*'**
  String get cityRegionLabel;

  /// No description provided for @enterCityError.
  ///
  /// In en, this message translates to:
  /// **'Please enter city or governorate'**
  String get enterCityError;

  /// No description provided for @workingHoursAndContact.
  ///
  /// In en, this message translates to:
  /// **'Working Hours & Contact'**
  String get workingHoursAndContact;

  /// No description provided for @workingHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get workingHoursLabel;

  /// No description provided for @workingHoursHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 09:00 AM - 11:00 PM'**
  String get workingHoursHint;

  /// No description provided for @phoneContactLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number / Contact'**
  String get phoneContactLabel;

  /// No description provided for @websiteUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Website / Link'**
  String get websiteUrlLabel;

  /// No description provided for @pricesRatingCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Prices, Rating & Coordinates'**
  String get pricesRatingCoordinates;

  /// No description provided for @priceLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Price Level'**
  String get priceLevelLabel;

  /// No description provided for @priceLevelHint.
  ///
  /// In en, this message translates to:
  /// **'Budget / Moderate / Luxury'**
  String get priceLevelHint;

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating (1-5)'**
  String get ratingLabel;

  /// No description provided for @latitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitudeLabel;

  /// No description provided for @longitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitudeLabel;

  /// No description provided for @descriptionSection.
  ///
  /// In en, this message translates to:
  /// **'Description & Overview'**
  String get descriptionSection;

  /// No description provided for @placeDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Place Overview & Description*'**
  String get placeDescriptionLabel;

  /// No description provided for @placeDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Write a comprehensive overview of the place and its history...'**
  String get placeDescriptionHint;

  /// No description provided for @enterDescriptionError.
  ///
  /// In en, this message translates to:
  /// **'Please enter place description'**
  String get enterDescriptionError;

  /// No description provided for @photosAndGallery.
  ///
  /// In en, this message translates to:
  /// **'Photos & Gallery'**
  String get photosAndGallery;

  /// No description provided for @mainImageUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Main Image URL*'**
  String get mainImageUrlLabel;

  /// No description provided for @enterMainImageError.
  ///
  /// In en, this message translates to:
  /// **'Please enter main image URL'**
  String get enterMainImageError;

  /// No description provided for @addGalleryImageHint.
  ///
  /// In en, this message translates to:
  /// **'Enter additional image URL...'**
  String get addGalleryImageHint;

  /// No description provided for @noGalleryImagesYet.
  ///
  /// In en, this message translates to:
  /// **'No additional images yet. You can add image links above.'**
  String get noGalleryImagesYet;

  /// No description provided for @placeUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Place updated successfully'**
  String get placeUpdatedSuccess;

  /// No description provided for @placeAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Place added successfully'**
  String get placeAddedSuccess;

  /// No description provided for @saveEdits.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveEdits;

  /// No description provided for @deletePlaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Place'**
  String get deletePlaceTitle;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @permanentDelete.
  ///
  /// In en, this message translates to:
  /// **'Permanent Delete'**
  String get permanentDelete;

  /// No description provided for @searchByNameOrCity.
  ///
  /// In en, this message translates to:
  /// **'Search by name or city...'**
  String get searchByNameOrCity;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @luxury.
  ///
  /// In en, this message translates to:
  /// **'Luxury'**
  String get luxury;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @roundTheClock.
  ///
  /// In en, this message translates to:
  /// **'24/7'**
  String get roundTheClock;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @resultsCount.
  ///
  /// In en, this message translates to:
  /// **'Results count: '**
  String get resultsCount;

  /// No description provided for @noMatchingPlaces.
  ///
  /// In en, this message translates to:
  /// **'No places match your search'**
  String get noMatchingPlaces;

  /// No description provided for @featuredDestinations.
  ///
  /// In en, this message translates to:
  /// **'✨ Featured Destinations'**
  String get featuredDestinations;

  /// No description provided for @discoverCategories.
  ///
  /// In en, this message translates to:
  /// **'📂 Discover Categories'**
  String get discoverCategories;

  /// No description provided for @welcomeGreeting.
  ///
  /// In en, this message translates to:
  /// **'🌟 Welcome'**
  String get welcomeGreeting;

  /// No description provided for @searchDestinationHint.
  ///
  /// In en, this message translates to:
  /// **'Search for your destination...'**
  String get searchDestinationHint;

  /// No description provided for @hotels.
  ///
  /// In en, this message translates to:
  /// **'Hotels'**
  String get hotels;

  /// No description provided for @landmarks.
  ///
  /// In en, this message translates to:
  /// **'Landmarks'**
  String get landmarks;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
