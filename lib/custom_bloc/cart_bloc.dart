import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:Food_Bar/interfaces/bloc_interface.dart';
import 'package:Food_Bar/models/models.dart';
import 'package:Food_Bar/services/services.dart';

class CartEvent {
  Food add;
  Food remove;
  CartEvent({this.add, this.remove});
}

class CartState {
  Cart cart;
  CartState(this.cart);
}

class CartBloc implements BlocInterface<CartEvent, CartState> {
  final StreamController<CartEvent> _eventController = BehaviorSubject<CartEvent>();
  final StreamController<CartState> _stateController = BehaviorSubject<CartState>();

  final OrderService _orderService = OrderService.instace;

  @override
  StreamSink<CartEvent> get eventSink => _eventController.sink;

  @override
  Stream<CartState> get stateStream => _stateController.stream;

  CartBloc() {
    _eventController.stream.listen(_handler);
  }

  void _handler(CartEvent event) {

    if(event.add != null){
      _orderService.addToCart(event.add);
    }
    if(event.remove != null){
      _orderService.removeFromCart(event.remove);
    }
    
    _stateController.add(CartState(_orderService.cart));
  }

  @override
  void dispose() {
    _eventController.close();
    _stateController.close();
  }

  @override
  CartState getInitialState() {
    return CartState(_orderService.cart);
  }
}
