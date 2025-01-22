import 'dart:convert';
import 'dart:developer';

import 'package:bizfns/core/common/Resource.dart';
import 'package:bizfns/core/utils/Utils.dart';
import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/add_schedule_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/api_helper/api_helper.dart';
import '../../../../core/utils/bizfns_layout_widget.dart';
import '../../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../model/ServiceModel/auto_complete_address_model.dart';
import 'package:http/http.dart' as http;

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  AddScheduleModel addScheduleModel = AddScheduleModel.addSchedule;

  // PlaceAutoCompleteModel? placeAutoCompleteModel;

  // void openMap(double latitude, double longitude) async {
  //   String googleUrl =
  //       'https://www.google.com/maps/search/?api=1&query=${22.623642},${88.444067}';
  //   // ignore: deprecated_member_use
  //   if (await canLaunch(googleUrl)) {
  //     launch(googleUrl);
  //   } else {
  //     throw 'Could not open the map.';
  //   }
  // }

  Future<List<Location>?> getLocationFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      print("locations========>$locations");
      double latitude = locations[0].latitude;
      double longitude = locations[0].longitude;
      // print("longitudeString========>$longitudeString");
      // print("longitude========>$longitude");
      _launchUrl(latitude, longitude);
      return locations;
    } catch (e) {
      print("Error getting location from address: $e");
      return null;
    }
  }

  // Future<List<Location>> getAddressSuggestions(String query) async {
  //   try {
  //     List<Location> locations = await locationFromAddress(query);
  //     return locations;
  //   } catch (e) {
  //     print("Error fetching address suggestions: $e");
  //     // Handle the error appropriately, such as showing an error message to the user.
  //     return []; // Return an empty list if no locations are found or if an error occurs.
  //   }
  // }

  // submit() async {
  //   getAddressSuggestions("Your Address Query").then((locations) {
  //     if (locations.isNotEmpty) {
  //       // Handle the list of locations
  //       locations.forEach((location) {
  //         print(
  //             "Latitude: ${location.latitude}, Longitude: ${location.longitude}");
  //         print("Address: ${location}");
  //       });
  //     } else {
  //       // Handle case when no locations are found
  //       print("No locations found for the query.");
  //     }
  //   }).catchError((error) {
  //     // Handle any errors that occur during the process
  //     print("Error fetching address suggestions: $error");
  //   });
  // }

  Future<void> _launchUrl(double lat, double long) async {
    if (!await launchUrl(Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${lat},${long}'))) {
      throw Exception('Could not launch ');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TitleProvider>(context, listen: false).title =
        'Schedule New Modify';
    if (addScheduleModel.location == '') {
      Provider.of<LocationNotifier>(context, listen: false).index = 3;
    } else if (addScheduleModel.location == 'On-Site') {
      Provider.of<LocationNotifier>(context, listen: false).index = 0;
    } else if (addScheduleModel.location == 'Customer-Site') {
      Provider.of<LocationNotifier>(context, listen: false).index = 1;
    } else {
      Provider.of<LocationNotifier>(context, listen: false).selectedAddress =
          addScheduleModel.location ?? "";
    }

    // customerSiteSearch.addListener(() {

    // });
  }

  // Future<void> autoCompleteApi() async {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<LocationNotifier>(
        builder: (context, locationNotifier, child) {
      return SingleChildScrollView(
        child: Container(
          // height: size.height / 1.5,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            color: Color(0xFFFFFF),
          ),
          child: Column(
            children: [
              Container(
                // width: size.w,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 55,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  color: AppColor.APP_BAR_COLOUR,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Location",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<LocationNotifier>(context, listen: false)
                            .setAddress('');
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 22,
                        width: 22,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.clear_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Gap(20),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Add Location",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.all<Color>(
                              AppColor.APP_BAR_COLOUR),
                          value: locationNotifier.getCheckIndex == 0,
                          onChanged: (val) {
                            //Provider.of<LocationNotifier>(context,listen: false).changeIndex(val! ? 0 : 1);
                            locationNotifier.setCheckIndex =
                                (val = false) ? 1 : 0;
                          },
                        ),
                        const Text('On-Site'),
                        const Spacer(
                          flex: 1,
                        ),
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor: MaterialStateProperty.all<Color>(
                              AppColor.APP_BAR_COLOUR),
                          value: locationNotifier.getCheckIndex == 1,
                          onChanged: (val) {
                            //Provider.of<LocationNotifier>(context,listen: false).changeIndex(val! ? 1 : 0);
                            locationNotifier.setCheckIndex =
                                (val = false) ? 0 : 1;
                          },
                        ),
                        const Text('Customer-Site'),
                        const Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                    child: Offstage(
                      offstage: locationNotifier.getCheckIndex == 3 ||
                          locationNotifier.getCheckIndex == 0,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () {
                                    // Add your search logic here
                                  },
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: Provider.of<LocationNotifier>(
                                            context,
                                            listen: false)
                                        .customerSiteSearch,
                                    onChanged: (val) async {
                                      print(
                                          "controller val =====>${Provider.of<LocationNotifier>(context, listen: false).customerSiteSearch.text}");
                                      locationNotifier.addLocation = val;
                                      if (Provider.of<LocationNotifier>(context,
                                                  listen: false)
                                              .customerSiteSearch
                                              .text
                                              .length !=
                                          0) {
                                        await Provider.of<LocationNotifier>(
                                                context,
                                                listen: false)
                                            .fetchLocation(context: context);
                                        setState(() {});
                                      } else {
                                        Provider.of<LocationNotifier>(context,
                                                listen: false)
                                            .placeAutoCompleteModel!
                                            .clearData();
                                      }
                                      // customerSiteSearch.text = val;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'Search Your Location',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(fontSize: 14)),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      Provider.of<LocationNotifier>(context,
                                              listen: false)
                                          .selectedAddress = "";
                                      Provider.of<LocationNotifier>(context,
                                              listen: false)
                                          .customerSiteSearch
                                          .clear();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          // TextField(
                          //   controller: Provider.of<LocationNotifier>(context,
                          //           listen: false)
                          //       .customerSiteSearch,
                          //   onChanged: (val) async {
                          //     print(
                          //         "controller val =====>${Provider.of<LocationNotifier>(context, listen: false).customerSiteSearch.text}");
                          //     locationNotifier.addLocation = val;
                          //     if (Provider.of<LocationNotifier>(context,
                          //                 listen: false)
                          //             .customerSiteSearch
                          //             .text
                          //             .length !=
                          //         0) {
                          //       await Provider.of<LocationNotifier>(context,
                          //               listen: false)
                          //           .fetchLocation();
                          //     } else {
                          //       Provider.of<LocationNotifier>(context,
                          //               listen: false)
                          //           .placeAutoCompleteModel!
                          //           .clearData();
                          //     }
                          //     // customerSiteSearch.text = val;
                          //   },
                          //   decoration: InputDecoration(
                          //     border: OutlineInputBorder(),
                          //     //hintText: 'Enter a search term',
                          //   ),
                          // ),
                          Provider.of<LocationNotifier>(context, listen: false)
                                      .placeAutoCompleteModel !=
                                  null
                              ? Visibility(
                                  visible: Provider.of<LocationNotifier>(
                                          context,
                                          listen: false)
                                      .customerSiteSearch
                                      .text
                                      .isNotEmpty,
                                  child: SizedBox(
                                    height: size.height * 0.2,
                                    child: Provider.of<LocationNotifier>(
                                                context,
                                                listen: false)
                                            .isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : ListView.builder(
                                            itemCount: Provider.of<
                                                            LocationNotifier>(
                                                        context,
                                                        listen: false)
                                                    .placeAutoCompleteModel!
                                                    .predictions
                                                    .isNotEmpty
                                                ? Provider.of<LocationNotifier>(
                                                        context,
                                                        listen: false)
                                                    .placeAutoCompleteModel!
                                                    .predictions
                                                    .length
                                                : 0,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                onTap: () {
                                                  Provider.of<LocationNotifier>(
                                                          context,
                                                          listen: false)
                                                      .setAddress(
                                                          "${Provider.of<LocationNotifier>(context, listen: false).placeAutoCompleteModel!.predictions[index].description}");
                                                  // addScheduleModel.location =
                                                  //     "${Provider.of<LocationNotifier>(context, listen: false).placeAutoCompleteModel!.predictions[index].description}";
                                                  setState(() {
                                                    Provider.of<LocationNotifier>(
                                                            context,
                                                            listen: false)
                                                        .customerSiteSearch
                                                        .clear();
                                                  });
                                                },
                                                leading: const Icon(
                                                  Icons.location_on,
                                                  color:
                                                      AppColor.APP_BAR_COLOUR,
                                                ),
                                                title: Text(
                                                  "${Provider.of<LocationNotifier>(context, listen: false).placeAutoCompleteModel!.predictions[index].description}",
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                )
                              : const SizedBox(),
                          // TextButton(
                          //     onPressed: () async {
                          //       await getLocationFromAddress(
                          //           "${Provider.of<LocationNotifier>(context, listen: false).selectedAddress}");
                          //     },
                          //     child: Text('Launch'))
                        ],
                      ),
                    ),
                  ),
                  const Gap(10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: Provider.of<LocationNotifier>(context,
                                listen: false)
                            .selectedAddress
                            .isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      const TextSpan(
                                        text: 'Your Selected Address: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: Provider.of<LocationNotifier>(
                                                context,
                                                listen: false)
                                            .selectedAddress,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Gap(15),
                      GestureDetector(
                        onTap: () {
                          if (locationNotifier.getCheckIndex == 0) {
                            addScheduleModel.location = "On-Site";
                            Navigator.pop(context);
                          } else if (locationNotifier.getCheckIndex == 1) {
                            if (locationNotifier.location.isEmpty) {
                              /*Utils().ShowWarningSnackBar(context, 'Warning',
                              'Please add your off site location');*/
                              addScheduleModel.location = "Customer-Site";
                              Navigator.pop(context);
                            } else {
                              addScheduleModel.location =
                                  "${Provider.of<LocationNotifier>(context, listen: false).selectedAddress}";
                              Navigator.pop(context);
                            }
                          }
                          //if(addScheduleModel.location != null){

                          //}
                        },
                        child: const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            child: CustomButton(
                              title: 'Select',
                            ),
                          ),
                        ),
                      ),
                      const Gap(15),
                    ],
                  ),
                ],
              ),

              // Gap(10.ss),

              //           Gap(10.ss),
            ],
          ),
        ),
      );
    });
  }
}

