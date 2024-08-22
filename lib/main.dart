import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopesapp/logic/cubites/user/auth_cubit.dart';
import 'package:shopesapp/logic/cubites/cubit/settings/internet_cubit.dart';
import 'package:shopesapp/logic/cubites/user/profile_cubit.dart';
import 'package:shopesapp/logic/cubites/post/show_favorite_posts_cubit.dart';
import 'package:shopesapp/logic/cubites/post/toggle_post_favorite_cubit.dart';
import 'package:shopesapp/logic/cubites/post/filter_cubit.dart';
import 'package:shopesapp/logic/cubites/post/post_favorite_cubit.dart';
import 'package:shopesapp/logic/cubites/post/posts_cubit.dart';
import 'package:shopesapp/logic/cubites/post/rate_shop_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/search_store_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/show_favorite_stores_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/toggole_favorite_shop_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/toggole_follow_shop_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/favorite_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/following_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/get_shops_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/rate_shop_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/shop_follwers_counter_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/store_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/switch_shop_cubit.dart';
import 'package:shopesapp/logic/cubites/shop/work_time_cubit.dart';
import 'package:shopesapp/presentation/router/app_roter.dart';
import 'package:flutter/material.dart';
import 'package:shopesapp/translation/codegen_loader.g.dart';
import 'constant/themes.dart';
import 'logic/cubites/cubit/settings/get_caht_messages_cubit.dart';
import 'logic/cubites/user/verify_password_cubit.dart';
import 'logic/cubites/cubit/settings/Themes/themes_cubit.dart';
import 'logic/cubites/shop/get_owner_shops_cubit.dart';

late SharedPreferences globalSharedPreference;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globalSharedPreference = await SharedPreferences.getInstance();
  await EasyLocalization.ensureInitialized();
  await Settings.init(cacheProvider: SharePreferenceCache());
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getApplicationDocumentsDirectory());

  AppRouter appRouter = AppRouter();
  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    assetLoader: const CodegenLoader(),
    startLocale: const Locale.fromSubtags(languageCode: 'en'),
    child: MyApp(
      appRouter: appRouter,
      connectivity: Connectivity(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.appRouter, required this.connectivity})
      : super(key: key);

  final AppRouter appRouter;
  final Connectivity connectivity;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InternetCubit>(
          create: (context) => InternetCubit(connectivity: connectivity),
          lazy: false,
        ),
        BlocProvider<PostsCubit>(
          create: (context) => PostsCubit(),
        ),
        BlocProvider<SearchStoreCubit>(
          create: (context) => SearchStoreCubit(),
        ),
        BlocProvider<GetShopsCubit>(
          create: (context) => GetShopsCubit(),
        ),
        BlocProvider<StoreCubit>(
          create: (context) => StoreCubit(),
          lazy: false,
        ),
        BlocProvider<GetOwnerShopsCubit>(
          create: (context) => GetOwnerShopsCubit(),
        ),
        BlocProvider<ThemesCubit>(
          create: ((context) => ThemesCubit()),
          lazy: false,
        ),
        BlocProvider<PostFavoriteCubit>(
          create: (context) => PostFavoriteCubit(),
        ),
        BlocProvider<FavoriteCubit>(
          create: (context) => FavoriteCubit(),
        ),
        BlocProvider<ShowFavoritePostsCubit>(
          create: (context) => ShowFavoritePostsCubit(),
        ),
        BlocProvider<ShowFavoriteStoresCubit>(
          create: (context) => ShowFavoriteStoresCubit(),
        ),
        BlocProvider<ProfileCubit>(
          create: ((context) => ProfileCubit()..initVerified()),
          lazy: false,
        ),
        BlocProvider<SwitchShopCubit>(
          create: (context) => SwitchShopCubit(),
        ),
        BlocProvider<VerifyPasswordCubit>(
          create: ((context) => VerifyPasswordCubit()),
        ),
        BlocProvider<AuthCubit>(
          create: ((context) => AuthCubit()..autoLogIn()),
          lazy: false,
        ),
        BlocProvider<FollowingCubit>(
          create: (context) => FollowingCubit(),
          lazy: false,
        ),
        BlocProvider<ToggoleFollowShopCubit>(
          create: (context) => ToggoleFollowShopCubit(),
          lazy: false,
        ),
        BlocProvider<ToggoleFavoriteShopCubit>(
          create: (context) => ToggoleFavoriteShopCubit(),
          lazy: false,
        ),
        BlocProvider<TogglePostFavoriteCubit>(
          create: (context) => TogglePostFavoriteCubit(),
          lazy: false,
        ),
        BlocProvider<ShowFavoritePostsCubit>(
          create: (context) => ShowFavoritePostsCubit(),
          lazy: false,
        ),
        BlocProvider<RateShopCubit>(
          create: (context) => RateShopCubit(),
          lazy: false,
        ),
        BlocProvider<RatePostCubit>(
          create: (context) => RatePostCubit(),
          lazy: false,
        ),
        BlocProvider<ShopFollwersCounterCubit>(
          create: (context) => ShopFollwersCounterCubit(),
          lazy: false,
        ),
        BlocProvider<FilterCubit>(
          create: (context) => FilterCubit(),
          lazy: false,
        ),
        BlocProvider<WorkTimeCubit>(
          create: (context) => WorkTimeCubit(),
        ),
        BlocProvider<GetCahtMessagesCubit>(
          create: (context) => GetCahtMessagesCubit(),
        ),
      ],
      child: BlocBuilder<ThemesCubit, ThemesState>(
        builder: (context, state) {
          return Builder(builder: (context) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              title: 'ShopsApp',
              debugShowCheckedModeBanner: false,
              theme: themeArray[state.themeIndex],
              onGenerateRoute: appRouter.onGeneratedRoutes,
            );
          });
        },
      ),
    );
  }
}
