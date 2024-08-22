// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shopesapp/data/enums/message_type.dart';
import 'package:shopesapp/global/functions/translate_time.dart';
import 'package:shopesapp/logic/cubites/user/auth_cubit.dart';
import 'package:shopesapp/presentation/widgets/location/location_service.dart';
import 'package:shopesapp/presentation/pages/map_page.dart';
import 'package:shopesapp/presentation/pages/signup_categories_page.dart';
import 'package:shopesapp/presentation/pages/switch_store.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_button.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/user_input.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../global/functions/switch_to_english.dart';
import '../../data/enums/file_type.dart';
import '../../logic/cubites/shop/add_shop_cubit.dart';
import '../../main.dart';
import '../shared/custom_widgets/custom_text.dart';
import '../shared/custom_widgets/custom_toast.dart';
import '../shared/utils.dart';
import '../shared/validation_functions.dart';

class AddStorePage extends StatefulWidget {
  const AddStorePage({Key? key}) : super(key: key);

  @override
  State<AddStorePage> createState() => _EditStoreState();
}

class _EditStoreState extends State<AddStorePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeNumberController = TextEditingController();
  TextEditingController storeCategoryController = TextEditingController();
  TextEditingController storeWorkHoursController = TextEditingController();
  TextEditingController storeDescriptionController = TextEditingController();
  TextEditingController storeInstagramController = TextEditingController();
  TextEditingController storeFacebookController = TextEditingController();
  TextEditingController storeLocationController = TextEditingController();
  TextEditingController storeEmailController = TextEditingController();
  TextEditingController storeStartWorkTimecontroller = TextEditingController();
  TextEditingController storeEndWorkTimeController = TextEditingController();

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

  final ImagePicker picker = ImagePicker();
  FileTypeModel? coverSelectedFile;
  FileTypeModel? profileSelectedFile;
  File? imageFile;
  String? imageCoverBase64;
  String? imageProfileBase64;
  String? storeProfileImageType;
  String? splitPath;
  String? storeCoverImageType;
  Future<FileTypeModel> pickFile(FileType type, bool profile) async {
    String? path;
    switch (type) {
      case FileType.GALLERY:
        await picker.pickImage(source: ImageSource.gallery).then((value) =>
            path = profile
                ? value?.path ?? profileSelectedFile?.path ?? ''
                : value?.path ?? coverSelectedFile?.path ?? '');
        globalSharedPreference.setString(
            profile ? "shopProfileImage" : "shopCoverImage", path!);
        imageFile = File(path!);
        splitPath = path!.split("/").last;

        profile
            ? storeProfileImageType = splitPath!.split(".").last
            : storeCoverImageType = splitPath!.split(".").last;

        List<int> imageBytes = await imageFile!.readAsBytes();
        profile
            ? imageProfileBase64 = base64Encode(imageBytes)
            : imageCoverBase64 = base64Encode(imageBytes);

        context.pop();

        setState(() {});
        break;
      case FileType.CAMERA:
        await picker.pickImage(source: ImageSource.camera).then((value) =>
            path = profile
                ? value?.path ?? profileSelectedFile?.path ?? ''
                : value?.path ?? coverSelectedFile?.path ?? '');
        globalSharedPreference.setString(
            profile ? "shopProfileImage" : "shopCoverImage", path!);
        imageFile = File(path!);
        splitPath = path!.split("/").last;

        profile
            ? storeProfileImageType = splitPath!.split(".").last
            : storeCoverImageType = splitPath!.split(".").last;

        List<int> imageBytes = await imageFile!.readAsBytes();
        profile
            ? imageProfileBase64 = base64Encode(imageBytes)
            : imageCoverBase64 = base64Encode(imageBytes);

        context.pop();

        setState(() {});

        break;
    }
    return FileTypeModel(path ?? '', type);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: AppColors.mainWhiteColor,
        ),
        title: CustomText(
          text: LocaleKeys.add_store.tr(),
          fontSize: w * 0.05,
          textColor: AppColors.mainWhiteColor,
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.04),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(children: [
              (w * 0.02).ph,
              Stack(
                children: [
                  Wrap(
                    children: [
                      Container(
                        height: h / 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(w * 0.05),
                        ),
                        width: w,
                        child: (coverSelectedFile != null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(w * 0.05),
                                child: Image.file(
                                  File(coverSelectedFile!.path),
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Image.asset(
                                'assets/cover_photo.jpg',
                                fit: BoxFit.contain,
                              ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                        top: h / 4.5, start: w / 1.17),
                    child: InkWell(
                      onTap: () {
                        pickImageDialg(false);
                        setState(() {});
                      },
                      child: CircleAvatar(
                        radius: w * 0.036,
                        backgroundColor: AppColors.mainWhiteColor,
                        child: CircleAvatar(
                            radius: w * 0.026,
                            backgroundColor: AppColors.mainBlueColor,
                            child: Icon(
                              coverSelectedFile != null &&
                                      coverSelectedFile!.path.isNotEmpty
                                  ? Icons.edit
                                  : Icons.add,
                              size: w * 0.03,
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                        top: w * 0.35, start: w * 0.005),
                    child: Stack(
                      children: [
                        InkWell(
                            onTap: profileSelectedFile == null
                                ? () {
                                    pickImageDialg(true);
                                    setState(() {});
                                  }
                                : null,
                            child: CircleAvatar(
                              radius: w * 0.12,
                              backgroundColor: AppColors.mainWhiteColor,
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                radius: w * 0.11,
                                backgroundImage: profileSelectedFile != null
                                    ? FileImage(File(profileSelectedFile!.path))
                                    : profileSelectedFile == null ||
                                            profileSelectedFile!.path.isEmpty
                                        ? const AssetImage(
                                            'assets/store_placeholder.png',
                                          ) as ImageProvider
                                        : null,
                              ),
                            )),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              top: w * 0.17, start: w * 0.17),
                          child: InkWell(
                            onTap: () {
                              pickImageDialg(true);
                              setState(() {});
                            },
                            child: CircleAvatar(
                              radius: w * 0.036,
                              backgroundColor: AppColors.mainWhiteColor,
                              child: CircleAvatar(
                                  radius: w * 0.026,
                                  backgroundColor: AppColors.mainBlueColor,
                                  child: Icon(
                                    profileSelectedFile != null &&
                                            profileSelectedFile!.path.isNotEmpty
                                        ? Icons.edit
                                        : Icons.add,
                                    size: w * 0.03,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                        await context.push(const SignUpCategoriesPage()).then(
                            (value) => storeCategoryController.text = value);
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.comment,
                        color: Theme.of(context).colorScheme.primary,
                      ))
                ],
              ),
              UserInput(
                  text: LocaleKeys.store_name.tr(),
                  controller: storeNameController,
                  validator: (name) =>
                      nameValidator(name, LocaleKeys.enter_store_name.tr())),
              UserInput(
                text: LocaleKeys.store_description.tr(),
                controller: storeDescriptionController,
              ),
              UserInput(
                  text: LocaleKeys.store_phoneNumber.tr(),
                  controller: storeNumberController,
                  validator: (number) => numberValidator(
                      number, LocaleKeys.enter_store_number.tr())),
              30.ph,
              CustomText(
                text: LocaleKeys.work_Time.tr(),
                textColor: Theme.of(context).hintColor,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          onPressed: () async {
                            await showTimePicker(
                                    context: context,
                                    initialTime:
                                        const TimeOfDay(hour: 8, minute: 0))
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
                                    initialTime:
                                        const TimeOfDay(hour: 20, minute: 00))
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
              Row(
                children: [
                  Expanded(
                    child: UserInput(
                      enabled: false,
                      text: LocaleKeys.location.tr(),
                      controller: storeLocationController,
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        LocationData? currentLocation =
                            await LocationService().getUserCurrentLocation();
                        if (currentLocation != null) {
                          selectedStoreLocation = await context.push(
                            MapPage(
                              currentLocation: currentLocation,
                            ),
                          );

                          LocationService()
                              .getAddressInfo(LocationData.fromMap({
                                'latitude': selectedStoreLocation.latitude,
                                'longitude': selectedStoreLocation.longitude,
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
                text: LocaleKeys.instagram_Account.tr(),
                controller: storeInstagramController,
              ),
              UserInput(
                text: LocaleKeys.facebook_Account.tr(),
                controller: storeFacebookController,
              ),
              30.ph,
              Row(children: [
                Expanded(
                    child: CustomButton(
                  onPressed: () {
                    context.pop();
                  },
                  text: LocaleKeys.cancle.tr(),
                  color: AppColors.mainWhiteColor,
                  textColor: Theme.of(context).colorScheme.primary,
                  borderColor: Theme.of(context).colorScheme.primary,
                )),
                70.px,
                Expanded(
                  child: BlocProvider(
                    create: (context) => AddShopCubit(),
                    child: BlocConsumer<AddShopCubit, AddShopState>(
                      listener: (context, state) {
                        if (state is AddShopSucceed) {
                          CustomToast.showMessage(
                              context: context,
                              size: size,
                              message:
                                  LocaleKeys.store_created_successfully.tr(),
                              messageType: MessageType.SUCCESS);
                          if (globalSharedPreference.getString("mode") ==
                              "user") {
                            context.read<AuthCubit>().userBecomeOwner();
                          }
                          context.pushRepalceme(const SwitchStore());
                        } else if (state is AddShopFailed) {
                          CustomToast.showMessage(
                              context: context,
                              size: size,
                              message: state.message,
                              messageType: MessageType.REJECTED);
                        }
                      },
                      builder: (context, state) {
                        if (state is AddShopProgress) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return CustomButton(
                            text: LocaleKeys.create.tr(),
                            textColor: AppColors.mainWhiteColor,
                            onPressed: () {
                              !formKey.currentState!.validate()
                                  ? CustomToast.showMessage(
                                      context: context,
                                      size: size,
                                      message:
                                          LocaleKeys.invalid_information.tr(),
                                      messageType: MessageType.WARNING)
                                  : {
                                      formKey.currentState!.save(),
                                      context.read<AddShopCubit>().addShop(
                                          storeCoverImageType:
                                              storeCoverImageType ?? '',
                                          storeProfileImageType:
                                              storeProfileImageType ?? '',
                                          shopName: storeNameController.text,
                                          shopDescription:
                                              storeDescriptionController.text,
                                          shopProfileImage:
                                              imageProfileBase64 ?? 'url',
                                          shopCoverImage:
                                              imageCoverBase64 ?? 'url',
                                          shopCategory: globalSharedPreference
                                                      .getBool("isArabic") ==
                                                  false
                                              ? storeCategoryController.text
                                              : switchCategoryToEnglish(
                                                  storeCategoryController.text),
                                          location:
                                              storeLocationController.text,
                                          latitude:
                                              selectedStoreLocation.latitude,
                                          longitude:
                                              selectedStoreLocation.longitude,
                                          opening: globalSharedPreference
                                                      .getBool("isArabic") ==
                                                  false
                                              ? storeStartWorkTimecontroller
                                                  .text
                                              : translateTimetoEnglish(storeStartWorkTimecontroller.text),
                                          closing: globalSharedPreference.getBool("isArabic") == false ? storeEndWorkTimeController.text : translateTimetoEnglish(storeEndWorkTimeController.text),
                                          shopPhoneNumber: storeNumberController.text,
                                          instagramAccount: storeInstagramController.text,
                                          facebookAccount: storeFacebookController.text),
                                    };
                            });
                      },
                    ),
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ),
    ));
  }

  Future pickImageDialg(bool profile) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      pickFile(FileType.CAMERA, profile).then((value) => profile
                          ? profileSelectedFile = value
                          : coverSelectedFile = value);
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, elevation: 0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        40.px,
                        CustomText(
                          text: LocaleKeys.camera.tr(),
                          fontSize: 20,
                        )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      pickFile(FileType.GALLERY, profile).then((value) =>
                          profile
                              ? profileSelectedFile = value
                              : coverSelectedFile = value);
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, elevation: 0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.image,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        40.px,
                        CustomText(
                          text: LocaleKeys.gallery.tr(),
                          fontSize: 20,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
