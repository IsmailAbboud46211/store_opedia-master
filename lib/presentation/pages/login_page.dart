import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/presentation/pages/control_page.dart';
import 'package:shopesapp/presentation/pages/privacy%20policies.dart';
import 'package:shopesapp/presentation/pages/start_sign_up_page.dart';
import 'package:shopesapp/presentation/pages/switch_store.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_text.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../data/enums/message_type.dart';
import '../../data/data base/shared_preferences_repository.dart';
import '../../logic/cubites/user/auth_cubit.dart';
import '../../logic/cubites/user/auth_state.dart';
import '../../main.dart';
import '../shared/custom_widgets/custom_toast.dart';
import '../widgets/auth/email_form_field.dart';
import '../widgets/auth/password_form_field.dart';
import '../widgets/dialogs/awosem_dialog.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var isPasswordHidden = true;
  bool isArabic = false;
  late String _email;

  late String _password;

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      BlocProvider.of<AuthCubit>(context).login(_email, _password);
    }
  }

  @override
  void initState() {
    isArabic = globalSharedPreference.getBool("isArabic") ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UserLoginedIn) {
          CustomToast.showMessage(
              context: context,
              size: size,
              message: LocaleKeys.login_success.tr(),
              messageType: MessageType.SUCCESS);
          context.pushRepalceme(const ControlPage());
        } else if (state is OwnerWillSelectStore) {
          CustomToast.showMessage(
              context: context,
              size: size,
              message: LocaleKeys.auth_SUCCEDED.tr(),
              messageType: MessageType.SUCCESS);
          context.push(const SwitchStore());
        } else if (state is AuthFailed) {
          buildAwsomeDialog(context, LocaleKeys.faild.tr(),
                  state.message.toUpperCase(), LocaleKeys.cancle.tr(),
                  type: DialogType.error)
              .show();
        }
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Stack(
                      children: [
                        ClipPath(
                          clipper: firstClipper(),
                          child: ClipPath(
                            child: Container(
                              padding:
                                  EdgeInsets.symmetric(horizontal: w * 0.06),
                              height: h / 1.3,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorLight,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  )),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 160,
                                        child: Image.asset(
                                            'assets/sign_image.jpg')),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 220, top: 20),
                                      child: Text(
                                        LocaleKeys.welcome.tr(),
                                        style: TextStyle(
                                            fontSize: w * 0.055,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: h * 0.05,
                                    ),
                                    Text(
                                      LocaleKeys
                                          .by_singing_in_you_are_agreeing_with
                                          .tr(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: h * 0.005,
                                    ),
                                    InkWell(
                                      child: Text(
                                        LocaleKeys.terms_and_privacy_policy
                                            .tr(),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      onTap: () {
                                        context.push(const PrivacyPlicies());
                                      },
                                    ),
                                    SizedBox(
                                      height: h * 0.05,
                                    ),
                                    CreateEmailFormField(
                                      setEmail: setEmail,
                                    ),
                                    SizedBox(
                                      height: h * 0.009,
                                    ),
                                    CreatePasswordFormField(
                                      isPasswordHidden: isPasswordHidden,
                                      setPassword: setPassword,
                                    ),
                                    40.ph,
                                    Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: InkWell(
                                        onTap: () {
                                          globalSharedPreference.clear();
                                          SharedPreferencesRepository
                                              .setBrowsingPostsMode(
                                                  isBrowsingMode: true);
                                          globalSharedPreference.setString(
                                              "ID", '0');
                                          globalSharedPreference.setBool(
                                              "isArabic", false);
                                          context.push(const ControlPage());
                                        },
                                        child: CustomText(
                                            textColor: AppColors.mainBlueColor,
                                            underline: true,
                                            text: LocaleKeys.continue_as_visitor
                                                .tr()),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: h / 6),
                          child: ClipPath(
                            clipper: MyClipper(),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorLight,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              height: h / 1.3,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: EdgeInsets.only(top: h / 1.6),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: BlocBuilder<AuthCubit,
                                                    AuthState>(
                                                  builder: (context, state) {
                                                    if (state is AuthProgress) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    }
                                                    return ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 15),
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30))),
                                                      onPressed: () => {
                                                        _submitForm(context),
                                                      },
                                                      child: Text(
                                                        LocaleKeys.login.tr(),
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .mainWhiteColor,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              40.px,
                                              Expanded(
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      context.push(
                                                          const StartSignupPage());
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 15,
                                                            ),
                                                            backgroundColor:
                                                                AppColors
                                                                    .mainWhiteColor,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30)),
                                                            side: BorderSide(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                            )),
                                                    child: Text(
                                                      LocaleKeys.register.tr(),
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    )),
                                              )
                                            ],
                                          ),
                                          SwitchListTile(
                                            title: Text(LocaleKeys
                                                .arabic_language
                                                .tr()),
                                            value: isArabic,
                                            onChanged: (bool value) async {
                                              setState(() {
                                                isArabic = !isArabic;
                                              });
                                              value == true
                                                  ? {
                                                      await context.setLocale(
                                                          const Locale('ar')),
                                                      globalSharedPreference
                                                          .setBool(
                                                              "isArabic", true),
                                                    }
                                                  : {
                                                      await context.setLocale(
                                                          const Locale('en')),
                                                      globalSharedPreference
                                                          .setBool("isArabic",
                                                              false),
                                                    };
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }
}

// ignore: camel_case_types
class firstClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();

    path0.moveTo(0, 0);
    path0.lineTo(size.width, 0);
    path0.quadraticBezierTo(size.width, size.height * 0.5642786, size.width,
        size.height * 0.7523714);
    path0.cubicTo(
        size.width * 1.0099500,
        size.height * 0.7744143,
        size.width * 0.9658250,
        size.height * 0.7850429,
        size.width * 0.9650000,
        size.height * 0.7857143);
    path0.quadraticBezierTo(
        size.width * 0.7237500, size.height * 0.8392857, 0, size.height);

    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(size.width, size.height * 0.5700000);
    path0.lineTo(size.width, size.height);
    path0.lineTo(0, size.height);
    path0.quadraticBezierTo(
        0, size.height * 0.8667786, 0, size.height * 0.8223714);
    path0.cubicTo(
        size.width * 0.0015500,
        size.height * 0.8087857,
        size.width * 0.0019750,
        size.height * 0.8030000,
        size.width * 0.0382750,
        size.height * 0.7863571);
    path0.quadraticBezierTo(size.width * 0.2787062, size.height * 0.7322679,
        size.width, size.height * 0.5700000);
    path0.close();

    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
