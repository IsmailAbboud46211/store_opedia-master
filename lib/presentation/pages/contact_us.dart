// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopesapp/main.dart';
import 'package:shopesapp/presentation/shared/custom_widgets/custom_text.dart';
import 'package:shopesapp/presentation/shared/extensions.dart';
import 'package:shopesapp/translation/locale_keys.g.dart';
import '../../data/enums/file_type.dart';
import '../../data/enums/message_color.dart';
import '../../data/enums/message_type.dart';
import '../../logic/cubites/cubit/settings/contact_us_cubit.dart';
import '../../logic/cubites/cubit/settings/get_caht_messages_cubit.dart';
import '../shared/colors.dart';
import '../shared/custom_widgets/custom_toast.dart';
import '../shared/utils.dart';
import '../widgets/contactUs/admin_message.dart';
import '../widgets/contactUs/no_message_yet.dart';
import '../widgets/contactUs/user_message.dart';
import '../widgets/switch_shop/error.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  List<dynamic> messages = [];
  bool? isMessageSelected;
  String? currentMessage;
  FocusNode focusNode = FocusNode();
  TextEditingController message = TextEditingController();
  @override
  void initState() {
    context.read<GetCahtMessagesCubit>().getChatMessages(
        ownerID: globalSharedPreference.getString("ID") ?? '0');
    isMessageSelected = false;
    globalSharedPreference.setBool("isMessageSelected", false);
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {}
    });
  }

  final ImagePicker picker = ImagePicker();
  FileTypeModel? selectedFile;
  File? imageFile;
  String? errorImageType;
  String? splitImagePath;
  String? imageBase64;
  Future<FileTypeModel> pickFile(FileType type) async {
    String? path;
    switch (type) {
      case FileType.GALLERY:
        await picker
            .pickImage(source: ImageSource.gallery)
            .then((value) => path = value?.path ?? selectedFile?.path ?? '');
        imageFile = File(path!);
        splitImagePath = path!.split("/").last;
        errorImageType = splitImagePath!.split(".").last;
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
          errorImageType = splitImagePath!.split(".").last;
          imageBase64 = base64Encode(imageFile!.readAsBytesSync());
        });

        break;
    }
    return FileTypeModel(path ?? '', type);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                color: AppColors.mainTextColor,
                onPressed: () {
                  context.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.mainWhiteColor,
                ),
              ),
              Stack(children: [
                CircleAvatar(
                  radius: size.width * 0.065,
                  child: Image.asset(
                    'assets/admin.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: size.width * 0.15, top: size.width * 0.05),
                  child: CustomText(
                    text: LocaleKeys.admin.tr(),
                    textColor: AppColors.mainWhiteColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                      start: size.width * 0.09, top: size.width * 0.09),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: size.width * 0.025,
                        backgroundColor: AppColors.mainWhiteColor,
                        child: CircleAvatar(
                          radius: size.width * 0.02,
                          backgroundColor: Colors.green,
                        ),
                      ),
                      2.px,
                      CustomText(
                        text: LocaleKeys.online.tr(),
                        textColor: AppColors.mainWhiteColor,
                        fontSize: size.width * 0.03,
                      )
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              (size.width * 0.008).ph,
              BlocConsumer<GetCahtMessagesCubit, GetCahtMessagesState>(
                listener: (context, state) {
                  if (state is GetCahtMessagesFailed) {
                    CustomToast.showMessage(
                        context: context,
                        size: size,
                        message: state.message.toUpperCase(),
                        messageType: MessageType.REJECTED);
                  }
                },
                builder: (context, state) {
                  if (state is GetCahtMessagesProgress) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is GetCahtMessagesSucceed) {
                    if (context.read<GetCahtMessagesCubit>().messages.isEmpty) {
                      return buildNoMessagesYet(size);
                    }

                    messages = context.read<GetCahtMessagesCubit>().messages;
                    return SizedBox(
                      height: size.height - 140,
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (messages[index]["reply"] != null) {
                              return Padding(
                                padding: EdgeInsets.all((size.width * 0.008)),
                                child: adminMessage(size, messages[index]),
                              );
                            }
                            return Padding(
                              padding: EdgeInsets.all((size.width * 0.008)),
                              child: userMessage(size, messages[index]),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              (size.width * 0.8).px,
                          itemCount: messages.length),
                    );
                  }
                  return buildError(size);
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment:
                          globalSharedPreference.getBool("isArabic") == false
                              ? AlignmentDirectional.centerStart
                              : AlignmentDirectional.centerEnd,
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width - 55,
                            child: Card(
                                margin: const EdgeInsets.only(
                                    left: 2, right: 2, bottom: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: TextFormField(
                                  controller: message,
                                  focusNode: focusNode,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 5,
                                  minLines: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      currentMessage = value;
                                      message.text = currentMessage!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      hintText: LocaleKeys
                                          .type_your_message_here
                                          .tr(),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            showTypeMessage(size);
                                          },
                                          icon: Icon(
                                            Icons.list,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                      prefixIcon: IconButton(
                                        icon: Icon(
                                          Icons.camera_alt,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () {
                                          focusNode.unfocus();
                                          focusNode.canRequestFocus = false;
                                          pickImageDialg();
                                        },
                                      ),
                                      contentPadding: const EdgeInsets.all(5)),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Align(
                              alignment:
                                  globalSharedPreference.getBool("isArabic") ==
                                          false
                                      ? AlignmentDirectional.bottomEnd
                                      : AlignmentDirectional.bottomStart,
                              child: BlocProvider(
                                create: (context) => ContactUsCubit(),
                                child: BlocConsumer<ContactUsCubit,
                                    ContactUsState>(
                                  listener: (context, state) {
                                    if (state is ContactUsSucceed) {
                                      CustomToast.showMessage(
                                          context: context,
                                          size: size,
                                          message: LocaleKeys
                                              .message_sent_successfuly
                                              .tr(),
                                          messageType: MessageType.SUCCESS);
                                      context.pushRepalceme(const ContactUs());
                                    } else if (state is ContactUsFailed) {
                                      CustomToast.showMessage(
                                          context: context,
                                          size: size,
                                          message: state.message.toUpperCase(),
                                          messageType: MessageType.REJECTED);
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is ContactUsProgress) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return Padding(
                                      padding:
                                          EdgeInsets.all((size.width * 0.0008)),
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.send,
                                            color: AppColors.mainWhiteColor,
                                          ),
                                          onPressed: () {
                                            globalSharedPreference.getBool(
                                                            "isMessageSelected") ==
                                                        false &&
                                                    currentMessage == null
                                                ? CustomToast.showMessage(
                                                    context: context,
                                                    size: size,
                                                    message: LocaleKeys
                                                        .please_check_required_fields
                                                        .tr(),
                                                    messageType:
                                                        MessageType.REJECTED)
                                                : {
                                                    context
                                                        .read<ContactUsCubit>()
                                                        .contactUS(
                                                          id: globalSharedPreference
                                                              .getString("ID")!,
                                                          description:
                                                              message.text,
                                                          photo: imageBase64 ??
                                                              "url",
                                                          imageType:
                                                              errorImageType ??
                                                                  "",
                                                          type: globalSharedPreference
                                                                  .getString(
                                                                      "messageType") ??
                                                              "others",
                                                        ),
                                                  };
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    selectedFile == null
                        ? Container()
                        : Wrap(
                            children: [
                              Container(
                                  height: size.height / 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        size.width * 0.05),
                                    color: AppColors.mainWhiteColor,
                                  ),
                                  width: size.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        size.width * 0.05),
                                    child: Image.file(
                                      File(selectedFile!.path),
                                      fit: BoxFit.contain,
                                    ),
                                  ))
                            ],
                          ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future showTypeMessage(Size size) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top:
                    Radius.circular(MediaQuery.of(context).size.width * 0.08))),
        builder: (context) => Wrap(
              children: [
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: CustomText(
                                  text: LocaleKeys.selecte_message_type.tr())),
                        ],
                      ),
                      (size.width * 0.008).ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                globalSharedPreference.setBool(
                                    "isMessageSelected", true);

                                globalSharedPreference.setString(
                                    "messageType", messageTypes[0]);
                                context.pop();
                                setState(() {
                                  message.text = currentMessage!;
                                });
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: messageColor[0],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: Text(LocaleKeys.error.tr()),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              globalSharedPreference.setBool(
                                  "isMessageSelected", true);
                              globalSharedPreference.setString(
                                  "messageType", messageTypes[1]);
                              context.pop();
                              setState(() {
                                message.text = currentMessage!;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: messageColor[1],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: Text(LocaleKeys.suggestion.tr()),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              globalSharedPreference.setBool(
                                  "isMessageSelected", true);
                              globalSharedPreference.setString(
                                  "messageType", messageTypes[2]);
                              context.pop();
                              setState(() {
                                message.text = currentMessage!;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: messageColor[2],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: Text(LocaleKeys.guidance.tr()),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              globalSharedPreference.setBool(
                                  "isMessageSelected", true);
                              globalSharedPreference.setString(
                                  "messageType", messageTypes[3]);
                              context.pop();
                              setState(() {
                                message.text = currentMessage!;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: messageColor[3],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: Text(LocaleKeys.others.tr()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
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
