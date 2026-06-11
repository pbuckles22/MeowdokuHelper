/// Service-related exceptions for app services.
library;

/// Base class for all service exceptions
abstract class ServiceException implements Exception {
  /// Creates a new service exception
  const ServiceException(this.message, [this.details]);

  /// The main error message
  final String message;

  /// Optional additional details about the error
  final String? details;

  @override
  String toString() => details != null ? '$message: $details' : message;
}

/// Exception thrown when FFI initialization fails
class FfiInitializationException extends ServiceException {
  /// Creates an FFI initialization failure exception.
  const FfiInitializationException([String? details])
    : super('Failed to initialize FFI', details);
}
