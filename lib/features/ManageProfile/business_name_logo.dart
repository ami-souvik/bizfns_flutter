import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../core/utils/fonts.dart';
import '../../core/utils/image_controller.dart';
import 'provider/manage_profile_provider.dart';

class BusinessNameAndLogo extends StatefulWidget {
  const BusinessNameAndLogo({super.key});

  @override
  State<BusinessNameAndLogo> createState() => _BusinessNameAndLogoState();
}

class _BusinessNameAndLogoState extends State<BusinessNameAndLogo> {
  double subContainerHeight = 50.ss;
  Color subContainerColor = const Color(0xFFeaeaea);

  @override
  void initState() {
    Provider.of<ManageProfileProvider>(context, listen: false)
        .setBusinessNameController();
    super.initState();
  }

  pickProfileImage() async {
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () async {
              await ImageController().pickProfileImageFromCamera();
              setState(() {});
              GoRouter.of(context).pop();
            },
            child: const Text('Open Camera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              await Provider.of<ManageProfileProvider>(context, listen: false)
                  .pickProfileImageFromGallery();
              setState(() {});
              GoRouter.of(context).pop();
            },
            child: const Text('Select from gallery'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          /// This parameter indicates the action would perform
          /// a destructive action such as delete or exit and turns
          /// the action's text color to red.
          isDestructiveAction: true,
          onPressed: () {
            GoRouter.of(context).pop();
            // Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 50),
          Stack(
            children: [
              CircleAvatar(
                radius: 70.ss,
                backgroundImage: NetworkImage(
                    'http://182.156.196.67:8085/api/users/downloadMediafile/${Provider.of<ManageProfileProvider>(context, listen: false).imageName}'),
                // backgroundColor: Colors.transparent,
              ),
              Positioned(
                  right: 10,
                  bottom: 10,
                  child: InkWell(
                    onTap: () {
                      pickProfileImage();
                    },
                    child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.camera_alt_rounded)),
                  ))
            ],
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Business Name'),
                SizedBox(height: 10),
                Container(
                  height: subContainerHeight,
                  decoration: BoxDecoration(
                    color: subContainerColor,
                    // border: Border.all(
                    //   color: Colors.grey,
                    //   width: 1.0,
                    // ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: Provider.of<ManageProfileProvider>(
                            context,
                          ).businessNameController,
                          keyboardType: TextInputType.emailAddress,
                          // enabled: Provider.of<
                          //         ManageProfileProvider>(
                          //       context,
                          //     ).isBackUpEmailTextFieldEditable ==
                          //     true,
                          decoration: InputDecoration(
                            hintText: 'Enter your Business Name...',
                            hintStyle: CustomTextStyle(
                              fontSize: 15.fss,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.border_color_sharp),
                        onPressed: () {
                          // Provider.of<ManageProfileProvider>(
                          //         context,
                          //         listen: false)
                          //     .editBackUpEmail();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Align(
            // Wrap the ElevatedButton with Align
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
