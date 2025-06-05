import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Todo App'**
  String get appTitle;

  /// No description provided for @missingInformationError.
  ///
  /// In en, this message translates to:
  /// **'Missing information.'**
  String get missingInformationError;

  /// No description provided for @mismatchPasswordsError.
  ///
  /// In en, this message translates to:
  /// **'Confirm password does not match.'**
  String get mismatchPasswordsError;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @forgotPasswordText.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordText;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'johndoe@example.com'**
  String get emailHint;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordPlaceholder;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'********'**
  String get passwordHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'********'**
  String get confirmPasswordHint;

  /// No description provided for @oldPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPasswordLabel;

  /// No description provided for @oldPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'********'**
  String get oldPasswordHint;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'********'**
  String get newPasswordHint;

  /// No description provided for @registerText.
  ///
  /// In en, this message translates to:
  /// **'Need an account?'**
  String get registerText;

  /// No description provided for @registerHereButton.
  ///
  /// In en, this message translates to:
  /// **'Register here'**
  String get registerHereButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @recoverPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Recover Password'**
  String get recoverPasswordTitle;

  /// No description provided for @sendRecoveryLinkButton.
  ///
  /// In en, this message translates to:
  /// **'Send Recovery Link'**
  String get sendRecoveryLinkButton;

  /// No description provided for @profileSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Setup'**
  String get profileSetupTitle;

  /// No description provided for @profileSetupButton.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get profileSetupButton;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'johndoe'**
  String get usernameHint;

  /// No description provided for @logOutButton.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOutButton;

  /// No description provided for @popUpConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get popUpConfirmationTitle;

  /// No description provided for @popUpConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get popUpConfirm;

  /// No description provided for @popUpCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get popUpCancel;

  /// No description provided for @popUpRegistrationDesc.
  ///
  /// In en, this message translates to:
  /// **'Registration will not be completed if you leave this page.'**
  String get popUpRegistrationDesc;

  /// No description provided for @popUpRecoveryPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Password will not be updated if you leave this page.'**
  String get popUpRecoveryPasswordDesc;

  /// No description provided for @popUpLogOutConfirmationDesc.
  ///
  /// In en, this message translates to:
  /// **'You will be logged out.'**
  String get popUpLogOutConfirmationDesc;

  /// No description provided for @popUpDeleteTodoDesc.
  ///
  /// In en, this message translates to:
  /// **'Deleted item cannot be recovered.'**
  String get popUpDeleteTodoDesc;

  /// No description provided for @recoveryUpdateNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get recoveryUpdateNewPasswordTitle;

  /// No description provided for @recoveryUpdatePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get recoveryUpdatePasswordButton;

  /// No description provided for @usernameUpdatedText.
  ///
  /// In en, this message translates to:
  /// **'Username updated'**
  String get usernameUpdatedText;

  /// No description provided for @emailUpdatedText.
  ///
  /// In en, this message translates to:
  /// **'Email updated'**
  String get emailUpdatedText;

  /// No description provided for @passwordUpdatedText.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdatedText;

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButton;

  /// No description provided for @updateEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Email'**
  String get updateEmailTitle;

  /// No description provided for @updateUsernameTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Username'**
  String get updateUsernameTitle;

  /// No description provided for @updatePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePasswordTitle;

  /// No description provided for @createTodoButton.
  ///
  /// In en, this message translates to:
  /// **'Create Todo'**
  String get createTodoButton;

  /// No description provided for @createTodoTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Todo'**
  String get createTodoTitle;

  /// No description provided for @createTodoCompleted.
  ///
  /// In en, this message translates to:
  /// **'Todo created.'**
  String get createTodoCompleted;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @editButton.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButton;

  /// No description provided for @todoDeleteText.
  ///
  /// In en, this message translates to:
  /// **'Item deleted.'**
  String get todoDeleteText;

  /// No description provided for @updateTodoTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Todo'**
  String get updateTodoTitle;

  /// No description provided for @updateTodoCompleted.
  ///
  /// In en, this message translates to:
  /// **'Todo updated.'**
  String get updateTodoCompleted;

  /// No description provided for @updateTodoButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateTodoButton;

  /// No description provided for @passwordRecoverEmailPageHeader.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get passwordRecoverEmailPageHeader;

  /// No description provided for @passwordRecoverEmailPageDesc.
  ///
  /// In en, this message translates to:
  /// **'Please enter your account\'s email below. We will send you a recovery link to help change your password.'**
  String get passwordRecoverEmailPageDesc;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get sendEmail;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @mismatchPasswords.
  ///
  /// In en, this message translates to:
  /// **'Mismatch Passwords. Please fix.'**
  String get mismatchPasswords;

  /// No description provided for @registrationPageHeader.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registrationPageHeader;

  /// No description provided for @registrationPageDesc.
  ///
  /// In en, this message translates to:
  /// **'Please fill out the form below to create an account with us.'**
  String get registrationPageDesc;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyEmail;

  /// No description provided for @registerUserPageHeader.
  ///
  /// In en, this message translates to:
  /// **'Register User Information'**
  String get registerUserPageHeader;

  /// No description provided for @registerUserPageDesc.
  ///
  /// In en, this message translates to:
  /// **'Almost there! Just fill out the form below to finalize your accout with us!'**
  String get registerUserPageDesc;

  /// No description provided for @usernamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernamePlaceholder;

  /// No description provided for @forgotPasswordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get forgotPasswordPlaceholder;

  /// No description provided for @recoverUpdatePasswordHeader.
  ///
  /// In en, this message translates to:
  /// **'Almost there!'**
  String get recoverUpdatePasswordHeader;

  /// No description provided for @recoverUpdatePasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password below.'**
  String get recoverUpdatePasswordDesc;

  /// No description provided for @settingsAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountTitle;

  /// No description provided for @settingsUpdateUsername.
  ///
  /// In en, this message translates to:
  /// **'Change Username'**
  String get settingsUpdateUsername;
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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
