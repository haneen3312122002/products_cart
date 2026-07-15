import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:products_cart/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:products_cart/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'app/root_screen.dart';
import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // standard mobile design baseline (iPhone X/11/12/13 mini class) — use this since no existing design exists
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<FavoriteCubit>(
              create: (_) => sl<FavoriteCubit>()..loadFavorites(),
            ),
            BlocProvider<CartCubit>(
              create: (_) => sl<CartCubit>()..loadCart(),
            ),
          ],
          child: MaterialApp(
            title: 'Products Cart',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const RootScreen(),
          ),
        );
      },
    );
  }
}
