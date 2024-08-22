// ignore_for_file: use_build_context_synchronously, must_be_immutable
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
import 'package:shopesapp/main.dart';
import 'package:shopesapp/presentation/pages/signup_categories_page.dart';
import 'package:shopesapp/presentation/pages/store_page.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_button.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/user_input.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../global/functions/switch_to_arabic.dart';
import '../../global/functions/switch_to_english.dart';
import '../../data/enums/file_type.dart';
import '../../data/models/shop.dart';
import '../../logic/cubites/post/posts_cubit.dart';
import '../../logic/cubites/shop/edit_shop_cubit.dart';
import '../../logic/cubites/shop/get_owner_shops_cubit.dart';
import '../../logic/cubites/shop/work_time_cubit.dart';
import '../widgets/location/location_service.dart';
import '../shared/custom_widgets/custom_text.dart';
import '../shared/custom_widgets/custom_toast.dart';
import '../shared/utils.dart';
import '../shared/validation_functions.dart';
import 'map_page.dart';

class EditStore extends StatefulWidget {
  EditStore({Key? key, this.function}) : super(key: key);
  Function()? function;
  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeNumberController = TextEditingController();
  TextEditingController storeCategoryController = TextEditingController();
  TextEditingController storeStartWorkTimecontroller = TextEditingController();
  TextEditingController storeEndWorkTimeController = TextEditingController();
  TextEditingController storeDescriptionController = TextEditingController();
  TextEditingController storeInstagramController = TextEditingController(
      text: globalSharedPreference.getStringList("socialUrl")![1]);
  TextEditingController storeFacebookController = TextEditingController(
      text: globalSharedPreference.getStringList("socialUrl")![0]);

  TextEditingController storeLocationController = TextEditingController();
  String? timeString;
  List<String>? timeParts;
  List<String>? timeDigetes;
  int? startTimeHour;
  int? startTimeMinute;
  int? endTimeHour;
  int? endTimeMinute;

  LatLng? selectedStoreLocation;
  @override
  void initState() {
    timeString = globalSharedPreference.getString("startWorkTime");
    timeParts = timeString?.split(" ");
    timeDigetes = timeParts![0].split(":");
    startTimeHour = int.parse(timeDigetes![0]);
    startTimeMinute = int.parse(timeDigetes![1]);
    timeString = globalSharedPreference.getString("endWorkTime");
    timeParts = timeString?.split(" ");
    timeDigetes = timeParts![0].split(":");
    endTimeHour = int.parse(timeDigetes![0]);
    endTimeMinute = int.parse(timeDigetes![1]);

    storeNameController.text = globalSharedPreference.getString("shopName") ??
        LocaleKeys.store_name.tr();
    storeNumberController.text =
        globalSharedPreference.getString("shopPhoneNumber") ??
            LocaleKeys.store_phoneNumber.tr();
    storeCategoryController.text =
        (globalSharedPreference.getBool("isArabic") == false
            ? globalSharedPreference.getString("shopCategory")!
            : switchCategoryToArabic(
                globalSharedPreference.getString("shopCategory")!));
    storeDescriptionController.text =
        globalSharedPreference.getString("shopDescription") ??
            LocaleKeys.store_description.tr();
    storeLocationController.text = globalSharedPreference.getBool("isArabic") ==
            false
        ? globalSharedPreference.getString("location")!
        : switchLocationToArabic(globalSharedPreference.getString("location")!);
    storeStartWorkTimecontroller.text =
        globalSharedPreference.getBool("isArabic") == false
            ? globalSharedPreference.getString("startWorkTime")!
            : translateTimetoArabic(
                globalSharedPreference.getString("startWorkTime")!);
    storeEndWorkTimeController.text =
        globalSharedPreference.getBool("isArabic") == false
            ? globalSharedPreference.getString("endWorkTime")!
            : translateTimetoArabic(
                globalSharedPreference.getString("endWorkTime")!);
    profilePath = globalSharedPreference.getString("shopProfileImage");
    coverPath = globalSharedPreference.getString("shopCoverImage");

    super.initState();
  }

