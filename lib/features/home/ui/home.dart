import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_project/features/cart/ui/cart.dart';
import 'package:flutter_bloc_project/features/home/bloc/home_bloc.dart';
import 'package:flutter_bloc_project/features/home/ui/product_tile_widget.dart';
import 'package:flutter_bloc_project/features/wishlist/ui/wishlist.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    homeBloc.add(
      HomeInitialEvent(),
    );
    super.initState();
  }

  final HomeBloc homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToCartPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Cart(),
            ),
          );
        } else if (state is HomeNavigateToWishListPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WishList(),
            ),
          );
        } else if (state is HomeProductItemCartedActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item Carted'),
            ),
          );
        } else if (state is HomeProductItemWishListedActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item Wishlisted'),
            ),
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case HomeLoadedSuccessState:
            final successState = state as HomeLoadedSuccessState;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.teal,
                centerTitle: true,
                title: const Text('Grocery App'),
                actions: [
                  IconButton(
                    onPressed: () {
                      homeBloc.add(
                        HomeWishListButtonNavigateEvent(),
                      );
                    },
                    icon: const Icon(Icons.favorite_border_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      homeBloc.add(
                        HomeCartButtonNavigateEvent(),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                  ),
                ],
              ),
              body: ListView.builder(
                itemCount: successState.products.length,
                itemBuilder: (context, index) {
                  return ProductTileWidget(
                      homeBloc: homeBloc,
                      productDataModel: successState.products[index]);
                },
              ),
            );
          case HomeErrorState:
            return const Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
