abstract class OrderScreenEvent {}


class SearchMyOrder extends OrderScreenEvent {
  final String userID;
  final String searchText;

  SearchMyOrder(this.userID,this.searchText);

}
