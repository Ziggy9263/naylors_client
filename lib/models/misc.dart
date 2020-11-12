class APIError {
  String message;
  String stack;

  APIError(message, stack) : assert(message != null);
}
