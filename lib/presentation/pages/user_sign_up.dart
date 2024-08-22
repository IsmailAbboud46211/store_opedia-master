import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopesapp/logic/cubites/user/auth_cubit.dart';
import 'package:shopesapp/presentation/pages/control_page.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/presentation/widgets/auth/confirm_form_field.dart';
import 'package:shopesapp/presentation/widgets/auth/phoneNumber_form_field.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../constant/clipper.dart';
import '../../data/enums/message_type.dart';
import '../../logic/cubites/user/auth_state.dart';
import '../shared/custom_widgets/custom_button.dart';
import '../shared/custom_widgets/custom_toast.dart';
import '../widgets/auth/email_form_field.dart';
import '../widgets/auth/password_form_field.dart';
import '../widgets/auth/user_name_form_field.dart';
import '../widgets/dialogs/awosem_dialog.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({Key? key}) : super(key: key);

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var isPasswordHidden = true;
  var isConfiermPasswordHidden = true;
  String? _email;
  String? _password;
  String? _phoneNumber;
  String? _userName;

  void setUserName(String name) {
    _userName = name;
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setPassword(String password) {
    _password = password;
  }

  String getPassword() {
    return _password!;
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      BlocProvider.of<AuthCubit>(context)
          .userSignUp(_userName!, _email!, _password!, _phoneNumber!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UserSignedUp) {
          CustomToast.showMessage(
              context: context,
              size: size,
              message: LocaleKeys.sign_up_success.tr(),
              messageType: MessageType.SUCCESS);
          context.pushRepalceme(const ControlPage());
        } else if (state is AuthFailed) {
          buildAwsomeDialog(context, LocaleKeys.faild.tr(),
                  state.message.toUpperCase(), LocaleKeys.cancle.tr(),
                  type: DialogType.error)
              .show();
        }
      },
      child: Scaffold(
          body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipPath(
                clipper: TsClip1(),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  color: Theme.of(context).colorScheme.primary,
                  child: Center(
                    child: Text(
                      LocaleKeys.user_sign_up.tr(),
                      style: GoogleFonts.indieFlower(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  CreateEmailFormField(
                    setEmail: setEmail,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  CreatePasswordFormField(
                    isPasswordHidden: isPasswordHidden,
                    setPassword: setPassword,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  CreateConfirmPasswordFormField(
                    getPassword: getPassword,
                    isConfiermPasswordHidden: isConfiermPasswordHidden,
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  CreateUserNameFormField(setUserName: setUserName),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  CreatePhoneNumberFormField(setPhoneNumber: setPhoneNumber),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthProgress) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return CustomButton(
                        onPressed: () {
                          _submitForm(context);
                        },
                        text: LocaleKeys.sign_up.tr(),
                      );
                    },
                  ),
                ]),
              )
            ])),
      )),
    );
  }
}
