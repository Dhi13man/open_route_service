import 'package:open_route_service/src/exceptions/base.dart';

/// Exception thrown when the POIs data is empty.
class PoisEmptyORSParsingException extends ORSParsingException {
  /// Creates a [PoisEmptyORSParsingException] instance.
  ///
  /// - [uri]: the URI associated with the request (if any).
  /// - [cause]: the underlying exception (if any).
  /// - [causeStackTrace]: the accompanying stack trace (if any).
  const PoisEmptyORSParsingException({
    Uri? uri,
    Object? cause,
    StackTrace? causeStackTrace,
  }) : super(
          message:
              'Empty POIs data received. Verify that the input is correct and the endpoint is working as documented at https://openrouteservice.org/dev/#/api-docs/pois. If the endpoint is functional, your input may be invalid.',
          uri: uri,
          cause: cause,
          causeStackTrace: causeStackTrace,
        );
}
