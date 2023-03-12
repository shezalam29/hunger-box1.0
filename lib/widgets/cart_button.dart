import 'package:flutter/material.dart';
import 'package:hunger_box/global/global.dart';

class CartButton extends IconButton {
  CartButton()
      : super(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () async {
              print("Cart Button pressed");
              print(FBH.getCurrentUserCart());
            });
}
