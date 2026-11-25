import '../../../l10n/app_localizations.dart';
import '../domain/authentication_repository.dart';

String authenticationErrorMessage(AppLocalizations l10n, Object error) =>
    switch (AuthenticationFailure.from(error)) {
      AuthenticationFailure.connection => l10n.networkError,
      AuthenticationFailure.configuration => l10n.signInConfigurationError,
      _ => l10n.authenticationError,
    };
