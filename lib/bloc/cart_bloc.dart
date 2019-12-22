import 'dart:async';
import 'package:Food_Bar/services/order_service.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

import 'package:flutter/services.dart';

class CartBloc extends Bloc<CartEvent, CartState> {

  OrderService _orderService = OrderService.instace;

  @override
  CartState get initialState => ShowCartState(_orderService.cart);

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    
    if(event is AddToCartEvent){
      AddToCartEvent addEvent = event;
      _orderService.addToCart(addEvent.food);
    }

    else if(event is RemovefromCatEvent){
      RemovefromCatEvent removeEvent = event;
      _orderService.removeFromCart(removeEvent.food);
    }

    yield ShowFoodCountCartState(_orderService.cart.foods.length);
    yield ShowCartState(_orderService.cart);
  }
}
