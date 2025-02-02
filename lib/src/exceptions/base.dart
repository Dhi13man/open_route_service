/// The base exception class for the Open Route Service client, including an error [message],
/// optional request [uri], underlying [cause], and corresponding [causeStackTrace].
abstract class ORSClientBaseException implements Exception {
  /// Creates an [ORSClientBaseException] instance.
  ///
  /// - [message]: the error message.
  /// - [uri]: the URI where the error occurred (if applicable).
  /// - [cause]: the underlying exception or error (if any).
  /// - [causeStackTrace]: the stack trace of the underlying exception (if any).
  const ORSClientBaseException(
    this.message, {
    this.uri,
    this.cause,
    this.causeStackTrace,
  });

  /// The error message associated with the exception.
  final String message;

  /// The URI where the error occurred, if applicable.
  final Uri? uri;

  /// The underlying exception or error, if available.
  final Object? cause;

  /// The stack trace of the underlying exception, if available.
  final StackTrace? causeStackTrace;

  @override
  String toString() {
    final String causeStr = cause != null ? ', cause: $cause' : '';
    final String stackStr =
        causeStackTrace != null ? ', stack: $causeStackTrace' : '';
    return '$runtimeType: $message${uri != null ? ', at url $uri' : ''}$causeStr$stackStr';
  }
}

/// Exception thrown during HTTP requests indicating request failures.
class ORSHttpException extends ORSClientBaseException {
  /// Creates an [ORSHttpException] instance.
  ///
  /// - [uri]: the URI of the request.
  /// - [statusCode]: the HTTP status code.
  /// - [errorResponse]: the error response from the server (if any).
  /// - [cause]: the underlying exception (if any).
  /// - [causeStackTrace]: the accompanying stack trace (if any).
  const ORSHttpException({
    required Uri uri,
    required this.statusCode,
    this.errorResponse,
    Object? cause,
    StackTrace? causeStackTrace,
  }) : super(
          'Error during HTTP request',
          uri: uri,
          cause: cause,
          causeStackTrace: causeStackTrace,
        );

  /// The HTTP status code returned from the request.
  final int statusCode;

  /// The error response returned by the server, if any.
  final Object? errorResponse;
}

/// Exception thrown when an error occurs during data parsing.
class ORSParsingException extends ORSClientBaseException {
  /// Creates an [ORSParsingException] instance.
  ///
  /// - [message]: a custom error message. Defaults to 'Error while parsing data' if not provided.
  /// - [uri]: the URI associated with the parsing error (if any).
  /// - [cause]: the underlying exception (if any).
  /// - [causeStackTrace]: the accompanying stack trace (if any).
  const ORSParsingException({
    String? message,
    Uri? uri,
    Object? cause,
    StackTrace? causeStackTrace,
  }) : super(
          message ?? 'Error while parsing data',
          uri: uri,
          cause: cause,
          causeStackTrace: causeStackTrace,
        );
}
