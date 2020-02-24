import 'dart:async';
import 'package:Food_Bar/models/order.dart';
import 'package:rxdart/rxdart.dart';

import 'package:Food_Bar/interfaces/bloc_interface.dart';
import 'package:Food_Bar/interfaces/content_provider.dart';
import 'package:Food_Bar/services/services.dart';

class OrderBloc implements BlocInterface<OrderEvent, OrderState> {
  StreamController<OrderState> _stateController = BehaviorSubject();
  StreamController<OrderEvent> _eventController = BehaviorSubject();

  ContentProvider _contentService = ContentService.instance;

  OrderBloc() {
    _eventController.stream.listen(handler);
  }

  @override
  StreamSink<OrderEvent> get eventSink => _eventController.sink;

  @override
  Stream<OrderState> get stateStream => _stateController.stream;

  @override
  OrderState getInitialState() {
    return OrderState();
  }

  @override
  void handler(OrderEvent event) async {
    OrderState state;

    if (event is GetOldOrderTables) {
      await _contentService.getOrders().then((orderList) {
        state = OrderState(orderList);
      });

    } else if (event is CancelOrderTable) {
      
    }

    if (state != null) _stateController.add(state);
  }

  @override
  void dispose() {
    _stateController.close();
    _eventController.close();
  }
}

class OrderEvent {}

class GetOldOrderTables extends OrderEvent {}

class CancelOrderTable extends OrderEvent {
  String orderId;
  CancelOrderTable(this.orderId);
}

class OrderState {
  List<Order> orderList;
  OrderState([this.orderList = const []]);
}
