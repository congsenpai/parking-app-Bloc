


abstract class OrderDetailScreenEvent {}
class OrderDetailEvent extends OrderDetailScreenEvent {
  final String transactionID;
  OrderDetailEvent(this.transactionID);
}