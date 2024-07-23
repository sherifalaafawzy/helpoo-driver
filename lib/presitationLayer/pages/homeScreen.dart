import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpoo/dataLayer/models/vehicle.dart';
import 'package:helpoo/presitationLayer/widgets/round_button.dart';
import 'package:helpoo/service_request/core/util/constants.dart' as constants;
import 'package:helpoo/service_request/core/util/prints.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../dataLayer/bloc/app/app_bloc.dart';
import '../../dataLayer/constants/variables.dart';
import '../../dataLayer/models/carServiceType.dart';
import '../../dataLayer/models/currentUser.dart';
import '../../dataLayer/models/package.dart';
import '../widgets/willPopScopeWidget.dart';
import 'connectionError.dart';
import 'driverHome.dart';
import 'shared/choosePackage.dart';
import 'shared/contact_us.dart';
import 'shared/errorPage.dart';
import 'shared/myCars.dart';
import 'shared/profilePage.dart';
import 'shared/setting.dart';
import 'userHome.dart';

class homeScreen extends StatefulWidget {
  final int index;

  const homeScreen({Key? key, required this.index}) : super(key: key);

  @override 
  State<homeScreen> createState() => homeScreenState();
}

class homeScreenState extends State<homeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    constants.token = CurrentUser.token ?? '';
    constants.userId = CurrentUser.userId ?? 0;
    constants.currentId = CurrentUser.id ?? 0;
    printWarning('current Id: ${CurrentUser.id}');
    printWarning('currentUserId: ${CurrentUser.userId}');
    printWarning('currentUserToken: ${constants.token}');

    var appBloc = BlocProvider.of<AppBloc>(context);
    setState(() {
      _selectedIndex = widget.index;
    });

    getAllCarServiseTypes(appBloc);
    getAllPackage(appBloc);
    appBloc.getInsuranceCompany();

    super.initState();
  }

  void getAllCarServiseTypes(appBloc) {
    CarServiceType.carServiceTypes = appBloc.getAllTypes();
  }

  void getAllPackage(appBloc) async {
    Package.packages = await appBloc.getAllPackages();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _pages = <Widget>[
    userHome(),
    MyCars(),
    choosePackage(
      register: false,
    ),
    ContactUs(),
    setting(),
    profileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppBlocState>(
      builder: (context, state) {
        if (state is NetworkFailure) {
          return connectionError();
        } else {
          if (CurrentUser.isDriver) {
            return DriverHome();
          }
          if (CurrentUser.blocked == true) {
            return ErrorPage("You are blocked".tr);
          } else {
            return willPopScopeWidget(
              onWillPop: () async {
                bool shouldExit = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Are you sure you want to exit?'.tr),
                    actions: <Widget>[
                      RoundButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          padding: true,
                          text: 'No'.tr,
                          color: appBlack),
                      SizedBox(
                        height: 10,
                      ),
                      RoundButton(
                          onPressed: () {
                            SystemNavigator.pop();
                            return true;
                          },
                          // onPressed: () => Navigator.of(context).pop(true),
                          padding: true,
                          text: 'Yes'.tr,
                          color: mainColor)
                    ],
                  ),
                );

                return shouldExit;
              },
              child: Scaffold(
                backgroundColor: appWhite,
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: appWhite),
                  backgroundColor: mainColor,
                  centerTitle: _selectedIndex == 0 ? false : true,
                  leading: _selectedIndex == 0
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIndex = 5;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CircleAvatar(
                              child: ClipRRect(
                                child: Image.asset('assets/imgs/person.jpg',
                                    width: 300),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                          ),
                        )
                      : _selectedIndex == 1 && Vehicle.addVehicle
                          ? Container(
                              height: 48,
                              width: 48,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    if (Vehicle.addVehicle) {
                                      debugPrint('addVehicle: false');
                                      Vehicle.addVehicle = false;
                                      setState(() {
                                        _selectedIndex = 1;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    CurrentUser.isArabic
                                        ? MdiIcons.arrowRightThin
                                        : MdiIcons.arrowLeftThin,
                                    color: appWhite,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                  title: Text(
                    _selectedIndex == 0
                        ? "hello".tr + ' , ${CurrentUser.name}'
                        : _selectedIndex == 1
                            ? CurrentUser.cars.isEmpty
                                ? "Add Vehicle".tr
                                : "my vehicles".tr
                            : _selectedIndex == 2
                                ? "Package Subscription".tr
                                : _selectedIndex == 3
                                    ? "contact us".tr
                                    : _selectedIndex == 4
                                        ? "Settings".tr
                                        : _selectedIndex == 5
                                            ? "Profile".tr
                                            : "",
                    style: GoogleFonts.tajawal(
                      textStyle: const TextStyle(
                        color: appWhite,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0,
                      ),
                    ),
                    maxLines: 2,
                    // overflow: TextOverflow.visible,
                  ),
                  actions: [
                    if (!CurrentUser.isCorporate) ...[
                      _selectedIndex == 0 && CurrentUser.packages.length == 0
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = 2;
                                  });
                                },
                                child: Container(
                                  width: Get.width * .4,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/imgs/giftCard.png'),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Activate Package".tr,
                                          style: GoogleFonts.tajawal(
                                            textStyle: TextStyle(
                                              color: appWhite,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 174, 16, 5),
                                      border: Border.all(
                                        color: white,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      )),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ] else ...[
                      const SizedBox(),
                    ],
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  backgroundColor: mainColor,
                  elevation: 0,
                  iconSize: 20,
                  selectedFontSize: 12,
                  selectedIconTheme:
                      const IconThemeData(color: appWhite, size: 20),
                  selectedItemColor: appWhite,
                  selectedLabelStyle: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: appWhite,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0,
                    ),
                  ),
                  unselectedIconTheme: const IconThemeData(
                    color: Color(0xffbfd5c7),
                  ),
                  unselectedItemColor: const Color(0xffbfd5c7),
                  unselectedLabelStyle: GoogleFonts.tajawal(
                    textStyle: const TextStyle(
                      color: Color(0xffbfd5c7),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 12.0,
                    ),
                  ),
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const Icon(MdiIcons.home),
                      label: 'main screen'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(MdiIcons.car),
                      label: 'my vehicles'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(MdiIcons.formatAlignLeft),
                      label: 'packages'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(MdiIcons.cellphoneWireless),
                      label: 'contact us'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(MdiIcons.cog),
                      label: 'Settings'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.person),
                      label: 'Profile'.tr,
                    ),
                  ],
                ),
                body: _pages.elementAt(_selectedIndex),
              ),
            );
          }
        }
      },
    );
  }
}