class LocationNotifier extends ChangeNotifier {
  PlaceAutoCompleteModel? placeAutoCompleteModel;
  int index = 1;
  TextEditingController customerSiteSearch = TextEditingController();

  String location = "";
  bool isLoading = false;

  int get getCheckIndex => index;

  String get getLocation => location;
  String selectedAddress = '';

  set setCheckIndex(int newIndex) {
    index = newIndex;
    notifyListeners();
  }

  set addLocation(String addedLocation) {
    location = addedLocation;
    notifyListeners();
  }

  setAddress(pickedAddress) {
    selectedAddress = pickedAddress;
    notifyListeners();
  }

  Future<void> fetchLocation({required BuildContext context}) async {
    print("Fetch location function is calling");
    print("customer site : ${customerSiteSearch.text}");
    if (customerSiteSearch.text.isNotEmpty) {
      // placeAutoCompleteModel!.clearData();
      try {
        isLoading = true;
        final response = await http.get(Uri.parse(
            "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${customerSiteSearch.text}&types=establishment&radius=500&key=AIzaSyD99_lCLJsmOFNPC8H3VAJDggvxLezr5sg"));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body.toString());
          if (data['status'] == "OK") {
            placeAutoCompleteModel = PlaceAutoCompleteModel.fromJson(data);
            notifyListeners();
          } else {
            Utils().ShowWarningSnackBar(context, "Failed",'${data['error_message']}');
          }
          isLoading = false;
        }
      } catch (e) {
        if (kDebugMode) {
          print("something went wrong while fetching");
        }
        isLoading = false;
      }
    } else {
      placeAutoCompleteModel!.clearData();
      notifyListeners();
    }
  }

  // Future<Resource> autoCompleteApi({required String address}) async {
  //   // try {
  //   // Utils().printMessage("here im");
  //   // OtpVerificationData? loginData = await GlobalHandler.getLoginData();
  //   // List<String> deviceDetails = await Utils.getDeviceDetails();
  //   // String? userId = await GlobalHandler.getUserId();
  //   // Utils().printMessage("here im");
  //   // var body = {
  //   //   "deviceId": deviceDetails[0],
  //   //   "deviceType": deviceDetails[1],
  //   //   "appVersion": deviceDetails[2],
  //   //   "tenantId": loginData!.tenantId,
  //   //   "userId": userId,
  //   //   "fromDate":
  //   //       date.contains(' ') ? date.split(' ')[0] : date, //"2023-08-22",
  //   // };

  //   // Utils().printMessage("GET_SCHEDULE_BODY==>${jsonEncode(body)}");
  //   // String? token = await GlobalHandler.getToken();
  //   // if (token == null) {
  //   //   OtpVerificationData? data = await GlobalHandler.getLoginData();
  //   //   token = data!.token ?? "";
  //   //   await GlobalHandler.setToken(token);
  //   // }
  //   // Utils().printMessage(token.toString());
  //   Utils().printMessage("here imddwfd");
  //   final response = await ApiHelper().apiCall(
  //     url:
  //         "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${address}&types=establishment&radius=500&key=AIzaSyD99_lCLJsmOFNPC8H3VAJDggvxLezr5sg",
  //     requestType: RequestType.GET,
  //   );

  //   log('Response: ${jsonEncode(response.data)}');
  //   // ignore: unrelated_type_equality_checks
  //   if (response != null) {
  //     final data = await jsonDecode(response.data['predictions']);
  //     print("data==========>$data");
  //     // if (data['status'] == 'OK') {
  //     //   placeAutoCompleteModel = PlaceAutoCompleteModel.fromJson(data);
  //     //   debugPrint('Body ---$data');
  //     // }
  //   }
  //   return response;

  //   //   try {
  //   //     Utils().printMessage(response.data.toString());
  //   //     if (response != null && response.status == STATUS.SUCCESS) {
  //   //       if (response.data["success"] == true) {
  //   //         Map<String, dynamic> data = response.data as Map<String, dynamic>;

  //   //         ScheduleListResponse resp = ScheduleListResponse.fromJson(data);

  //   //         return Resource(
  //   //             status: STATUS.SUCCESS,
  //   //             data: resp,
  //   //             message: response.data["message"]);
  //   //       } else {
  //   //         return Resource.error(message: response.data["message"].toString());
  //   //       }
  //   //     } else {
  //   //       if (response.data.toString() == "403") {
  //   //         return Resource.error(message: TOKEN_EXPIRED);
  //   //       } else {
  //   //         return Resource.error(message: response.message);
  //   //       }
  //   //     }
  //   //   } catch (e) {
  //   //     Utils().printMessage('Catch Error $e');
  //   //     return Resource.error(message: SomethingWentWrong);
  //   //   }
  //   // } catch (e) {
  //   //   Utils().printMessage(e.toString());
  //   //   return Resource.error(message: SomethingWentWrong);
  //   // }
  // }

  /*changeIndex(int val) {
    index = val;
    notifyListeners();
  }*/
}
