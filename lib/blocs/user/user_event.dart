abstract class UserEvent {}
class InitstateEvent extends UserEvent{
  final String userId;
  InitstateEvent(this.userId);
}
class ChangeProfileEvent extends UserEvent {
  final String userID;
  final String userName;
  final String email;
  final    String phone;
  final String userImg;
  final    String country;
  final String userAddress;
  final    List<Map<String, String>> vehicle;

  ChangeProfileEvent(this.userID,
      this.userName,
      this.email,
      this.phone,
      this.userImg,
      this.country,
      this.userAddress,
      this.vehicle);

}

