import 'dart:developer';
import 'package:astrowaypartner/views/golderheart/widgets/app_bar_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrowaypartner/widgets/custom_app_bar.dart';
import 'package:astrowaypartner/controllers/search_place_controller.dart';
import 'package:astrowaypartner/controllers/Authentication/signup_controller.dart';


class CurrentCityWidget extends StatelessWidget {
  final int? flagId;
  CurrentCityWidget({super.key, this.flagId});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CustomApp(title: 'Current City', isBackButtonExist: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<SearchPlaceController>(
          builder: (searchPlaceController) {
            return GetBuilder<SignupController>(
              builder: (controller) {
                return Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: TextField(
                        onChanged: (value) async {
                          await searchPlaceController.autoCompleteSearch(value);
                        },
                        controller: searchPlaceController.searchController,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Get.theme.iconTheme.color,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          ),
                          hintText: 'Search City',
                          hintStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: searchPlaceController.predictions?.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(searchPlaceController
                                .predictions![index].primaryText),
                            subtitle: Text(
                              searchPlaceController
                                  .predictions![index].secondaryText ?? '',
                            ),
                            onTap: () async {
                              try {
                                // Get latitude and longitude from address
                                final address = searchPlaceController
                                    .predictions![index].primaryText;
                                final List<Location> location =
                                await locationFromAddress(address);

                                final double latitude = location[0].latitude;
                                final double longitude = location[0].longitude;

                                // Get detailed place information
                                final List<Placemark> placemarks =
                                await placemarkFromCoordinates(
                                  latitude,
                                  longitude,
                                );

                                final Placemark placemark = placemarks.first;
                                final String fullAddress =
                                    '${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';



                                searchPlaceController.searchController.text =
                                    fullAddress;




                                searchPlaceController.update();


                                Get.back();
                              } catch (e) {
                                log('Error fetching location details: $e');
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
