import 'package:flutter/material.dart';
import 'package:foodinz/providers/meals.dart';
import 'package:provider/provider.dart';

import '../models/food.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({Key? key}) : super(key: key);

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  final listState = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final _favorites = Provider.of<MealsData>(context, listen: true);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: kToolbarHeight,
              width: size.width,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Favorites",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
            Expanded(
              child: AnimatedList(
                key: listState,
                initialItemCount: _favorites.myFavorites.length,
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemBuilder: (_, index, animation) {
                  Food food = _favorites.myFavorites[index];
                  animation = CurvedAnimation(
                      parent: animation, curve: Curves.fastLinearToSlowEaseIn);

                  return SlideTransition(
                    position: Tween<Offset>(
                            begin: Offset(0.0, 0.0), end: Offset(-1.0, 0.0))
                        .animate(animation),
                    child: Container(
                      height: 110.0,
                      width: size.width,
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Text(
                        food.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
