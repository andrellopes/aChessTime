// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'a Chess Time';

  @override
  String get close => 'Zamknij';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Anuluj';

  @override
  String get save => 'Zapisz';

  @override
  String get saveAndClose => 'Zapisz i zamknij';

  @override
  String get settings => 'Ustawienia';

  @override
  String get about => 'O aplikacji';

  @override
  String get resetConfirm => 'Czy na pewno chcesz zresetować partię?';

  @override
  String get confirm => 'Potwierdź';

  @override
  String get tapToStart => 'Dotknij, aby rozpocząć';

  @override
  String get gameOver => 'Koniec partii';

  @override
  String get victory => 'Zwycięstwo!';

  @override
  String get player1 => 'Gracz 1';

  @override
  String get player2 => 'Gracz 2';

  @override
  String get winner => 'Zwycięzca';

  @override
  String get whitePlayer => 'Białe';

  @override
  String get blackPlayer => 'Czarne';

  @override
  String get turnOf => 'Ruch';

  @override
  String get won => 'wygrywają!';

  @override
  String get play => 'Start';

  @override
  String get pause => 'Pauza';

  @override
  String get reset => 'Resetuj';

  @override
  String get swapColors => 'Zamień kolory';

  @override
  String get quickSettings => 'Szybkie ustawienia';

  @override
  String get options => 'Opcje';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get appearance => 'Wygląd';

  @override
  String get language => 'Język';

  @override
  String get gameSettings => 'Ustawienia gry';

  @override
  String get timeControls => 'Kontrola czasu';

  @override
  String get sounds => 'Dźwięki';

  @override
  String get other => 'Inne';

  @override
  String get help => 'Pomoc';

  @override
  String get darkMode => 'Tryb ciemny';

  @override
  String get darkModeSubtitle => 'Interfejs w ciemnym motywie';

  @override
  String get soundsSubtitle => 'Dźwięki podczas gry';

  @override
  String get vibration => 'Wibracje';

  @override
  String get vibrationSubtitle => 'Wibruj przy zmianie tury';

  @override
  String get player1StartsAsWhite => 'Gracz 1 zaczyna białymi';

  @override
  String get initialTime => 'Czas początkowy';

  @override
  String get increment => 'Przyrost';

  @override
  String get timePreset => 'Ustawienie czasu';

  @override
  String get timePresets => 'Ustawienia czasu';

  @override
  String get custom => 'Własne';

  @override
  String get menu => 'Menu';

  @override
  String get immersiveMode => 'Tryb immersyjny';

  @override
  String get immersiveModeSubtitle =>
      'Ukryj paski systemowe, aby korzystać z pełnego ekranu';

  @override
  String get presetTournament => 'Turniej';

  @override
  String get presetBlitz => 'Blitz';

  @override
  String get presetBullet => 'Bullet';

  @override
  String get presetRapid => 'Rapid';

  @override
  String get presetClassical => 'Klasyczna';

  @override
  String get presetLong => 'Długa partia';

  @override
  String get presetBasic => 'Podstawowy';

  @override
  String get createCustomPreset => 'Utwórz własny preset';

  @override
  String get editPreset => 'Edytuj preset';

  @override
  String get presetName => 'Nazwa presetu';

  @override
  String get presetNameHint => 'Np. Pro Blitz';

  @override
  String get presetCreated => 'Preset został utworzony';

  @override
  String get presetUpdated => 'Preset został zaktualizowany';

  @override
  String get presetDeleted => 'Preset został usunięty';

  @override
  String get deletePresetConfirm => 'Usuń preset';

  @override
  String get create => 'Utwórz';

  @override
  String get edit => 'Edytuj';

  @override
  String get delete => 'Usuń';

  @override
  String get aboutTitle => 'Informacje o a Chess Time';

  @override
  String get aboutContactLinks => 'Kontakt i linki';

  @override
  String get contactGitHub => 'GitHub';

  @override
  String get contactEmail => 'E-mail';

  @override
  String get contactWhatsApp => 'WhatsApp';

  @override
  String get aboutSupportMessage => 'Wesprzyj rozwój tej aplikacji!';

  @override
  String get aboutSupportWithPix => 'Wesprzyj przez PIX';

  @override
  String get aboutPixCopied => 'Klucz PIX został skopiowany do schowka!';

  @override
  String get developedBy => 'Autor: André Lopes';

  @override
  String get resetTooltip => 'Zresetuj partię';

  @override
  String get swapTooltip => 'Zamień kolory graczy';

  @override
  String get settingsTooltip => 'Ustawienia';

  @override
  String get aboutTooltip => 'O aplikacji';

  @override
  String get advancedSettings => 'Ustawienia zaawansowane';

  @override
  String get evaluateInPlayStore => 'Oceń w Play Store';

  @override
  String get share => 'Udostępnij';

  @override
  String get aboutApp => 'O aplikacji';

  @override
  String get linkCopied => 'Link został skopiowany do schowka!';

  @override
  String get shareMessage =>
      'Sprawdź ChessTime - prosty i nowoczesny zegar szachowy!';

  @override
  String get minutes => 'Minuty';

  @override
  String get seconds => 'Sekundy';

  @override
  String get minutesShort => 'min';

  @override
  String get secondsShort => 's';

  @override
  String minutesUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# minuty',
      many: '# minut',
      few: '# minuty',
      one: '# minuta',
    );
    return '$_temp0';
  }

  @override
  String secondsUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# sekundy',
      many: '# sekund',
      few: '# sekundy',
      one: '# sekunda',
    );
    return '$_temp0';
  }

  @override
  String get playerWon => 'wygrywają!';

  @override
  String get moves => 'Ruchy';

  @override
  String movesCount(int count) {
    return '$count';
  }

  @override
  String victoryMessage(String winnerName) {
    return '$winnerName wygrywają!';
  }

  @override
  String get fontSizeTitle => 'Rozmiar czcionki zegara';

  @override
  String get fontSizeSubtitle => 'Dostosuj dla lepszej czytelności';

  @override
  String get themeTitle => 'Motyw';

  @override
  String get themeSubtitle => 'Wybierz wygląd aplikacji';

  @override
  String get themeClassicDark => 'Klasyczny ciemny';

  @override
  String get themeTraditionalBoard => 'Tradycyjna szachownica';

  @override
  String get themeGreenFocus => 'Zielone skupienie';

  @override
  String get themeTournamentBlue => 'Turniejowy niebieski';

  @override
  String get themeRoyalGold => 'Królewskie złoto';

  @override
  String get themeGrandmasterPurple => 'Arcymistrzowski fiolet';

  @override
  String get themeCompetitiveRed => 'Rywalizacyjna czerwień';

  @override
  String get themeDeepOcean => 'Głęboki ocean';

  @override
  String get themeMysticForest => 'Mistyczny las';

  @override
  String get themeElegantRose => 'Elegancka róża';

  @override
  String get themePremiumSilver => 'Srebrny Premium';

  @override
  String get themeAuroraBoreal => 'Zorza polarna';

  @override
  String get themeCustom => 'Niestandardowy';

  @override
  String get premiumThemeRequired => 'Motyw premium - wymaga wersji Pro';

  @override
  String get unlockPremiumThemes => 'Odblokuj motywy premium';

  @override
  String get premiumThemesDescription =>
      'Odblokuj ekskluzywne motywy i usuń reklamy dzięki wersji Pro';

  @override
  String get proFeature1 => 'Dostęp do 8 ekskluzywnych motywów';

  @override
  String get proFeature2 => 'Motywy zoptymalizowane pod czytelność';

  @override
  String get proFeature3 => 'Usuń reklamy';

  @override
  String get proFeature4 => 'Wesprzyj rozwój aplikacji';

  @override
  String get proFeature5 => 'Obejmuje przyszłe aktualizacje';

  @override
  String get buyPro => 'Kup wersję Pro';

  @override
  String purchaseFor(String price) {
    return 'Kup za $price';
  }

  @override
  String get processing => 'Przetwarzanie...';

  @override
  String get unavailable => 'Niedostępne';

  @override
  String get restorePurchases => 'Przywróć zakupy';

  @override
  String get upgradeToProTitle => 'Przejdź na wersję Pro';

  @override
  String get upgradeToProSubtitle => '8 motywów premium + bez reklam';

  @override
  String get statistics => 'Statystyki';

  @override
  String get statisticsTitle => 'Statystyki';

  @override
  String get generalSummary => 'Podsumowanie ogólne';

  @override
  String get totalGames => 'Liczba partii';

  @override
  String get whiteWins => 'Wygrane białych';

  @override
  String get blackWins => 'Wygrane czarnych';

  @override
  String get draws => 'Remisy';

  @override
  String get timeoutGames => 'Przekroczenie czasu';

  @override
  String get manualGames => 'Ręczne zakończenia';

  @override
  String get totalTime => 'Łączny czas';

  @override
  String get averageDuration => 'Średni czas partii';

  @override
  String get winRate => 'Wskaźnik zwycięstw';

  @override
  String get recentGames => 'Ostatnie partie';

  @override
  String get noGamesFound => 'Nie znaleziono partii';

  @override
  String get clearStatistics => 'Wyczyść statystyki';

  @override
  String get clearStatisticsConfirm =>
      'Czy na pewno chcesz usunąć wszystkie statystyki? Tej operacji nie można cofnąć.';

  @override
  String get deleteStatistics => 'Usuń';

  @override
  String get statisticsCleared => 'Statystyki zostały wyczyszczone';

  @override
  String get errorLoadingStatistics => 'Błąd podczas wczytywania statystyk';

  @override
  String errorLoadingStatisticsWithMessage(String message) {
    return 'Błąd podczas wczytywania statystyk: $message';
  }

  @override
  String get today => 'Dziś';

  @override
  String get yesterday => 'Wczoraj';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '# dnia temu',
      many: '# dni temu',
      few: '# dni temu',
      one: '# dzień temu',
      zero: 'dziś',
    );
    return '$_temp0';
  }

  @override
  String get draw => 'Remis';

  @override
  String get whiteWinsTimeout => 'Białe wygrywają na czas';

  @override
  String get blackWinsTimeout => 'Czarne wygrywają na czas';

  @override
  String get whiteWinsManual => 'Białe wygrywają';

  @override
  String get blackWinsManual => 'Czarne wygrywają';

  @override
  String get viewStatistics => 'Zobacz statystyki';

  @override
  String get statisticsSubtitle => 'Historia partii i szczegółowe statystyki';

  @override
  String get finishGame => 'Zakończ partię';

  @override
  String get whiteVictory => 'Wygrana białych';

  @override
  String get blackVictory => 'Wygrana czarnych';

  @override
  String get drawGame => 'Remis';

  @override
  String get agreementBetweenPlayers => 'Remis za zgodą obu graczy';

  @override
  String get continueGame => 'Kontynuuj grę';

  @override
  String get loadingAd => 'Ładowanie reklamy...';

  @override
  String get adReady => 'Reklama gotowa!';

  @override
  String get debugProMode => 'Tryb debugowania Pro';

  @override
  String get debugProModeSubtitle => 'Włącz Pro do testów';

  @override
  String get resumeGame => 'Wznów partię';

  @override
  String get productNotFound => 'Nie znaleziono produktu';

  @override
  String get purchaseError => 'Błąd zakupu';

  @override
  String get paypal => 'PayPal';

  @override
  String get backup => 'Kopia zapasowa';

  @override
  String get backupSubtitle => 'Zapisz ustawienia i statystyki';

  @override
  String get restore => 'Przywróć';

  @override
  String get restoreSubtitle => 'Wczytaj wcześniej utworzoną kopię zapasową';

  @override
  String get createBackup => 'Utwórz kopię zapasową';

  @override
  String get backupCreated => 'Kopia zapasowa została utworzona';

  @override
  String get backupError => 'Błąd podczas tworzenia kopii zapasowej';

  @override
  String get restoreBackup => 'Przywróć kopię zapasową';

  @override
  String get backupRestored => 'Kopia zapasowa została przywrócona';

  @override
  String get restoreError => 'Błąd podczas przywracania';

  @override
  String get backupFileInvalid => 'Nieprawidłowy plik kopii zapasowej';

  @override
  String get backupVersionIncompatible => 'Niezgodna wersja kopii zapasowej';

  @override
  String get createBackupSubtitle => 'Zapisz wszystkie dane aplikacji';

  @override
  String get restoreBackupSubtitle => 'Wczytaj dane z pliku kopii zapasowej';

  @override
  String get backupCreatedMessage =>
      'Kopia zapasowa została utworzona i zapisana w folderze Pobrane';

  @override
  String get backupRestoreError => 'Błąd przywracania';

  @override
  String get exportStatistics => 'Eksportuj CSV';

  @override
  String get exportStatisticsSubtitle => 'Zapisz dane partii do pliku CSV';

  @override
  String get exportCsvShareText => 'Statystyki ChessTime';

  @override
  String get exportCsvShareSubject =>
      'Szczegółowe statystyki partii ChessTime w formacie CSV';

  @override
  String get exportCsvSuccess => 'Statystyki zostały wyeksportowane!';

  @override
  String get exportCsvNoData =>
      'Brak statystyk do eksportu lub wystąpił błąd eksportu.';

  @override
  String exportCsvError(String error) {
    return 'Błąd podczas eksportowania statystyk: $error';
  }

  @override
  String get restoreBackupConfirmMessage =>
      'Ta operacja zastąpi wszystkie bieżące dane. Czy chcesz kontynuować?';

  @override
  String get csvHeader =>
      'Data/Godzina,Typ wyniku,Zwycięzca,Czas partii,Pozostały czas białych,Pozostały czas czarnych,Ruchy białych,Ruchy czarnych,Czas początkowy,Czas początkowy czarnych (handicap),Przyrost,Tryb czasu';

  @override
  String get backupShareTitle => 'Kopia zapasowa ChessTime';

  @override
  String get backupShareSubject =>
      'Kopia zapasowa ustawień i statystyk ChessTime';

  @override
  String get backupNoFileSelected => 'Nie wybrano pliku';

  @override
  String get backupInvalidFile => 'Nieprawidłowy plik';

  @override
  String get backupValidationError => 'Nieznany błąd walidacji';

  @override
  String get backupRestoreSuccess => 'Kopia zapasowa została przywrócona';

  @override
  String backupRestoreErrorWithMessage(String error) {
    return 'Błąd podczas przywracania kopii zapasowej: $error';
  }

  @override
  String get backupVersionNotFound =>
      'Nieprawidłowy plik kopii zapasowej: nie znaleziono wersji';

  @override
  String backupVersionIncompatibleWithDetails(String expected, String found) {
    return 'Wersja kopii zapasowej jest niezgodna. Oczekiwano: $expected, znaleziono: $found';
  }

  @override
  String backupRequiredFieldMissing(String field) {
    return 'Nieprawidłowy plik kopii zapasowej: wymagane pole \"$field\" nie zostało znalezione';
  }

  @override
  String get arbiterMode => 'Tryb arbitra';

  @override
  String get penaltyBonusTime => 'Kara / bonus czasowy';

  @override
  String get tapPlayerButtonToApply =>
      'Dotknij przycisku gracza, aby zastosować zmianę';

  @override
  String get penalty => 'KARA';

  @override
  String get bonus => 'BONUS';

  @override
  String get timeMode => 'Tryb czasu';

  @override
  String get modeFischer => 'Fischer';

  @override
  String get modeBronstein => 'Bronstein';

  @override
  String get modeUSDelay => 'Opóźnienie US';

  @override
  String get modeNone => 'Brak';

  @override
  String get handicap => 'Handicap';

  @override
  String get differentTimesPerPlayer => 'Różny czas dla każdego gracza';

  @override
  String get fieldRequired => 'To pole jest wymagane';

  @override
  String get fideStandardTitle => 'Standard turniejowy';

  @override
  String get fideStandardFideMode => 'TRYB FISCHERA FIDE';

  @override
  String get fideStandardDescription =>
      'Zgodnie z oficjalnymi zasadami FIDE przyrost jest dodawany do czasu początkowego jeszcze przed pierwszym ruchem.\n\nJak ma działać aplikacja?';

  @override
  String get fideStandardProfessional => 'Profesjonalny (FIDE)';

  @override
  String get fideStandardProfessionalSub =>
      'Zegar startuje z doliczonym przyrostem';

  @override
  String get fideStandardClassic => 'Klasyczny (oryginalny)';

  @override
  String get fideStandardClassicSub => 'Zegar startuje tylko z czasem bazowym';

  @override
  String get fideStandardSettingsNote =>
      'Możesz to później zmienić w Ustawieniach.';

  @override
  String get fideStandardSettingTitle => 'Standard Fischera FIDE';

  @override
  String get fideStandardSettingSubtitle =>
      'Dodaj przyrost przed pierwszym ruchem';
}
