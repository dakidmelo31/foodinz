import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PromoCode extends StatelessWidget {
  final String restaurantId;
  const PromoCode({Key? key, required this.restaurantId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Card(
        elevation: 15,
        shadowColor: Colors.grey.withOpacity(.3),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.wb_incandescent_outlined,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "You can use this promo code for 10% off for ths restaurant",
                ),
              ),
              Card(
                  color: Theme.of(context).primaryColor,
                  elevation: 0,
                  child: InkWell(
                    onTap: () {
                      debugPrint("show this");
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 15),
                      child: Text("Use Promo",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ))
            ],
          ),
        ));
  }
}
