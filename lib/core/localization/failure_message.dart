import '../../l10n/app_localizations.dart';
import '../errors/app_failure.dart';

String? failureMessage(AppLocalizations l10n, AppFailure failure) =>
    switch (failure.kind) {
      FailureKind.connection => l10n.networkError,
      FailureKind.timeout => l10n.timeoutError,
      FailureKind.validation => l10n.validationError,
      FailureKind.unauthorized => l10n.unauthorizedError,
      FailureKind.forbidden => l10n.forbiddenError,
      FailureKind.notFound => l10n.notFoundError,
      FailureKind.rateLimited => l10n.rateLimitedError,
      FailureKind.server => l10n.serverError,
      FailureKind.serviceUnavailable => l10n.serviceUnavailableError,
      FailureKind.malformedResponse => l10n.malformedResponseError,
      FailureKind.cancelled => null,
      FailureKind.unexpected => l10n.unexpectedError,
    };
