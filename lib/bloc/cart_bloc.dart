import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:foodbar_user/interfaces/bloc_interface.dart';
import 'package:foodbar_user/models/models.dart';
import 'package:foodbar_user/services/services.dart';

class CartEvent {
  OrderedFood add;
  OrderedFood update;
  OrderedFood remove;
  CartEvent({this.add, this.update, this.remove});
}

class CartState {
  Cart cart;
  CartState(this.cart);
}

class CartCounterState {
  int total;
  CartCounterState(this.total);
}

class CartBloc implements BlocInterface<CartEvent, CartState> {
  final StreamController<CartEvent> _eventController = BehaviorSubject<CartEvent>();
  final StreamController<CartState> _stateController = BehaviorSubject<CartState>();
  final StreamController<CartCounterState> _counterStateController = BehaviorSubject<CartCounterState>();


  final OrderService _orderService = OrderService.instace;

  @override
  StreamSink<CartEvent> get eventSink => _eventController.sink;

  @override
  Stream<CartState> get stateStream => _stateController.stream;

  Stream<CartCounterState> get stateCounter => _counterStateController.stream;

  CartBloc() {
    _eventController.stream.listen(handler);
  }

  void handler(CartEvent event) {

    if(event.add != null){
      _orderService.addToCart(event.add);
    }
    if(event.update != null){
      _orderService.updateCart(event.update);
    }
    if(event.remove != null){
      _orderService.removeFromCart(event.remove);
    }
    
    _stateController.add(CartState(_orderService.cart));
    _counterStateController.add(CartCounterState(_orderService.cart.foods.length));
  }

  @override
  void dispose() {
    _eventController.close();
    _stateController.close();
    _counterStateController.close();
  }

  @override
  CartState getInitialState() {
    return CartState(_orderService.cart);
  }

  CartCounterState getInitialCounterState() {
    return CartCounterState(_orderService.cart.foods.length);
  }
}
