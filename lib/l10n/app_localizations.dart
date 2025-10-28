import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('es'),
    Locale('de'),
    Locale('fr'),
    Locale('it'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'a Chess Time'**
  String get appName;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveAndClose.
  ///
  /// In en, this message translates to:
  /// **'Save and Close'**
  String get saveAndClose;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @resetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to reset the game?'**
  String get resetConfirm;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @tapToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap to Start'**
  String get tapToStart;

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// No description provided for @victory.
  ///
  /// In en, this message translates to:
  /// **'Victory!'**
  String get victory;

  /// No description provided for @player1.
  ///
  /// In en, this message translates to:
  /// **'Player 1'**
  String get player1;

  /// No description provided for @player2.
  ///
  /// In en, this message translates to:
  /// **'Player 2'**
  String get player2;

  /// No description provided for @winner.
  ///
  /// In en, this message translates to:
  /// **'Winner'**
  String get winner;

  /// No description provided for @whitePlayer.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get whitePlayer;

  /// No description provided for @blackPlayer.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get blackPlayer;

  /// No description provided for @turnOf.
  ///
  /// In en, this message translates to:
  /// **'Turn of'**
  String get turnOf;

  /// No description provided for @won.
  ///
  /// In en, this message translates to:
  /// **'won!'**
  String get won;

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

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @swapColors.
  ///
  /// In en, this message translates to:
  /// **'Swap Colors'**
  String get swapColors;

  /// No description provided for @quickSettings.
  ///
  /// In en, this message translates to:
  /// **'Quick Settings'**
  String get quickSettings;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @gameSettings.
  ///
  /// In en, this message translates to:
  /// **'Game Settings'**
  String get gameSettings;

  /// No description provided for @timeControls.
  ///
  /// In en, this message translates to:
  /// **'Time Controls'**
  String get timeControls;

  /// No description provided for @sounds.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get sounds;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dark theme interface'**
  String get darkModeSubtitle;

  /// No description provided for @soundsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sounds during game'**
  String get soundsSubtitle;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @vibrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vibrate when switching turns'**
  String get vibrationSubtitle;

  /// No description provided for @player1StartsAsWhite.
  ///
  /// In en, this message translates to:
  /// **'Player 1 starts as white'**
  String get player1StartsAsWhite;

  /// No description provided for @initialTime.
  ///
  /// In en, this message translates to:
  /// **'Initial Time'**
  String get initialTime;

  /// No description provided for @increment.
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get increment;

  /// No description provided for @timePreset.
  ///
  /// In en, this message translates to:
  /// **'Time Preset'**
  String get timePreset;

  /// No description provided for @timePresets.
  ///
  /// In en, this message translates to:
  /// **'Time Presets'**
  String get timePresets;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @immersiveMode.
  ///
  /// In en, this message translates to:
  /// **'Immersive Mode'**
  String get immersiveMode;

  /// No description provided for @immersiveModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide system bars for full screen'**
  String get immersiveModeSubtitle;

  /// No description provided for @presetTournament.
  ///
  /// In en, this message translates to:
  /// **'Tournament'**
  String get presetTournament;

  /// No description provided for @presetBlitz.
  ///
  /// In en, this message translates to:
  /// **'Blitz'**
  String get presetBlitz;

  /// No description provided for @presetBullet.
  ///
  /// In en, this message translates to:
  /// **'Bullet'**
  String get presetBullet;

  /// No description provided for @presetRapid.
  ///
  /// In en, this message translates to:
  /// **'Rapid'**
  String get presetRapid;

  /// No description provided for @presetClassical.
  ///
  /// In en, this message translates to:
  /// **'Classical'**
  String get presetClassical;

  /// No description provided for @presetLong.
  ///
  /// In en, this message translates to:
  /// **'Long Game'**
  String get presetLong;

  /// No description provided for @presetBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get presetBasic;

  /// No description provided for @createCustomPreset.
  ///
  /// In en, this message translates to:
  /// **'Create Custom Preset'**
  String get createCustomPreset;

  /// No description provided for @editPreset.
  ///
  /// In en, this message translates to:
  /// **'Edit Preset'**
  String get editPreset;

  /// No description provided for @presetName.
  ///
  /// In en, this message translates to:
  /// **'Preset Name'**
  String get presetName;

  /// No description provided for @presetCreated.
  ///
  /// In en, this message translates to:
  /// **'Preset created'**
  String get presetCreated;

  /// No description provided for @presetUpdated.
  ///
  /// In en, this message translates to:
  /// **'Preset updated'**
  String get presetUpdated;

  /// No description provided for @presetDeleted.
  ///
  /// In en, this message translates to:
  /// **'Preset deleted'**
  String get presetDeleted;

  /// No description provided for @deletePresetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete preset'**
  String get deletePresetConfirm;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About a Chess Time'**
  String get aboutTitle;

  /// No description provided for @aboutContactLinks.
  ///
  /// In en, this message translates to:
  /// **'Contact & Links'**
  String get aboutContactLinks;

  /// No description provided for @aboutSupportMessage.
  ///
  /// In en, this message translates to:
  /// **'Support the development of this app!'**
  String get aboutSupportMessage;

  /// No description provided for @aboutSupportWithPix.
  ///
  /// In en, this message translates to:
  /// **'Support with PIX'**
  String get aboutSupportWithPix;

  /// No description provided for @aboutPixCopied.
  ///
  /// In en, this message translates to:
  /// **'PIX key copied to clipboard!'**
  String get aboutPixCopied;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by André Lopes'**
  String get developedBy;

  /// No description provided for @resetTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reset game'**
  String get resetTooltip;

  /// No description provided for @swapTooltip.
  ///
  /// In en, this message translates to:
  /// **'Swap player colors'**
  String get swapTooltip;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @aboutTooltip.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTooltip;

  /// No description provided for @advancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get advancedSettings;

  /// No description provided for @evaluateInPlayStore.
  ///
  /// In en, this message translates to:
  /// **'Rate on Play Store'**
  String get evaluateInPlayStore;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About the App'**
  String get aboutApp;

  /// No description provided for @linkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard!'**
  String get linkCopied;

  /// No description provided for @shareMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out ChessTime - a simple and modern chess timer!'**
  String get shareMessage;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesShort;

  /// No description provided for @secondsShort.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get secondsShort;

  /// No description provided for @minutesUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String minutesUnit(int count);

  /// No description provided for @secondsUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} seconds'**
  String secondsUnit(int count);

  /// No description provided for @playerWon.
  ///
  /// In en, this message translates to:
  /// **'won!'**
  String get playerWon;

  /// No description provided for @moves.
  ///
  /// In en, this message translates to:
  /// **'Moves'**
  String get moves;

  /// No description provided for @movesCount.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String movesCount(int count);

  /// No description provided for @victoryMessage.
  ///
  /// In en, this message translates to:
  /// **'{winnerName} won!'**
  String victoryMessage(String winnerName);

  /// No description provided for @fontSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Font size of timer'**
  String get fontSizeTitle;

  /// No description provided for @fontSizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust for better visibility'**
  String get fontSizeSubtitle;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTitle;

  /// No description provided for @themeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose app appearance'**
  String get themeSubtitle;

  /// No description provided for @themeClassicDark.
  ///
  /// In en, this message translates to:
  /// **'Classic Dark'**
  String get themeClassicDark;

  /// No description provided for @themeTraditionalBoard.
  ///
  /// In en, this message translates to:
  /// **'Traditional Board'**
  String get themeTraditionalBoard;

  /// No description provided for @themeGreenFocus.
  ///
  /// In en, this message translates to:
  /// **'Green Focus'**
  String get themeGreenFocus;

  /// No description provided for @themeTournamentBlue.
  ///
  /// In en, this message translates to:
  /// **'Tournament Blue'**
  String get themeTournamentBlue;

  /// No description provided for @themeRoyalGold.
  ///
  /// In en, this message translates to:
  /// **'Royal Gold'**
  String get themeRoyalGold;

  /// No description provided for @themeGrandmasterPurple.
  ///
  /// In en, this message translates to:
  /// **'Grandmaster Purple'**
  String get themeGrandmasterPurple;

  /// No description provided for @themeCompetitiveRed.
  ///
  /// In en, this message translates to:
  /// **'Competitive Red'**
  String get themeCompetitiveRed;

  /// No description provided for @themeDeepOcean.
  ///
  /// In en, this message translates to:
  /// **'Deep Ocean'**
  String get themeDeepOcean;

  /// No description provided for @themeMysticForest.
  ///
  /// In en, this message translates to:
  /// **'Mystic Forest'**
  String get themeMysticForest;

  /// No description provided for @themeElegantRose.
  ///
  /// In en, this message translates to:
  /// **'Elegant Rose'**
  String get themeElegantRose;

  /// No description provided for @themePremiumSilver.
  ///
  /// In en, this message translates to:
  /// **'Premium Silver'**
  String get themePremiumSilver;

  /// No description provided for @themeAuroraBoreal.
  ///
  /// In en, this message translates to:
  /// **'Aurora Boreal'**
  String get themeAuroraBoreal;

  /// No description provided for @themeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get themeCustom;

  /// No description provided for @premiumThemeRequired.
  ///
  /// In en, this message translates to:
  /// **'Premium Theme - Upgrade required'**
  String get premiumThemeRequired;

  /// No description provided for @unlockPremiumThemes.
  ///
  /// In en, this message translates to:
  /// **'Unlock premium themes'**
  String get unlockPremiumThemes;

  /// No description provided for @premiumThemesDescription.
  ///
  /// In en, this message translates to:
  /// **'Unlock exclusive themes and remove ads with Pro version'**
  String get premiumThemesDescription;

  /// No description provided for @proFeature1.
  ///
  /// In en, this message translates to:
  /// **'Access to 8 exclusive themes'**
  String get proFeature1;

  /// No description provided for @proFeature2.
  ///
  /// In en, this message translates to:
  /// **'Themes optimized for productivity'**
  String get proFeature2;

  /// No description provided for @proFeature3.
  ///
  /// In en, this message translates to:
  /// **'Remove ads'**
  String get proFeature3;

  /// No description provided for @proFeature4.
  ///
  /// In en, this message translates to:
  /// **'Support app development'**
  String get proFeature4;

  /// No description provided for @proFeature5.
  ///
  /// In en, this message translates to:
  /// **'Future updates included'**
  String get proFeature5;

  /// No description provided for @buyPro.
  ///
  /// In en, this message translates to:
  /// **'Buy Pro'**
  String get buyPro;

  /// No description provided for @purchaseFor.
  ///
  /// In en, this message translates to:
  /// **'Purchase for {price}'**
  String purchaseFor(String price);

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @upgradeToProTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get upgradeToProTitle;

  /// No description provided for @upgradeToProSubtitle.
  ///
  /// In en, this message translates to:
  /// **'8 premium themes + ad-free'**
  String get upgradeToProSubtitle;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @statisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsTitle;

  /// No description provided for @generalSummary.
  ///
  /// In en, this message translates to:
  /// **'General Summary'**
  String get generalSummary;

  /// No description provided for @totalGames.
  ///
  /// In en, this message translates to:
  /// **'Total Games'**
  String get totalGames;

  /// No description provided for @whiteWins.
  ///
  /// In en, this message translates to:
  /// **'White Wins'**
  String get whiteWins;

  /// No description provided for @blackWins.
  ///
  /// In en, this message translates to:
  /// **'Black Wins'**
  String get blackWins;

  /// No description provided for @draws.
  ///
  /// In en, this message translates to:
  /// **'Draws'**
  String get draws;

  /// No description provided for @timeoutGames.
  ///
  /// In en, this message translates to:
  /// **'By Timeout'**
  String get timeoutGames;

  /// No description provided for @manualGames.
  ///
  /// In en, this message translates to:
  /// **'Manual Finishes'**
  String get manualGames;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// No description provided for @averageDuration.
  ///
  /// In en, this message translates to:
  /// **'Average Duration'**
  String get averageDuration;

  /// No description provided for @winRate.
  ///
  /// In en, this message translates to:
  /// **'Win Rate'**
  String get winRate;

  /// No description provided for @recentGames.
  ///
  /// In en, this message translates to:
  /// **'Recent Games'**
  String get recentGames;

  /// No description provided for @noGamesFound.
  ///
  /// In en, this message translates to:
  /// **'No games found'**
  String get noGamesFound;

  /// No description provided for @clearStatistics.
  ///
  /// In en, this message translates to:
  /// **'Clear Statistics'**
  String get clearStatistics;

  /// No description provided for @clearStatisticsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all statistics? This action cannot be undone.'**
  String get clearStatisticsConfirm;

  /// No description provided for @deleteStatistics.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteStatistics;

  /// No description provided for @statisticsCleared.
  ///
  /// In en, this message translates to:
  /// **'Statistics cleared successfully'**
  String get statisticsCleared;

  /// No description provided for @errorLoadingStatistics.
  ///
  /// In en, this message translates to:
  /// **'Error loading statistics'**
  String get errorLoadingStatistics;

  /// No description provided for @errorLoadingStatisticsWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error loading statistics: {message}'**
  String errorLoadingStatisticsWithMessage(String message);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get daysAgo;

  /// No description provided for @draw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get draw;

  /// No description provided for @whiteWinsTimeout.
  ///
  /// In en, this message translates to:
  /// **'White wins (timeout)'**
  String get whiteWinsTimeout;

  /// No description provided for @blackWinsTimeout.
  ///
  /// In en, this message translates to:
  /// **'Black wins (timeout)'**
  String get blackWinsTimeout;

  /// No description provided for @whiteWinsManual.
  ///
  /// In en, this message translates to:
  /// **'White wins'**
  String get whiteWinsManual;

  /// No description provided for @blackWinsManual.
  ///
  /// In en, this message translates to:
  /// **'Black wins'**
  String get blackWinsManual;

  /// No description provided for @viewStatistics.
  ///
  /// In en, this message translates to:
  /// **'View Statistics'**
  String get viewStatistics;

  /// No description provided for @statisticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Game history and detailed statistics'**
  String get statisticsSubtitle;

  /// No description provided for @finishGame.
  ///
  /// In en, this message translates to:
  /// **'Finish Game'**
  String get finishGame;

  /// No description provided for @whiteVictory.
  ///
  /// In en, this message translates to:
  /// **'White Victory'**
  String get whiteVictory;

  /// No description provided for @blackVictory.
  ///
  /// In en, this message translates to:
  /// **'Black Victory'**
  String get blackVictory;

  /// No description provided for @drawGame.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get drawGame;

  /// No description provided for @agreementBetweenPlayers.
  ///
  /// In en, this message translates to:
  /// **'Agreement between players'**
  String get agreementBetweenPlayers;

  /// No description provided for @continueGame.
  ///
  /// In en, this message translates to:
  /// **'Continue Game'**
  String get continueGame;

  /// No description provided for @loadingAd.
  ///
  /// In en, this message translates to:
  /// **'Loading ad...'**
  String get loadingAd;

  /// No description provided for @adReady.
  ///
  /// In en, this message translates to:
  /// **'Ad ready!'**
  String get adReady;

  /// No description provided for @debugProMode.
  ///
  /// In en, this message translates to:
  /// **'Debug Pro Mode'**
  String get debugProMode;

  /// No description provided for @debugProModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Activate Pro for testing'**
  String get debugProModeSubtitle;

  /// No description provided for @resumeGame.
  ///
  /// In en, this message translates to:
  /// **'Resume game'**
  String get resumeGame;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// No description provided for @purchaseError.
  ///
  /// In en, this message translates to:
  /// **'Purchase error'**
  String get purchaseError;

  /// No description provided for @paypal.
  ///
  /// In en, this message translates to:
  /// **'PayPal'**
  String get paypal;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @backupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save settings and statistics'**
  String get backupSubtitle;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @restoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Load previously saved backup'**
  String get restoreSubtitle;

  /// No description provided for @createBackup.
  ///
  /// In en, this message translates to:
  /// **'Create Backup'**
  String get createBackup;

  /// No description provided for @backupCreated.
  ///
  /// In en, this message translates to:
  /// **'Backup created successfully'**
  String get backupCreated;

  /// No description provided for @backupError.
  ///
  /// In en, this message translates to:
  /// **'Error creating backup'**
  String get backupError;

  /// No description provided for @restoreBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get restoreBackup;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored successfully'**
  String get backupRestored;

  /// No description provided for @restoreError.
  ///
  /// In en, this message translates to:
  /// **'Error restoring backup'**
  String get restoreError;

  /// No description provided for @backupFileInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid backup file'**
  String get backupFileInvalid;

  /// No description provided for @backupVersionIncompatible.
  ///
  /// In en, this message translates to:
  /// **'Backup version incompatible'**
  String get backupVersionIncompatible;

  /// No description provided for @createBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save all app data'**
  String get createBackupSubtitle;

  /// No description provided for @restoreBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Load data from backup file'**
  String get restoreBackupSubtitle;

  /// No description provided for @backupCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'The backup was created and saved in the Downloads folder'**
  String get backupCreatedMessage;

  /// No description provided for @backupRestoreError.
  ///
  /// In en, this message translates to:
  /// **'Restore Error'**
  String get backupRestoreError;

  /// No description provided for @exportStatistics.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportStatistics;

  /// No description provided for @exportStatisticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save game data to CSV'**
  String get exportStatisticsSubtitle;

  /// No description provided for @exportCsvShareText.
  ///
  /// In en, this message translates to:
  /// **'ChessTime Statistics'**
  String get exportCsvShareText;

  /// No description provided for @exportCsvShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Detailed ChessTime game statistics in CSV format'**
  String get exportCsvShareSubject;

  /// No description provided for @exportCsvSuccess.
  ///
  /// In en, this message translates to:
  /// **'Statistics exported successfully!'**
  String get exportCsvSuccess;

  /// No description provided for @exportCsvNoData.
  ///
  /// In en, this message translates to:
  /// **'No statistics to export or export error.'**
  String get exportCsvNoData;

  /// No description provided for @exportCsvError.
  ///
  /// In en, this message translates to:
  /// **'Error exporting statistics: {error}'**
  String exportCsvError(String error);

  /// No description provided for @restoreBackupConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This action will replace all current data. Do you want to continue?'**
  String get restoreBackupConfirmMessage;

  /// No description provided for @csvHeader.
  ///
  /// In en, this message translates to:
  /// **'Date/Time,Result Type,Winner,Game Duration,White Time Remaining,Black Time Remaining,White Moves,Black Moves,Initial Time,Increment'**
  String get csvHeader;

  /// No description provided for @backupShareTitle.
  ///
  /// In en, this message translates to:
  /// **'ChessTime Backup'**
  String get backupShareTitle;

  /// No description provided for @backupShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Backup of ChessTime settings and statistics'**
  String get backupShareSubject;

  /// No description provided for @backupNoFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get backupNoFileSelected;

  /// No description provided for @backupInvalidFile.
  ///
  /// In en, this message translates to:
  /// **'Invalid file'**
  String get backupInvalidFile;

  /// No description provided for @backupValidationError.
  ///
  /// In en, this message translates to:
  /// **'Unknown validation error'**
  String get backupValidationError;

  /// No description provided for @backupRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup restored successfully'**
  String get backupRestoreSuccess;

  /// No description provided for @backupRestoreErrorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error restoring backup: {error}'**
  String backupRestoreErrorWithMessage(String error);

  /// No description provided for @backupVersionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Invalid backup file: version not found'**
  String get backupVersionNotFound;

  /// No description provided for @backupVersionIncompatibleWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Backup version incompatible. Expected: {expected}, found: {found}'**
  String backupVersionIncompatibleWithDetails(String expected, String found);

  /// No description provided for @backupRequiredFieldMissing.
  ///
  /// In en, this message translates to:
  /// **'Invalid backup file: required field \"{field}\" not found'**
  String backupRequiredFieldMissing(String field);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
  ].contains(locale.languageCode);

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
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
