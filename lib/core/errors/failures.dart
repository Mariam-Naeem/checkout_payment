abstract class failure {
  String message;
  failure(this.message);
}
class serverFailure extends failure {
  serverFailure(super.message);
}