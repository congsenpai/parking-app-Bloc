// ignore_for_file: unused_import

import 'package:flutter/material.dart';


abstract class OrderScreenEvent {}


class SearchMyOrder extends OrderScreenEvent {
  final String userID;
  final String searchText;

  SearchMyOrder(this.userID,this.searchText);

}
