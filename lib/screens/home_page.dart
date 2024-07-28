import 'package:flutter/material.dart';

import 'package:file_observer/services/auth.dart';
import 'package:file_observer/services/database.dart';
import 'package:file_observer/shared/constants.dart';
import 'package:file_observer/shared/section_grid_view.dart';
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

  String? certainTender, tenderDirection;

  final AuthService _authUser = AuthService();
  final dateFormat = DateFormat('dd/MM/yyyy hh:mm:ss a');

  bool scan = false;
  Color bgColor = Colors.white;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? cUserUid, cUserName, cUserSection;
  List<Tender?>? cTendersList;

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

  final TextEditingController searchTextEditingController =
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
                  SizedBox(
                    height: scan ? screenHeight / 2 : 0,
                    width: scan ? screenWidth : 0,
                    child: scan
                        ? _buildQrView(context, screenWidth/1.7)
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
                      controller: searchTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: textInputDecoration.copyWith(
                          suffixIcon: certainTender != ''
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      searchTextEditingController.clear();
                                      certainTender = '';
                                    });
                                  })
                              : null,
                          fillColor: Colors.blue[100],
                          hintStyle: const TextStyle(color: Colors.red),
                          hintText: 'Search a tender'),
                      onChanged: (val) {
                        setState(() => certainTender = val);
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
          ? FloatingActionButton(
              elevation: 25,
              onPressed: () async {
                if (qrCodeResult != "Ready To Scan...") {
                  await DatabaseService(uid: cUserUid, data: qrCodeResult)
                      .addNewTenderData(
                    qrCodeResult,
                    'refrigerator',
                    cUserSection!,
                    cUserSection!,
                    cUserName!,
                    tenderDirection!,
                    cUserName!,
                    dateFormat.format(DateTime.now()),
                    'Created',
                  );

                  await DatabaseService(uid: cUserUid, data: qrCodeResult)
                      .updateLogFile(
                    qrCodeResult,
                    'refrigerator',
                    cUserSection!,
                    cUserSection!,
                    cUserName!,
                    tenderDirection!,
                    cUserName!,
                    dateFormat.format(DateTime.now()),
                    'Created',
                  );
                  setState(() {
                    qrCodeResult = "Ready To Scan...";
                    //controller.resumeCamera();
                  });
                  //FlutterBeep.beep();
                }
              },
              child: const Center(
                  child: Text(
                'create',
                style: TextStyle(
                  fontSize: 12,
                ),
              )),
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
                              setState(() {
                                tenderDirection = 'inward';
                                //controller?.resumeCamera();
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
                              setState(() {
                                qrCodeResult = 'Ready To Scan...';
                                tenderDirection = 'outward';
                                //controller?.resumeCamera();
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
                            //controller?.stopCamera();
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
          onDetect: (barcode, args) {
            setState(() {
              qrCodeResult = barcode.rawValue ?? '---';
            });
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
