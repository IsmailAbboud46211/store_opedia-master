// ignore_for_file: use_build_context_synchronously, unused_field

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shopesapp/logic/cubites/user/auth_cubit.dart';
import 'package:shopesapp/presentation/widgets/location/location_service.dart';
import 'package:shopesapp/presentation/pages/control_page.dart';
import 'package:shopesapp/presentation/pages/map_page.dart';
import 'package:shopesapp/presentation/pages/signup_categories_page.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_button.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_text.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/user_input.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/presentation/widgets/auth/confirm_form_field.dart';
import 'package:shopesapp/presentation/widgets/auth/phoneNumber_form_field.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../constant/clipper.dart';
import '../../data/enums/message_type.dart';
import '../../logic/cubites/user/auth_state.dart';
import '../../main.dart';
import '../shared/custom_widgets/custom_toast.dart';
import '../widgets/auth/email_form_field.dart';
import '../widgets/auth/password_form_field.dart';
import '../widgets/auth/user_name_form_field.dart';
import '../widgets/dialogs/awosem_dialog.dart';

class OwnerSignUp extends StatefulWidget {
  const OwnerSignUp({Key? key}) : super(key: key);

  @override
  State<OwnerSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<OwnerSignUp>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _storeNumberController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  TextEditingController storeLocationController = TextEditingController();
  TextEditingController storeStartWorkTimecontroller = TextEditingController();
  TextEditingController storeEndWorkTimeController = TextEditingController();
  TextEditingController storeCategoryController = TextEditingController();
  var isPasswordHidden = true;
  var isConfiermPasswordHidden = true;
  String? _email;
  TimeOfDay initStartTime = TimeOfDay.now().replacing(hour: 08, minute: 00);
  TimeOfDay initEndTime = TimeOfDay.now().replacing(hour: 08, minute: 00);
  String? _password;
  String? _phoneNumber;
  String? _ownerName;
  String? storeLocation;
  String? storeStartWorkTime;
  String? storeEndWorkTime;
  String? storeCategory;

  late LatLng selectedStoreLocation;

  @override
  void initState() {
    storeStartWorkTimecontroller.text =
        globalSharedPreference.getBool("isArabic") == false
            ? "08:00 AM"
            : "08:00 ص";
    storeEndWorkTimeController.text =
        globalSharedPreference.getBool("isArabic") == false
            ? "08:00 PM"
            : "08:00 م";
    super.initState();
  }

  void setOwnerName(String name) {
    _ownerName = name;
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

      BlocProvider.of<AuthCubit>(context).ownerSignUp(
        ownerName: _ownerName!,
        password: _password!,
        phoneNumber: _phoneNumber!,
        email: _email!,
        storeName: _storeNameController.text,
        storeCategory: storeCategoryController.text,
        storeLocation: storeLocationController.text,
        latitude: selectedStoreLocation.latitude,
        longitude: selectedStoreLocation.longitude,
        startWorkTime: storeStartWorkTimecontroller.text,
        endWorkTime: storeEndWorkTimeController.text,
        shopPhoneNumber: _storeNumberController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
                    LocaleKeys.owner_sign_up.tr(),
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
            (size.height * 0.005).ph,
            Padding(
              padding: EdgeInsets.all((size.height * 0.02)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CreateEmailFormField(
                      setEmail: setEmail,
                    ),
                    (size.height * 0.02).ph,
                    CreatePasswordFormField(
                      isPasswordHidden: isPasswordHidden,
                      setPassword: setPassword,
                    ),
                    (size.height * 0.02).ph,
                    CreateConfirmPasswordFormField(
                      getPassword: getPassword,
                      isConfiermPasswordHidden: isConfiermPasswordHidden,
                    ),
                    (size.height * 0.02).ph,
                    CreateUserNameFormField(setUserName: setOwnerName),
                    (size.height * 0.02).ph,
                    CreatePhoneNumberFormField(setPhoneNumber: setPhoneNumber),
                    UserInput(
                      text: LocaleKeys.store_name.tr(),
                      controller: _storeNameController,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: UserInput(
                            enabled: false,
                            text: LocaleKeys.store_Location.tr(),
                            controller: storeLocationController,
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              LocationData? currentLocation =
                                  await LocationService()
                                      .getUserCurrentLocation();
                              if (currentLocation != null) {
                                selectedStoreLocation = await context.push(
                                  MapPage(
                                    currentLocation: currentLocation,
                                  ),
                                );
                                LocationService()
                                    .getAddressInfo(LocationData.fromMap({
                                      'latitude':
                                          selectedStoreLocation.latitude,
                                      'longitude':
                                          selectedStoreLocation.longitude,
                                    }))
                                    .then(
                                      (value) => storeLocationController.text =
                                          '${value?.administrativeArea ?? ''}-${value?.street ?? ''}',
                                    );
                                setState(() {});
                              }
                            },
                            icon: Icon(
                              Icons.location_on,
                              color: Theme.of(context).colorScheme.primary,
                            ))
                      ],
                    ),
                    UserInput(
                      text: LocaleKeys.store_phoneNumber.tr(),
                      controller: _storeNumberController,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: UserInput(
                            enabled: false,
                            text: LocaleKeys.store_category.tr(),
                            controller: storeCategoryController,
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              await context
                                  .push(const SignUpCategoriesPage())
                                  .then((value) =>
                                      storeCategoryController.text = value);
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.comment,
                              color: Theme.of(context).colorScheme.primary,
                            ))
                      ],
                    ),
                    (size.height * 0.02).ph,
                    CustomText(
                        text: LocaleKeys.work_Time.tr(),
                        textColor: Theme.of(context).hintColor),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await showTimePicker(
                                          context: context,
                                          initialTime: const TimeOfDay(
                                              hour: 08, minute: 00))
                                      .then((value) {
                                    setState(() {
                                      storeStartWorkTimecontroller.text =
                                          value!.format(context);
                                    });
                                  });
                                },
                                child: CustomText(
                                  textColor: AppColors.mainWhiteColor,
                                  text: storeStartWorkTimecontroller.text,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: CustomText(
                              text: LocaleKeys.to.tr(),
                              textColor: Theme.of(context).hintColor,
                            ),
                          ),
                          SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await showTimePicker(
                                          context: context,
                                          initialTime: const TimeOfDay(
                                              hour: 20, minute: 00))
                                      .then((value) {
                                    setState(() {
                                      storeEndWorkTimeController.text =
                                          value!.format(context);
                                    });
                                  });
                                },
                                child: CustomText(
                                  textColor: AppColors.mainWhiteColor,
                                  text: storeEndWorkTimeController.text,
                                ),
                              )),
                        ],
                      ),
                    ),
                    (size.height * 0.005).ph,
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) async {
                        if (state is OwnerSignedUp) {
                          CustomToast.showMessage(
                              context: context,
                              size: size,
                              message: LocaleKeys.sign_up_success.tr(),
                              messageType: MessageType.SUCCESS);
                          context.pushRepalceme(const ControlPage());
                        } else if (state is AuthFailed) {
                          await buildAwsomeDialog(
                                  context,
                                  LocaleKeys.faild.tr(),
                                  state.message.toUpperCase(),
                                  LocaleKeys.cancle.tr(),
                                  type: DialogType.error)
                              .show();
                        }
                      },
                      builder: (context, state) {
                        return BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            if (state is AuthProgress) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return CustomButton(
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                _submitForm(context);
                              },
                              text: LocaleKeys.sign_up.tr(),
                            );
                          },
                        );
                      },
                    ),
                  ]),
            )
          ])),
    ));
  }
}
