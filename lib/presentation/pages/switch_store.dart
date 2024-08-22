import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_divider.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../logic/cubites/shop/get_owner_shops_cubit.dart';
import '../../main.dart';
import '../widgets/dialogs/awosem_dialog.dart';
import '../widgets/switch_shop/error.dart';
import '../widgets/switch_shop/shop_item.dart';

class SwitchStore extends StatefulWidget {
  const SwitchStore({Key? key}) : super(key: key);

  @override
  State<SwitchStore> createState() => _SwitchStoreState();
}

class _SwitchStoreState extends State<SwitchStore> {
  List<dynamic> ownerShpos = [];
  bool isLastShop = false;
  @override
  void initState() {
    context.read<GetOwnerShopsCubit>().getOwnerShopsRequest(
        ownerID: globalSharedPreference.getString("ID"), message: "all");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.my_stroes.tr()),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: BlocConsumer<GetOwnerShopsCubit, GetOwnerShopsState>(
            listener: (context, state) {
              if (state is GetOwnerShopsFiled) {
                buildAwsomeDialog(context, LocaleKeys.faild.tr(),
                        state.message.toUpperCase(), LocaleKeys.ok.tr(),
                        type: DialogType.error)
                    .show();
              } else if (state is GetOwnerShopsSucceed) {}
            },
            builder: (context, state) {
              if (state is GetOwnerShopsProgress) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is GetOwnerShopsSucceed) {
                ownerShpos =
                    BlocProvider.of<GetOwnerShopsCubit>(context).ownerShops;
                if (ownerShpos.length == 1) {
                  isLastShop = true;
                }
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return buildShopItem(
                          context, size, ownerShpos[index], isLastShop);
                    },
                    separatorBuilder: (context, index) => const CustomDivider(),
                    itemCount: ownerShpos.length);
              }
              return buildError(size);
            },
          ),
        ));
  }
}
