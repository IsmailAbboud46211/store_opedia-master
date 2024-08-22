// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopesapp/data/enums/file_type.dart';
import 'package:shopesapp/data/enums/message_type.dart';
import 'package:shopesapp/logic/cubites/post/add_post_cubit.dart';
import 'package:shopesapp/logic/cubites/post/posts_cubit.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/presentation/shared/colors.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_button.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_text.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_toast.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/user_input.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/presentation/shared/utils.dart';

import '../../translation/locale_keys.g.dart';
import '../shared/validation_functions.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final ImagePicker picker = ImagePicker();
  TextEditingController addPostPriceController = TextEditingController();
  TextEditingController addPostNameController = TextEditingController();
  TextEditingController addPostDescriptionController = TextEditingController();
  FileTypeModel? selectedFile;
  File? imageFile;
  String? postImageType;
  String? splitImagePath;
  String? imageBase64;
  void getImagePath() {}
  Future<FileTypeModel> pickFile(FileType type) async {
    String? path;
    switch (type) {
      case FileType.GALLERY:
        await picker
            .pickImage(source: ImageSource.gallery)
            .then((value) => path = value?.path ?? selectedFile?.path ?? '');
        imageFile = File(path!);
        splitImagePath = path!.split("/").last;
        postImageType = splitImagePath!.split(".").last;
        imageBase64 = base64Encode(imageFile!.readAsBytesSync());

        context.pop();

        break;
      case FileType.CAMERA:
        await picker
            .pickImage(source: ImageSource.camera)
            .then((value) => path = value?.path ?? selectedFile?.path ?? '');
        context.pop();
        setState(() {
          imageFile = File(path!);
          splitImagePath = path!.split("/").last;
          postImageType = splitImagePath!.split(".").last;
          imageBase64 = base64Encode(imageFile!.readAsBytesSync());
        });

        break;
    }
    return FileTypeModel(path ?? '', type);
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: w * 0.06, horizontal: w * 0.06),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: ListView(children: [
            Center(
                child: CustomText(
              text: LocaleKeys.add_Post.tr(),
              fontSize: w * 0.07,
              textColor: Theme.of(context).primaryColorDark,
            )),
            (w * 0.04).ph,
            Center(
                child: CustomText(text: LocaleKeys.add_your_post_details.tr())),
            (w * 0.06).ph,
            Center(
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  InkWell(
                    onTap: selectedFile == null
                        ? () {
                            pickImageDialg();
                            setState(() {});
                          }
                        : null,
                    child: Wrap(
                      children: [
                        Container(
                          height: h / 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(w * 0.05),
                            color: Colors.transparent,
                          ),
                          width: w,
                          child: (selectedFile != null)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(w * 0.05),
                                  child: Image.file(
                                    File(selectedFile!.path),
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Image.asset(
                                  'assets/store_cover_placeholder.jpg',
                                  fit: BoxFit.contain,
                                ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      pickImageDialg();
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: w * 0.036,
                      backgroundColor: AppColors.mainWhiteColor,
                      child: CircleAvatar(
                          radius: w * 0.026,
                          backgroundColor: AppColors.mainBlueColor,
                          child: Icon(
                            selectedFile != null &&
                                    selectedFile!.path.isNotEmpty
                                ? Icons.edit
                                : Icons.add,
                            size: w * 0.03,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            20.ph,
            CustomText(
              text: selectedFile == null ? LocaleKeys.required_filed.tr() : '',
              textColor: AppColors.mainRedColor,
              fontSize: 12,
            ),
            SizedBox(
              height: w * 0.04,
            ),
            UserInput(
              controller: addPostNameController,
              text: LocaleKeys.product_Name.tr(),
              validator: (name) =>
                  nameValidator(name, LocaleKeys.enter_product_name.tr()),
            ),
            UserInput(
              text: LocaleKeys.product_Description.tr(),
              controller: addPostDescriptionController,
              validator: (p0) {
                return p0!.isEmpty ? LocaleKeys.required_filed.tr() : '';
              },
            ),
            UserInput(
              text: LocaleKeys.product_price.tr(),
              controller: addPostPriceController,
              validator: (p0) {
                return p0!.isEmpty ? LocaleKeys.required_filed.tr() : '';
              },
            ),
            (w * 0.1).ph,
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
              (w * 0.08).px,
              Expanded(
                  child: BlocProvider(
                create: (context) => AddPostCubit(),
                child: BlocConsumer<AddPostCubit, AddPostState>(
                  listener: (context, state) async {
                    if (state is AddPostSucceed) {
                      CustomToast.showMessage(
                          context: context,
                          size: size,
                          message: LocaleKeys.add_Post_Successfully.tr(),
                          messageType: MessageType.SUCCESS);
                      context
                          .read<PostsCubit>()
                          .getOwnerPosts(
                            ownerID:
                                globalSharedPreference.getString("ID") ?? '0',
                            shopID: globalSharedPreference.getString("shopID")!,
                          )
                          .then((value) => context.pop());
                    } else if (state is AddPostFailed) {
                      CustomToast.showMessage(
                          context: context,
                          size: size,
                          message: state.message,
                          messageType: MessageType.REJECTED);
                    }
                  },
                  builder: (context, state) {
                    if (state is AddPostProgress) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return CustomButton(
                      onPressed: () {
                        !formKey.currentState!.validate() &&
                                (selectedFile == null ||
                                    selectedFile!.path.isEmpty)
                            ? CustomToast.showMessage(
                                context: context,
                                size: size,
                                message: LocaleKeys.please_check_required_fields
                                    .tr(),
                                messageType: MessageType.REJECTED)
                            : {
                                formKey.currentState!.save(),
                                context.read<AddPostCubit>().addPost(
                                      postImageType: postImageType!,
                                      title: addPostNameController.text,
                                      description:
                                          addPostDescriptionController.text,
                                      postImage: imageBase64 ?? "url",
                                      category: "",
                                      price: addPostPriceController.text,
                                      shopeID: globalSharedPreference
                                          .getString("shopID")!,
                                    ),
                              };
                      },
                      text: LocaleKeys.post.tr(),
                      textColor: AppColors.mainWhiteColor,
                    );
                  },
                ),
              )),
            ]),
          ]),
        ),
      ),
    ));
  }

  Future pickImageDialg() {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(MediaQuery.of(context).size.width * 0.08))),
      builder: (context) => Wrap(
        children: [
          Column(
            children: [
              Container(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          pickFile(FileType.CAMERA)
                              .then((value) => selectedFile = value);
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
                            (MediaQuery.of(context).size.width * 0.08).px,
                            CustomText(
                              text: LocaleKeys.camera.tr(),
                              fontSize:
                                  (MediaQuery.of(context).size.width * 0.04),
                            )
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          pickFile(FileType.GALLERY)
                              .then((value) => selectedFile = value);
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
                            (MediaQuery.of(context).size.width * 0.08).px,
                            CustomText(
                              text: LocaleKeys.gallery.tr(),
                              fontSize:
                                  (MediaQuery.of(context).size.width * 0.04),
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
        ],
      ),
    );
  }
}
