import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/logic/cubites/user/auth_cubit.dart';
import 'package:shopesapp/logic/cubites/user/auth_state.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/presentation/pages/settings.dart';
import 'package:shopesapp/presentation/pages/store_page.dart';
import 'package:shopesapp/presentation/pages/home_page.dart';
import 'package:shopesapp/presentation/pages/suggested_stores.dart';
import 'package:shopesapp/presentation/widgets/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../../data/enums/bottom_navigation.dart';
import '../../data/models/shop.dart';
import '../../data/data base/shared_preferences_repository.dart';
import '../../logic/cubites/post/posts_cubit.dart';
import '../../logic/cubites/shop/get_owner_shops_cubit.dart';
import '../../logic/cubites/shop/get_shops_cubit.dart';
import '../../logic/cubites/shop/work_time_cubit.dart';
import '../widgets/switch_shop/browsing_mode_profile.dart';
import '../widgets/switch_shop/no_selected_store.dart';
import 'favourite_page.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  @override
  void initState() {
    super.initState();
  }

  BottomNavigationEnum selected = BottomNavigationEnum.HOME;
  PageController controller = PageController(initialPage: 2);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          bottomNavigationBar: BottomNavigationBarWidget(
              bottomNavigationEnum: selected,
              onTap: (selectedEnum, pageNumber) {
                controller.animateToPage(pageNumber,
                    curve: Curves.easeInCirc,
                    duration: const Duration(milliseconds: 100));
                setState(() {
                  selected = selectedEnum;
                });
              }),
          body: PageView(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (value) {},
            children: [
              const SettingsPage(),
              const SuggestedStoresView(),
              const HomePage(),
              const FavouritePage(),
              (SharedPreferencesRepository.getBrowsingPostsMode())
                  ? browsingModeProfile(size, "brwosing")
                  : BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state is UserLoginedIn ||
                            state is UserSignedUp ||
                            globalSharedPreference.getString("currentShop") ==
                                "noShop") {
                          return globalSharedPreference
                                      .getString("currentShop") ==
                                  "noShop"
                              ? noSelectedShop(size, context)
                              : browsingModeProfile(size, "userMode");
                        }
                        {
                          context.read<WorkTimeCubit>().testOpenTime(
                              openTime: globalSharedPreference
                                  .getString("startWorkTime"),
                              closeTime: globalSharedPreference
                                  .getString("endWorkTime"));
                          context.read<GetShopsCubit>().getShop(
                                globalSharedPreference.getString('shopID')!,
                              );
                          context
                              .read<GetShopsCubit>()
                              .getShop(
                                globalSharedPreference.getString('shopID')!,
                              )
                              .then((value) => null);
                          context
                              .read<GetOwnerShopsCubit>()
                              .getOwnerShopsRequest(
                                  ownerID:
                                      globalSharedPreference.getString('ID'),
                                  message: 'all');
                          context.read<PostsCubit>().getOwnerPosts(
                              ownerID: globalSharedPreference.getString('ID'),
                              shopID:
                                  globalSharedPreference.getString('shopID'));
                          return StorePage(
                              shop: Shop(
                                isActive:
                                    globalSharedPreference.getBool("isActive")!,
                                socialUrl: globalSharedPreference
                                    .getStringList("socialUrl"),
                                shopCategory: globalSharedPreference
                                    .getString("shopCategory")!,
                                location: globalSharedPreference
                                    .getString("location")!,
                                startWorkTime: globalSharedPreference
                                    .getString("startWorkTime")!,
                                endWorkTime: globalSharedPreference
                                    .getString("endWorkTime")!,
                                ownerID:
                                    globalSharedPreference.getString("ID") ??
                                        '0',
                                ownerEmail:
                                    globalSharedPreference.getString("email")!,
                                ownerPhoneNumber: globalSharedPreference
                                    .getString("phoneNumber")!,
                                shopID:
                                    globalSharedPreference.getString("shopID")!,
                                shopName: globalSharedPreference
                                    .getString("shopName")!,
                                ownerName:
                                    globalSharedPreference.getString("name")!,
                                followesNumber:
                                    BlocProvider.of<GetShopsCubit>(context)
                                        .shop!
                                        .followesNumber!,
                                rate: globalSharedPreference.getDouble("rate"),
                                shopCoverImage: globalSharedPreference
                                    .getString("shopCoverImage"),
                                shopDescription: globalSharedPreference
                                    .getString("shopDescription"),
                                shopPhoneNumber: globalSharedPreference
                                    .getString("shopPhoneNumber"),
                                shopProfileImage: globalSharedPreference
                                    .getString("shopProfileImage"),
                                latitude: globalSharedPreference
                                    .getDouble("latitude")!,
                                longitude: globalSharedPreference
                                    .getDouble("longitude")!,
                              ),
                              profileDisplay: true);
                        }
                      },
                    ),
            ],
          ),
        ));
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 0);
    path.quadraticBezierTo(size.width * 0.0, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path, Colors.black, 1, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
