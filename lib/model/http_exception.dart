class Http_Exception implements Exception {
  final String Message;

  Http_Exception(this.Message);

  @override
  String toString() {
    // TODO: implement toString

    return Message;
  }
}
