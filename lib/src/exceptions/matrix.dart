import 'package:open_route_service/src/exceptions/base.dart';

/// Exception thrown when Matrix data cannot be correctly parsed.
class MatrixORSParsingException extends ORSParsingException {
  /// Creates a [MatrixORSParsingException] instance.
  ///
  /// - [uri]: the URI associated with the request (if any).
  /// - [cause]: the underlying exception (if any).
  /// - [causeStackTrace]: the accompanying stack trace (if any).
  const MatrixORSParsingException({
    Uri? uri,
    Object? cause,
    StackTrace? causeStackTrace,
  }) : super(
          message:
              'Matrix value cannot be determined from the given inputs as specified in https://openrouteservice.org/dev/#/api-docs/v2/matrix/{profile}/post.',
          uri: uri,
          cause: cause,
          causeStackTrace: causeStackTrace,
        );
}
