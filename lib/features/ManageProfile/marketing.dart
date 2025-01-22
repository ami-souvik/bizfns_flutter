import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../core/utils/fonts.dart';
import '../../core/widgets/common_text.dart';
import 'provider/manage_profile_provider.dart';

class MarketingPage extends StatefulWidget {
  const MarketingPage({super.key});

  @override
  State<MarketingPage> createState() => _MarketingPageState();
}

class _MarketingPageState extends State<MarketingPage> {
  // Widget getEditor(int index) {
  //   final FocusNode focusNode = FocusNode();
  //   return Container(
  //     // decoration: BoxDecoration(
  //     //     border: Border.all(color: Colors.grey.shade300),
  //     //     borderRadius: BorderRadius.all(Radius.circular(10.r))),
  //     // padding: EdgeInsets.only(top: 5.h),
  //     // // margin: EdgeInsets.only(bottom: 5.0),
  //     // width: MediaQuery.of(context).size.width,
  //     // constraints: BoxConstraints(minHeight: 200.h),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: TextField(
  //             style: CustomTextStyle(
  //               fontSize: 15.fss,
  //               fontWeight: FontWeight.w700,
  //               color: Colors.black,
  //             ),
  //             controller: Provider.of<ManageProfileProvider>(
  //               context,
  //             ).allLocationController[index],
  //             keyboardType: TextInputType.phone,
  //             // enabled: Provider.of<ManageProfileProvider>(
  //             //       context,
  //             //     ).isBackUpPhoneTextFieldEditable ==
  //             //     true,
  //             decoration: InputDecoration(
  //               hintText: 'Location Name ${index + 1}',
  //               hintStyle: CustomTextStyle(
  //                 fontSize: 15.fss,
  //                 fontWeight: FontWeight.w700,
  //                 color: Colors.black,
  //               ),
  //               border: OutlineInputBorder(),
  //               contentPadding: EdgeInsets.all(10.0),
  //             ),
  //           ),
  //         ),
  //         InkWell(
  //           onTap: () {
  //             setState(() {
  //               Provider.of<ManageProfileProvider>(context, listen: false)
  //                   .allLocationController
  //                   .removeAt(index);
  //             });
  //           },
  //           child: Icon(
  //             Icons.close,
  //             size: 20,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  // @override
  // void initState() {
  //   if (Provider.of<ManageProfileProvider>(context, listen: false)
  //       .locations
  //       .isNotEmpty) {
  //     for (var i = 0;
  //         i <
  //             Provider.of<ManageProfileProvider>(context, listen: false)
  //                 .locations
  //                 .length;
  //         i++) {
  //       Provider.of<ManageProfileProvider>(context, listen: false)
  //           .generateLocationEditorField();
  //       Provider.of<ManageProfileProvider>(
  //         context,
  //       ).allLocationController[i].text =
  //           Provider.of<ManageProfileProvider>(context, listen: false)
  //               .locations[i];
  //     }
  //   }
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // Provider.of<ManageProfileProvider>(context, listen: false).
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.05),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30.0,
              ),
              Text("Location"),
              SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      // height: 60.ss,
                      // width: MediaQuery.of(context).size.width - 22,
                      child: InkWell(
                          onTap: () {
                            Provider.of<ManageProfileProvider>(context,
                                    listen: false)
                                .addLocation();
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5.0.ss),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0.ss,
                              ),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(10.0.ss),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller:
                                        Provider.of<ManageProfileProvider>(
                                                context,
                                                listen: false)
                                            .newEntry,
                                    decoration: InputDecoration(
                                      hintText: 'Location Name',
                                      border: InputBorder.none,
                                      hintStyle: CustomTextStyle(
                                        fontSize: 15.fss,
                                        fontWeight: FontWeight.w700,
                                        color: Colors
                                            .grey, // Adjust hint text color
                                      ),
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: AppColor.APP_BAR_COLOUR,
                                  child: Icon(Icons.add),
                                ),
                              ],
                            ),
                          )),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.fss,
              ),
              Visibility(
                visible:
                    Provider.of<ManageProfileProvider>(context, listen: false)
                        .locations
                        .isNotEmpty,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.125,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: Provider.of<ManageProfileProvider>(context,
                              listen: false)
                          .locations
                          .map((location) {
                        return Chip(
                          label: Text(location),
                          onDeleted: () {
                            Provider.of<ManageProfileProvider>(context,
                                    listen: false)
                                .removeLocation(location);
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Marketing"),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    controller: Provider.of<ManageProfileProvider>(context,
                            listen: false)
                        .marketing,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.grey, // Change border color here
                          width: 1.0.ss, // Change border width here
                        ),
                      ),
                      hintText: 'Enter text',
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 70.ss,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: InkWell(
                    onTap: () {
                      Provider.of<ManageProfileProvider>(context, listen: false)
                          .setProfileData();
                      print(
                          "allLocations===>${Provider.of<ManageProfileProvider>(context, listen: false).locations}");
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0.ss),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0.ss,
                          ),
                          color: AppColor.APP_BAR_COLOUR,
                        ),
                        padding: EdgeInsets.all(10.0.ss),
                        child: Center(
                          child: CommonText(
                            text: 'Save',
                            textStyle: CustomTextStyle(
                              fontSize: 15.fss,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

class ChipWidget extends StatefulWidget {
  @override
  _ChipWidgetState createState() => _ChipWidgetState();
}

class _ChipWidgetState extends State<ChipWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> locations = [];

  void addLocation() {
    String newValue = _textEditingController.text.trim();
    if (newValue.isNotEmpty && !locations.contains(newValue)) {
      setState(() {
        locations.add(newValue);
      });
      _textEditingController.clear();
    }
  }

  void removeLocation(String value) {
    setState(() {
      locations.remove(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    labelText: 'Enter location',
                  ),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: addLocation,
                child: Text('Add'),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: locations.map((location) {
            return Chip(
              label: Text(location),
              onDeleted: () {
                removeLocation(location);
                setState(() {});
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
