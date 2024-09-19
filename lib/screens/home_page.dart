import 'package:file_observer/shared/toast.dart';
import 'package:flutter/material.dart';

import 'package:file_observer/services/auth.dart';
import 'package:file_observer/services/database.dart';
import 'package:file_observer/shared/constants.dart';
import 'package:file_observer/shared/section_grid_view.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:file_observer/shared/tender_list.dart';

import '../models/user.dart';
import '../models/tender.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

//import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String qrCodeResult = "Ready To Scan...";

  String? certainTender, tenderDirection, enteredTenderName = '';

  final AuthService _authUser = AuthService();
  final dateFormat = DateFormat('dd/MM/yyyy hh:mm:ss a');

  bool scan = false;
  bool getNewScan = true;
  bool isNotfound = false;
  Color bgColor = Colors.white;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? cUserUid, cUserName, cUserSection;
  List<Tender?>? cTendersList;
  late MobileScannerController camController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    certainTender = '';
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  final TextEditingController searchTextEditingControllerByNo =
      TextEditingController();
  final TextEditingController searchTextEditingControllerByName =
      TextEditingController();

  final TextEditingController newTenderTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppUser currentUser = Provider.of<AppUser>(context);
    UserData currentUserInfo = Provider.of<UserData>(context);
    List<Tender> currentTendersList = Provider.of<List<Tender>>(context);
    String version = Provider.of<String>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    const runningVersion = '0';

    cUserUid = currentUser.uid;
    cUserSection = currentUserInfo.userSection;
    cUserName = currentUserInfo.userName;
    String shortUserName =
        cUserName!.substring(0, cUserName!.length > 8 ? 8 : cUserName!.length);
    cTendersList = currentTendersList;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome $shortUserName',
          softWrap: true,
        ),
        centerTitle: false,
        actions: <Widget>[
          ElevatedButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('logout'),
            onPressed: () async {
              await _authUser.signOut();
            },
          ),
          //Text('welcome'),
        ],
      ),
      body: (version == runningVersion)
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: scan ? screenHeight / 2 : 0,
                    width: scan ? screenWidth : 0,
                    child: scan
                        ? _buildQrView(context, screenWidth / 2)
                        : const SizedBox(
                            height: 0,
                          ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: Text(
                        qrCodeResult == 'Ready To Scan...'
                            ? qrCodeResult
                            : 'Scanned File is: $qrCodeResult',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                  SizedBox(
                    width: screenWidth,
                    height: 200,
                    //padding: EdgeInsets.all(5),
                    child: currentTendersList.isNotEmpty
                        ? const SectionsGridView()
                        : const Image(
                            image: AssetImage('assets/images/logo.jpg')),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: TextFormField(
                      controller: searchTextEditingControllerByNo,
                      keyboardType: TextInputType.number,
                      decoration: textInputDecoration.copyWith(
                          suffixIcon: certainTender != ''
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      searchTextEditingControllerByNo.clear();
                                      searchTextEditingControllerByName.clear();
                                      certainTender = '';
                                    });
                                  })
                              : null,
                          fillColor: Colors.blue[100],
                          hintStyle: const TextStyle(color: Colors.red),
                          hintText: 'Search a tender by NUMBER'),
                      onChanged: (val) {
                        setState(() {
                          certainTender = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: TextFormField(
                      controller: searchTextEditingControllerByName,
                      keyboardType: TextInputType.text,
                      decoration: textInputDecoration.copyWith(
                          suffixIcon: certainTender != ''
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      searchTextEditingControllerByNo.clear();
                                      searchTextEditingControllerByName.clear();
                                      certainTender = '';
                                    });
                                  })
                              : null,
                          fillColor: Colors.blue[100],
                          hintStyle: const TextStyle(color: Colors.red),
                          hintText: 'Search a tender by NAME'),
                      onChanged: (val) {
                        setState(() {
                          certainTender = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    height: screenHeight - 470,
                    width: screenWidth,
                    child: currentTendersList.isNotEmpty
                        ? TenderList(
                            filter: certainTender,
                          )
                        : const Image(
                            image: AssetImage('assets/images/logo.jpg')),
                  ),
                ],
              ),
            )
          : const Center(
              child: Text('Check the app version',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ))),
      floatingActionButton: (version == runningVersion)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "Dismiss",
                  elevation: 25,
                  backgroundColor: const Color.fromARGB(255, 219, 109, 101),
                  onPressed: () {
                    if (qrCodeResult != "Ready To Scan...") {
                      setState(() {
                        qrCodeResult = "Ready To Scan...";
                        getNewScan = true;
                        //controller.resumeCamera();
                      });
                      FlutterBeep.beep();
                    }
                  },
                  child: const Center(
                      child: Text(
                    'Dismiss',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )),
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingActionButton(
                  heroTag: "Create",
                  elevation: 25,
                  onPressed: () async {
                    if ((qrCodeResult != "Ready To Scan...") && isNotfound) {
                      await showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  topLeft: Radius.circular(25),
                                ),
                                color: Colors.white70,
                              ),
                              height:
                                  MediaQuery.of(context).size.height * 2 / 3,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tender Name: ',
                                    style: TextStyle(
                                      color: Colors.green[800],
                                      fontSize: 22.0,
                                    ),
                                  ),
                                  const SizedBox(width: 25, height: 10),
                                  TextFormField(
                                    controller: newTenderTextEditingController,
                                    keyboardType: TextInputType.text,
                                    decoration: textInputDecoration.copyWith(
                                        suffixIcon: IconButton(
                                            icon: const Icon(Icons.clear),
                                            onPressed: () {
                                              setState(() {
                                                newTenderTextEditingController
                                                    .clear();
                                              });
                                            }),
                                        fillColor: Colors.blue[100],
                                        hintStyle:
                                            const TextStyle(color: Colors.red),
                                        hintText: 'Enter Tender Name'),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        //Scan Once
                                        onPressed: () {
                                          newTenderTextEditingController
                                                  .text.isNotEmpty
                                              ? enteredTenderName =
                                                  newTenderTextEditingController
                                                      .text
                                              : enteredTenderName = '';
                                          newTenderTextEditingController
                                              .clear();
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });

                      if ((enteredTenderName != null) &&
                          (enteredTenderName != '')) {
                        await DatabaseService(uid: cUserUid, data: qrCodeResult)
                            .addNewTenderData(
                                qrCodeResult,
                                enteredTenderName!,
                                cUserSection!,
                                cUserSection!,
                                cUserName!,
                                tenderDirection!,
                                cUserName!,
                                dateFormat.format(DateTime.now()),
                                'Created',
                                cUserName!);

                        await DatabaseService(uid: cUserUid, data: qrCodeResult)
                            .updateLogFile(
                                qrCodeResult,
                                enteredTenderName!,
                                cUserSection!,
                                cUserSection!,
                                cUserName!,
                                tenderDirection!,
                                cUserName!,
                                dateFormat.format(DateTime.now()),
                                'Created',
                                cUserName!);
                        enteredTenderName = '';
                        FlutterBeep.beep();
                      } else {
                        await toast('Tender is not added');
                      }

                      setState(() {
                        qrCodeResult = "Ready To Scan...";
                        getNewScan = true;
                        isNotfound = false;
                        //controller.resumeCamera();
                      });
                    }
                  },
                  child: const Center(
                      child: Text(
                    'Create',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )),
                ),
              ],
            )
          : null,
      bottomNavigationBar: (version == runningVersion)
          ? Container(
              color: Colors.blue[100],
              child: !scan
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.qr_code_scanner,
                              size: 50,
                              color: Colors.green[400],
                            ),
                            label: Text(
                              'Receive',
                              style: TextStyle(color: Colors.green[400]),
                            ),
                            onPressed: () {
                              camController = MobileScannerController();
                              setState(() {
                                tenderDirection = 'inward';
                                scan = !scan;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton.icon(
                            icon: Icon(
                              Icons.qr_code_scanner,
                              size: 50,
                              color: Colors.red[400],
                            ),
                            label: Text(
                              'Send',
                              style: TextStyle(color: Colors.red[400]),
                            ),
                            onPressed: () {
                              camController = MobileScannerController();
                              setState(() {
                                qrCodeResult = 'Ready To Scan...';
                                tenderDirection = 'outward';
                                scan = !scan;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton.icon(
                        icon: Icon(
                          Icons.power_settings_new_outlined,
                          size: 50,
                          color: Colors.red[400],
                        ),
                        label: Text(
                          'Close The Scanner',
                          style: TextStyle(color: Colors.red[400]),
                        ),
                        onPressed: () {
                          setState(() {
                            scan = !scan;
                          });
                        },
                      ),
                    ),
            )
          : null,
    );
  }

  Widget _buildQrView(BuildContext context, double scanAreaWidth) {
    return Stack(
      children: [
        MobileScanner(
          allowDuplicates: true,
          fit: BoxFit.fill,
          controller: camController,
          onDetect: (barcode, args) async {
            if (getNewScan) {
              setState(() {
                qrCodeResult = barcode.rawValue ?? '---';
                getNewScan = false;
              });

              var result = barcode;
              //await camController.stop();
              Tender? t;
              for (var i = 0; i < cTendersList!.length; i++) {
                //to check tender is available or not.
                if (cTendersList![i]!.tenderNumber == result.rawValue) {
                  t = cTendersList![i]!;
                }
              }
              if (t != null) {
                //if tender is available.
                await DatabaseService(uid: cUserUid, data: result.rawValue)
                    .updateTenderData(
                        result.rawValue,
                        t.tenderName,
                        cUserSection,
                        t.tenderSection,
                        t.tenderOwnerName,
                        tenderDirection,
                        cUserName,
                        dateFormat.format(DateTime.now()),
                        'Processing',
                        cUserName);

                await DatabaseService(uid: cUserUid, data: result.rawValue)
                    .updateLogFile(
                        result.rawValue,
                        t.tenderName,
                        cUserSection,
                        t.tenderSection,
                        t.tenderOwnerName,
                        tenderDirection,
                        cUserName,
                        dateFormat.format(DateTime.now()),
                        'Processing',
                        cUserName);

                await FlutterBeep.beep();
                Future.delayed(const Duration(milliseconds: 800));

                //controller.resumeCamera();
                //await camController.start();
                setState(() {
                  qrCodeResult = 'Ready To Scan...';
                  getNewScan = true;
                  isNotfound = false;
                });
              } else {
                //if tender is not found.
                //FlutterRingtonePlayer.playRingtone();
                await FlutterBeep.playSysSound(44);
                Future.delayed(const Duration(milliseconds: 800));
                setState(() {
                  isNotfound = true;
                  getNewScan = false;
                });

                //controller.resumeCamera();
              }
            }
          },
        ),
        QRScannerOverlay(
          overlayColor: bgColor,
          scanAreaWidth: scanAreaWidth,
          scanAreaHeight: scanAreaWidth,
          borderColor: Colors.blue,
        )
      ],
    );
  }
}