  final ImagePicker picker = ImagePicker();
  String? coverPath;
  String? profilePath;
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
                ? value?.path ?? profileSelectedFile?.path ?? profilePath ?? ''
                : value?.path ?? coverSelectedFile?.path ?? coverPath ?? '');
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
                ? value?.path ?? profileSelectedFile?.path ?? profilePath ?? ''
                : value?.path ?? coverSelectedFile?.path ?? coverPath ?? '');
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
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: AppColors.mainWhiteColor,
        ),
        title: CustomText(
          text: LocaleKeys.edit_store.tr(),
          textColor: AppColors.mainWhiteColor,
          fontSize: w * 0.05,
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
                              borderRadius: BorderRadius.circular(w * 0.02),
                              border:
                                  Border.all(color: AppColors.mainBlackColor)),
                          width: w,
                          child: (coverSelectedFile != null) ||
                                  (coverSelectedFile == null &&
                                      coverPath != 'url')
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(w * 0.05),
                                  child: coverSelectedFile != null
                                      ? Image.file(
                                          File(coverSelectedFile!.path),
                                          fit: BoxFit.contain,
                                        )
                                      : Image.network(coverPath!),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(w * 0.05),
                                  child: Image.asset(
                                    'assets/store_cover_placeholder.jpg',
                                    fit: BoxFit.contain,
                                  ),
                                ))
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
                              Icons.edit,
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
                        CircleAvatar(
                          radius: w * 0.13,
                          backgroundColor: AppColors.mainWhiteColor,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            radius: w * 0.12,
                            backgroundImage: (profileSelectedFile != null) ||
                                    (profileSelectedFile == null &&
                                        profilePath == 'url')
                                ? profileSelectedFile != null
                                    ? FileImage(File(profileSelectedFile!.path))
                                    : const AssetImage(
                                        'assets/profile_photo.jpg',
                                      ) as ImageProvider
                                : (profileSelectedFile == null &&
                                        profilePath != 'url')
                                    ? profileSelectedFile == null
                                        ? NetworkImage(globalSharedPreference
                                            .getString("shopProfileImage")!)
                                        : NetworkImage(profilePath!)
                                    : null,
                          ),
                        ),
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
                                    Icons.edit,
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
              20.ph,
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
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () async {
                            await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: startTimeHour!,
                                        minute: startTimeMinute!))
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
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () async {
                            await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: endTimeHour!,
                                        minute: endTimeMinute!))
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
              UserInput(
                text: LocaleKeys.instagram_Account.tr(),
                controller: storeInstagramController,
              ),
              UserInput(
                text: LocaleKeys.facebook_Account.tr(),
                controller: storeFacebookController,
              ),
              Row(
                children: [
                  Expanded(
                    child: UserInput(
                      text: LocaleKeys.category.tr(),
                      enabled: false,
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
                        LocationData? currentLocation = LocationData.fromMap({
                          'latitude':
                              globalSharedPreference.getDouble('latitude'),
                          'longitude':
                              globalSharedPreference.getDouble('longitude'),
                        });
                        selectedStoreLocation = await context.push(
                          MapPage(
                            currentLocation: currentLocation,
                          ),
                        );
                        LocationService()
                            .getAddressInfo(LocationData.fromMap({
                              'latitude': selectedStoreLocation!.latitude,
                              'longitude': selectedStoreLocation!.longitude,
                            }))
                            .then(
                              (value) => storeLocationController.text =
                                  '${value?.administrativeArea ?? ''}-${value?.street ?? ''}',
                            );
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                      ))
                ],
              ),
              30.ph,
              Row(children: [
                Expanded(
                    child: CustomButton(
                  onPressed: () {
                    setState(() {
                      profilePath = null;
                      coverPath = null;
                    });
                    context.pop();
                  },
                  text: LocaleKeys.cancle.tr(),
                  color: AppColors.mainWhiteColor,
                  textColor: Theme.of(context).colorScheme.primary,
                  borderColor: Theme.of(context).colorScheme.primary,
                )),
                70.px,
                BlocProvider(
                  create: (context) => EditShopCubit(),
                  child: Expanded(
                    child: BlocConsumer<EditShopCubit, EditShopState>(
                      listener: (context, state) {
                        if (state is EditShopSucceed) {
                          CustomToast.showMessage(
                              context: context,
                              size: size,
                              message: LocaleKeys
                                  .information_updated_successfully
                                  .tr(),
                              messageType: MessageType.SUCCESS);
                          widget.function;
                          context.pop();
                        } else if (state is EditShopFailed) {
                          CustomToast.showMessage(
                              context: context,
                              size: size,
                              message: state.message,
                              messageType: MessageType.REJECTED);
                        }
                      },
                      builder: (context, state) {
                        if (state is EditShopProgress) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return CustomButton(
                          text: LocaleKeys.submit.tr(),
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
                                    context.read<EditShopCubit>().editShop(
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
                                        location: storeLocationController.text,
                                        latitude: selectedStoreLocation?.latitude ??
                                            globalSharedPreference
                                                .getDouble("latitude")!,
                                        longitude:
                                            selectedStoreLocation?.longitude ??
                                                globalSharedPreference
                                                    .getDouble("longitude")!,
                                        opening: globalSharedPreference.getBool("isArabic") == false
                                            ? storeStartWorkTimecontroller.text
                                            : translateTimetoEnglish(storeStartWorkTimecontroller.text),
                                        closing: globalSharedPreference.getBool("isArabic") == false ? storeEndWorkTimeController.text : translateTimetoEnglish(storeEndWorkTimeController.text),
                                        shopPhoneNumber: storeNumberController.text,
                                        insta: storeInstagramController.text,
                                        facebook: storeFacebookController.text),
                                    widget.function,
                                    setState(() {
                                      context
                                          .read<WorkTimeCubit>()
                                          .testOpenTime(
                                              openTime: globalSharedPreference
                                                  .getString("startWorkTime"),
                                              closeTime: globalSharedPreference
                                                  .getString("endWorkTime"));
                                      context
                                          .read<GetOwnerShopsCubit>()
                                          .getOwnerShopsRequest(
                                              ownerID: globalSharedPreference
                                                  .getString('ID'),
                                              message: 'all');
                                      context.read<PostsCubit>().getOwnerPosts(
                                          ownerID: globalSharedPreference
                                              .getString('ID'),
                                          shopID: globalSharedPreference
                                              .getString('shopID'));
                                      context.push(StorePage(
                                          shop: Shop(
                                            isActive: globalSharedPreference
                                                .getBool("isActive")!,
                                            socialUrl: globalSharedPreference
                                                .getStringList("socialUrl"),
                                            shopCategory: globalSharedPreference
                                                .getString("shopCategory")!,
                                            location: globalSharedPreference
                                                .getString("location")!,
                                            startWorkTime:
                                                globalSharedPreference
                                                    .getString(
                                                        "startWorkTime")!,
                                            endWorkTime: globalSharedPreference
                                                .getString("endWorkTime")!,
                                            ownerID: globalSharedPreference
                                                    .getString("ID") ??
                                                '0',
                                            ownerEmail: globalSharedPreference
                                                .getString("email")!,
                                            ownerPhoneNumber:
                                                globalSharedPreference
                                                    .getString("phoneNumber")!,
                                            shopID: globalSharedPreference
                                                .getString("shopID")!,
                                            shopName: globalSharedPreference
                                                .getString("shopName")!,
                                            ownerName: globalSharedPreference
                                                .getString("name")!,
                                            followesNumber:
                                                globalSharedPreference
                                                    .getInt("followesNumber")!,
                                            rate: globalSharedPreference
                                                .getDouble("rate"),
                                            shopCoverImage:
                                                globalSharedPreference
                                                    .getString(
                                                        "shopCoverImage"),
                                            shopDescription:
                                                globalSharedPreference
                                                    .getString(
                                                        "shopDescription"),
                                            shopPhoneNumber:
                                                globalSharedPreference
                                                    .getString(
                                                        "shopPhoneNumber"),
                                            shopProfileImage:
                                                globalSharedPreference
                                                    .getString(
                                                        "shopProfileImage"),
                                            latitude: globalSharedPreference
                                                .getDouble("latitude")!,
                                            longitude: globalSharedPreference
                                                .getDouble("longitude")!,
                                          ),
                                          profileDisplay: true));
                                      context.pop();
                                    }),
                                  };
                          },
                        );
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
