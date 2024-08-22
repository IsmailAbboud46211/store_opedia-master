import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:shopesapp/data/data%20base/shared_preferences_repository.dart';
import 'package:shopesapp/logic/cubites/user/auth_state.dart';
import 'package:shopesapp/logic/cubites/user/delete_user_cubit.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../data/enums/message_type.dart';
import '../../logic/cubites/user/auth_cubit.dart';
import '../../logic/cubites/cubit/settings/Themes/themes_cubit.dart';
import '../shared/custom_widgets/custom_toast.dart';
import '../widgets/dialogs/awosem_dialog.dart';
import '../widgets/settings/settings_til.dart';
import 'login_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        title: Text(
          LocaleKeys.settings.tr(),
          style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: size.height,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
            children: [
              SettingsGroup(
                  titleTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary),
                  title: LocaleKeys.pofile.tr(),
                  children: <Widget>[10.ph, buildProfile(context)]),
              SizedBox(
                height: size.height * 0.01,
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is UserLoginedIn ||
                      state is UserSignedUp ||
                      SharedPreferencesRepository.getBrowsingPostsMode()) {
                    return SettingsGroup(
                        titleTextStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.secondary),
                        title: LocaleKeys.my_Account.tr(),
                        children: <Widget>[buildSwitchUserAccount(context)]);
                  }
                  return SettingsGroup(
                      titleTextStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.secondary),
                      title: LocaleKeys.my_stroe.tr(),
                      children: <Widget>[
                        buildeAddNewSotre(context),
                        buildeEdeitMySotre(context, size),
                        buildSwitchSotre(context),
                      ]);
                },
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              SettingsGroup(
                  titleTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary),
                  title: LocaleKeys.mode.tr(),
                  children: <Widget>[
                    buildLanguage(context),
                    buildThemes(context)
                  ]),
              SizedBox(
                height: size.height * 0.01,
              ),
              SettingsGroup(
                  titleTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary),
                  title: LocaleKeys.general.tr(),
                  children: <Widget>[
                    if (SharedPreferencesRepository.getBrowsingPostsMode()) ...[
                      buildLogin(context),
                      buildCreateAccount(context),
                    ],
                    if (!SharedPreferencesRepository
                        .getBrowsingPostsMode()) ...[
                      buildLogout(context),
                      BlocProvider<DeleteUserCubit>(
                        create: (context) => DeleteUserCubit(),
                        child: BlocConsumer<DeleteUserCubit, DeleteUserState>(
                          listener: (context, state) {
                            if (state is DeleteUserSucceed) {
                              BlocProvider.of<AuthCubit>(context).logOut();
                              context.read<ThemesCubit>().changeTheme(0);
                              context.pushRepalceme(const LoginPage());
                              CustomToast.showMessage(
                                  context: context,
                                  size: size,
                                  message: LocaleKeys.delete_account.tr(),
                                  messageType: MessageType.SUCCESS);
                            } else if (state is DeleteUserFailed) {
                              buildAwsomeDialog(
                                      context,
                                      LocaleKeys.faild.tr(),
                                      state.message.toUpperCase(),
                                      LocaleKeys.cancle.tr(),
                                      type: DialogType.error)
                                  .show();
                            }
                          },
                          builder: (context, state) {
                            if (state is DeleteUserProgress) {
                              return const LinearProgressIndicator();
                            }
                            return buildDeleteAccount(
                              context,
                            );
                          },
                        ),
                      ),
                    ]
                  ]),
              SizedBox(
                height: size.height * 0.01,
              ),
              SettingsGroup(
                  titleTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary),
                  title: LocaleKeys.about.tr(),
                  children: <Widget>[
                    buildContactUs(context, size),
                    buildAbout(context)
                  ]),
              SettingsGroup(
                  titleTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary),
                  title: LocaleKeys.privacy.tr(),
                  children: <Widget>[buildPrivacy(context)]),
              (size.height / 4).ph
            ],
          ),
        ),
      ),
    );
  }
}
