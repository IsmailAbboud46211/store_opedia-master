import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/logic/cubites/user/auth_cubit.dart';

import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/presentation/widgets/switch_shop/alert_dialog.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../../data/enums/message_type.dart';
import '../../../logic/cubites/shop/active_shop_cubit.dart';
import '../../../logic/cubites/shop/deactivate_shop_cubit.dart';
import '../../../logic/cubites/shop/delete_shop_cubit.dart';
import '../../../logic/cubites/shop/switch_shop_cubit.dart';
import '../../../main.dart';
import '../../pages/control_page.dart';
import '../../pages/switch_store.dart';
import '../../shared/custom_widgets/custom_text.dart';
import '../../shared/custom_widgets/custom_toast.dart';
import '../dialogs/awosem_dialog.dart';

Widget buildShopItem(
        BuildContext context, Size size, var shop, bool isLastShop) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: size.width * 0.12,
            backgroundColor: AppColors.mainTextColor,
            backgroundImage: shop["shopProfileImage"] == 'url'
                ? const AssetImage(
                    'assets/profile_photo.jpg',
                  )
                : NetworkImage(shop["shopProfileImage"]!) as ImageProvider,
          ),
          15.px,
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.ph,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Center(
                      child: CustomText(
                        text: shop["shopName"],
                        bold: true,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                10.ph,
                Row(
                  children: [
                    BlocConsumer<SwitchShopCubit, SwitchShopState>(
                      listener: (context, state) {
                        if (state is SwithShopFiled) {
                          buildAwsomeDialog(
                              context,
                              LocaleKeys.faild.tr(),
                              LocaleKeys.ok.tr(),
                              LocaleKeys.select_store_failed.tr(),
                              type: DialogType.error);
                        } else if (state is SwithShopSucceded) {
                          context.read<AuthCubit>().selectedShop();

                          context.pushRepalceme(const ControlPage());
                        }
                      },
                      builder: (context, state) {
                        if (state is SwithShopSucceded &&
                            globalSharedPreference.getString("shopID") ==
                                shop["shopID"]) {
                          return Expanded(
                            child: CustomText(
                              text: LocaleKeys.current_shop.tr(),
                              textColor: Colors.green,
                            ),
                          );
                        } else if (state is SwithShopProgress &&
                            globalSharedPreference.getString("shopID") ==
                                shop["shopID"]) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is SwithShopProgress &&
                            globalSharedPreference.getString("shopID") !=
                                shop["shopID"]) {
                          return Expanded(
                            child: CustomText(
                              text: LocaleKeys.waiting.tr(),
                              textColor: Theme.of(context).primaryColorDark,
                            ),
                          );
                        }
                        return Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showAlertDialog(context, shop);
                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(10),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: Text(LocaleKeys.select.tr()),
                          ),
                        );
                      },
                    ),
                    5.px,
                    Visibility(
                      visible: shop["is_active"] == false &&
                          globalSharedPreference.getString("shopID") != "noID",
                      child: BlocProvider(
                        create: (context) => ActiveShopCubit(),
                        child: Row(children: [
                          BlocConsumer<ActiveShopCubit, ActiveShopState>(
                            listener: (context, state) {
                              if (state is ActiveShopSucceed) {
                                CustomToast.showMessage(
                                    context: context,
                                    size: size,
                                    message: LocaleKeys.shop_acivated.tr(),
                                    messageType: MessageType.SUCCESS);
                                if (globalSharedPreference
                                        .getString("shopID") ==
                                    shop["shopID"]) {
                                  globalSharedPreference.setBool(
                                      "isActive", true);
                                }
                                context.pushRepalceme(const SwitchStore());
                              } else if (state is ActiveShopFailed) {
                                CustomToast.showMessage(
                                    context: context,
                                    size: size,
                                    message: state.message.toUpperCase(),
                                    messageType: MessageType.WARNING);
                              }
                            },
                            builder: (context, state) {
                              if (state is ActiveProgress) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              return Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    activeShopAlert(context, shop["shopID"]);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(10),
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  child: Text(LocaleKeys.activate.tr()),
                                ),
                              );
                            },
                          ),
                        ]),
                      ),
                    ),
                    0.px,
                    BlocProvider(
                      create: (context) => DeactivateShopCubit(),
                      child: Visibility(
                          visible: globalSharedPreference.getString("shopID") !=
                                  "noID" &&
                              shop["is_active"],
                          child: BlocConsumer<DeactivateShopCubit,
                              DeactivateShopState>(
                            listener: (context, state) {
                              if (state is DeactivateShopSucceed) {
                                if (globalSharedPreference
                                        .getString("shopID")! ==
                                    shop["shopID"]) {
                                  globalSharedPreference.setBool(
                                      "isActive", false);
                                }
                                CustomToast.showMessage(
                                    context: context,
                                    size: size,
                                    message: LocaleKeys.shop_acivated.tr(),
                                    messageType: MessageType.SUCCESS);
                                context.pushRepalceme(const SwitchStore());
                              } else if (state is DeactivateShopFailed) {
                                CustomToast.showMessage(
                                    context: context,
                                    size: size,
                                    message: state.message.toUpperCase(),
                                    messageType: MessageType.WARNING);
                              }
                            },
                            builder: (context, state) {
                              if (state is DeactivateShopProgress) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    isLastShop == false
                                        ? deactivatedShopAlert(
                                            context, shop["shopID"])
                                        : cantDeactivatedShop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(10),
                                      backgroundColor: Colors.blueGrey,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  child: Text(LocaleKeys.deactivate.tr()),
                                ),
                              );
                            },
                          )),
                    ),
                    5.px,
                    BlocProvider(
                      create: (context) => DeleteShopCubit(),
                      child: Visibility(
                          visible: globalSharedPreference.getString("shopID") !=
                                  "noID" &&
                              shop["is_active"],
                          child: BlocConsumer<DeleteShopCubit, DeleteShopState>(
                            listener: (context, state) {
                              if (state is DeleteShopSucceed) {
                                if (globalSharedPreference
                                        .getString("shopID") ==
                                    shop["shopID"]) {
                                  AuthCubit().deleteCurrentShop();
                                }
                                isLastShop == false
                                    ? {
                                        CustomToast.showMessage(
                                            context: context,
                                            size: size,
                                            message:
                                                LocaleKeys.shop_delete.tr(),
                                            messageType: MessageType.SUCCESS),
                                        context
                                            .pushRepalceme(const SwitchStore())
                                      }
                                    : {
                                        CustomToast.showMessage(
                                            context: context,
                                            size: size,
                                            message:
                                                LocaleKeys.shop_delete.tr(),
                                            messageType: MessageType.SUCCESS),
                                        context
                                            .pushRepalceme(const ControlPage()),
                                        context
                                            .read<AuthCubit>()
                                            .ownerBecomeUser(),
                                      };
                              } else if (state is DeleteShopFailed) {
                                CustomToast.showMessage(
                                    context: context,
                                    size: size,
                                    message: LocaleKeys.faild.tr(),
                                    messageType: MessageType.WARNING);
                              }
                            },
                            builder: (context, state) {
                              if (state is DeleteShopProgress) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    deleteShopAlert(
                                        context, shop["shopID"], isLastShop);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(10),
                                      backgroundColor: AppColors.mainRedColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  child: Text(LocaleKeys.delete.tr()),
                                ),
                              );
                            },
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
