abstract class WalletEvent {}

class GetDataWalletEvent extends WalletEvent {
  final String userID;
  GetDataWalletEvent(this.userID);
}
class AddNewWalletEvent extends WalletEvent{

}
