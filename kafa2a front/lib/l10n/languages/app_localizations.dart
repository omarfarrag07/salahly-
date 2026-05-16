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
/// import 'languages/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @serviceProvider.
  ///
  /// In en, this message translates to:
  /// **'Service Provider'**
  String get serviceProvider;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome,'**
  String get welcome;

  /// No description provided for @slogan.
  ///
  /// In en, this message translates to:
  /// **'Skilled Hands, Anytime, Anywhere!'**
  String get slogan;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

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

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email'**
  String get enterYourEmail;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Password'**
  String get enterYourPassword;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Have An Account?'**
  String get dontHaveAnAccount;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already Have An Account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Phone Number'**
  String get enterYourPhoneNumber;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Name'**
  String get enterYourName;

  /// No description provided for @enterYourNationalId.
  ///
  /// In en, this message translates to:
  /// **'Enter Your National Id'**
  String get enterYourNationalId;

  /// No description provided for @enterYourAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Address'**
  String get enterYourAddress;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get myRequests;

  /// No description provided for @acceptedRequests.
  ///
  /// In en, this message translates to:
  /// **'Accepted Requests'**
  String get acceptedRequests;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @offers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// No description provided for @offer.
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get offer;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get cancelRequest;

  /// No description provided for @requestService.
  ///
  /// In en, this message translates to:
  /// **'Request Service'**
  String get requestService;

  /// No description provided for @providerProfile.
  ///
  /// In en, this message translates to:
  /// **'Provider Profile'**
  String get providerProfile;

  /// No description provided for @acceptOffer.
  ///
  /// In en, this message translates to:
  /// **'Accept Offer'**
  String get acceptOffer;

  /// No description provided for @editProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile Photo'**
  String get editProfilePhoto;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @sendOffer.
  ///
  /// In en, this message translates to:
  /// **'Send Offer'**
  String get sendOffer;

  /// No description provided for @policeClearanceCertificate.
  ///
  /// In en, this message translates to:
  /// **'Police Clearance Certrificate'**
  String get policeClearanceCertificate;

  /// No description provided for @uploadSelfie.
  ///
  /// In en, this message translates to:
  /// **'Upload A Selfie'**
  String get uploadSelfie;

  /// No description provided for @takeSelfie.
  ///
  /// In en, this message translates to:
  /// **'Take Selfie'**
  String get takeSelfie;

  /// No description provided for @pickImage.
  ///
  /// In en, this message translates to:
  /// **'Pick Image'**
  String get pickImage;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @selectService.
  ///
  /// In en, this message translates to:
  /// **'Select Service'**
  String get selectService;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @preferedTime.
  ///
  /// In en, this message translates to:
  /// **'Prefered Time'**
  String get preferedTime;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @pleaseEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Description'**
  String get pleaseEnterDescription;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Title'**
  String get pleaseEnterTitle;

  /// No description provided for @pleaseEnterYourPrice.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your Price'**
  String get pleaseEnterYourPrice;

  /// No description provided for @selectDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Select Date and Time'**
  String get selectDateAndTime;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your National ID'**
  String get addressRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your Email'**
  String get emailRequired;

  /// No description provided for @failedToDeleteToken.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete token'**
  String get failedToDeleteToken;

  /// No description provided for @failedToRetrieveToken.
  ///
  /// In en, this message translates to:
  /// **'Failed to retrieve token'**
  String get failedToRetrieveToken;

  /// No description provided for @failedToSaveToken.
  ///
  /// In en, this message translates to:
  /// **'Failed to save token'**
  String get failedToSaveToken;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please Enter a Valid Email'**
  String get invalidEmail;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your Name'**
  String get nameRequired;

  /// No description provided for @nationalIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your National ID'**
  String get nationalIdRequired;

  /// No description provided for @priceRequired.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your Price'**
  String get priceRequired;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please Enter a Title'**
  String get titleRequired;

  /// No description provided for @passwordIsSmall.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordIsSmall;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your Password'**
  String get passwordRequired;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords Don\'t Match'**
  String get passwordsDontMatch;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your Phone Number'**
  String get phoneNumberRequired;

  /// No description provided for @serviceRequestedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Service Requested Successfully!'**
  String get serviceRequestedSuccessfully;

  /// No description provided for @failedToLogin.
  ///
  /// In en, this message translates to:
  /// **'Failed to Login'**
  String get failedToLogin;

  /// No description provided for @failedToRegister.
  ///
  /// In en, this message translates to:
  /// **'Failed to Register'**
  String get failedToRegister;

  /// No description provided for @failedToLogOut.
  ///
  /// In en, this message translates to:
  /// **'Failed to log out'**
  String get failedToLogOut;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to get categories'**
  String get errorMessage;

  /// No description provided for @failedToGetCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to Get Categories'**
  String get failedToGetCategories;

  /// No description provided for @failedToRequestService.
  ///
  /// In en, this message translates to:
  /// **'Failed to Request Service'**
  String get failedToRequestService;

  /// No description provided for @failedToGetRequests.
  ///
  /// In en, this message translates to:
  /// **'Failed to Get Requests'**
  String get failedToGetRequests;

  /// No description provided for @failedToSendOffer.
  ///
  /// In en, this message translates to:
  /// **'Failed to Send Offer'**
  String get failedToSendOffer;

  /// No description provided for @failedToGetPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Failed to Get Pending Requests'**
  String get failedToGetPendingRequests;

  /// No description provided for @failedToGetAcceptedOffers.
  ///
  /// In en, this message translates to:
  /// **'Failed to Get Accepted Offers'**
  String get failedToGetAcceptedOffers;

  /// No description provided for @noPendingRequetsAtTheMoment.
  ///
  /// In en, this message translates to:
  /// **'No Pending Requests At The Moment!'**
  String get noPendingRequetsAtTheMoment;

  /// No description provided for @noRequestsAtTheMoment.
  ///
  /// In en, this message translates to:
  /// **'No Requests At The Moment!'**
  String get noRequestsAtTheMoment;

  /// No description provided for @yourOfferDetails.
  ///
  /// In en, this message translates to:
  /// **'Your Offer Details'**
  String get yourOfferDetails;

  /// No description provided for @enterYourOffer.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Offer'**
  String get enterYourOffer;

  /// No description provided for @pickYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Press to Get Your Location'**
  String get pickYourLocation;

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'No Image Selected'**
  String get noImageSelected;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @noOffers.
  ///
  /// In en, this message translates to:
  /// **'No Offers'**
  String get noOffers;

  /// No description provided for @notActiveYet.
  ///
  /// In en, this message translates to:
  /// **'Not Active Yet'**
  String get notActiveYet;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @requestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request Cancelled!'**
  String get requestCancelled;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @waitingForOffer.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Offer'**
  String get waitingForOffer;

  /// No description provided for @providerName.
  ///
  /// In en, this message translates to:
  /// **'Provider Name'**
  String get providerName;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @offerDetails.
  ///
  /// In en, this message translates to:
  /// **'Offer Details'**
  String get offerDetails;

  /// No description provided for @noOffersYet.
  ///
  /// In en, this message translates to:
  /// **'No offers yet'**
  String get noOffersYet;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @viewAllOffers.
  ///
  /// In en, this message translates to:
  /// **'View All Offers'**
  String get viewAllOffers;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @allRequests.
  ///
  /// In en, this message translates to:
  /// **'All Requests'**
  String get allRequests;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmount;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @rateProvider.
  ///
  /// In en, this message translates to:
  /// **'Rate Provider'**
  String get rateProvider;

  /// No description provided for @writeAReview.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeAReview;

  /// No description provided for @howWasYourExperience.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get howWasYourExperience;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @scheduledJobs.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Jobs'**
  String get scheduledJobs;

  /// No description provided for @yourAppointments.
  ///
  /// In en, this message translates to:
  /// **'Your Appointments'**
  String get yourAppointments;

  /// No description provided for @appointmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'make sure to press done when complete your service ! GOOD LUCK'**
  String get appointmentsSubtitle;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @waitingToGetPaid.
  ///
  /// In en, this message translates to:
  /// **'waiting to get paid !!'**
  String get waitingToGetPaid;

  /// No description provided for @paidSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'paid successfully !! Well Done Osta !!'**
  String get paidSuccessfully;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @customerWantsToPay.
  ///
  /// In en, this message translates to:
  /// **'The customer wants to pay this amount :) '**
  String get customerWantsToPay;

  /// No description provided for @whatIsYourOffer.
  ///
  /// In en, this message translates to:
  /// **'What is your offer for him !'**
  String get whatIsYourOffer;

  /// No description provided for @suspendReason.
  ///
  /// In en, this message translates to:
  /// **'Suspend Reason'**
  String get suspendReason;

  /// No description provided for @updateDocument.
  ///
  /// In en, this message translates to:
  /// **'Update Document'**
  String get updateDocument;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
