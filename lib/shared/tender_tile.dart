import 'package:file_observer/models/tender.dart';
import 'package:file_observer/screens/log_page.dart';
import 'package:flutter/material.dart';
import 'package:file_observer/models/user.dart';
import 'package:file_observer/services/database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TenderTile extends StatelessWidget {
  final Tender? tender;

  const TenderTile({super.key, this.tender});

  @override
  Widget build(BuildContext context) {
    UserData cUser = Provider.of<UserData>(context);
    final dateFormat = DateFormat('dd/MM/yyyy hh:mm:ss a');

    return Padding(
      padding: const EdgeInsets.only(top: 1.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 10.0,
            backgroundColor: tender!.tenderDirection == 'inward'
                ? Colors.green[800]
                : Colors.red[800],

            //backgroundImage: AssetImage('assets/coffee_icon.png'),
          ),
          title: Text(
            tender!.tenderNumber!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              '${tender!.tenderName} at    ${tender!.tenderLocation}/ ${(tender!.lastActionBy) != null ? tender!.lastActionBy : '  --'}'),
          onTap: () async{
            Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LogPage(
                          tenderNumber: tender!.tenderNumber!,

                        ))); 


      
            // showModalBottomSheet(
            //     backgroundColor: Colors.transparent,
            //     context: context,
            //     builder: (context) {
            //       return Container(
            //         decoration: BoxDecoration(
            //           color: Colors.amber[100],
            //           borderRadius: const BorderRadius.only(
            //               topLeft: Radius.circular(25),
            //               topRight: Radius.circular(25)),
            //         ),
            //         height: 300,
            //         width: MediaQuery.of(context).size.width,
            //         padding: const EdgeInsets.symmetric(
            //             vertical: 15.0, horizontal: 20.0),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               'Tender Info: ',
            //               style: TextStyle(
            //                 color: Colors.green[800],
            //                 fontSize: 22.0,
            //               ),
            //             ),
            //             const SizedBox(width: 25, height: 10),
            //             Text(
            //               'Tender No.:   ${tender!.tenderNumber}',
            //               style: TextStyle(
            //                 color: Colors.blue[800],
            //                 fontSize: 18.0,
            //               ),
            //             ),
            //             const SizedBox(width: 25, height: 10),
            //             Text(
            //               'Location:   ${tender!.tenderLocation}',
            //               style: TextStyle(
            //                 color: Colors.blue[800],
            //                 fontSize: 18.0,
            //               ),
            //             ),
            //             const SizedBox(width: 25, height: 10),
            //             Text(
            //               'Direction:   ${tender!.tenderDirection}',
            //               style: TextStyle(
            //                 color: Colors.blue[800],
            //                 fontSize: 18.0,
            //               ),
            //             ),
            //             const SizedBox(width: 25, height: 10),
            //             Text(
            //               'Action Time:   ${tender!.currentTime}',
            //               style: TextStyle(
            //                 color: Colors.blue[800],
            //                 fontSize: 18.0,
            //               ),
            //             ),
            //             const SizedBox(width: 25, height: 10),
            //             Text(
            //               'Tender of:   ${tender!.tenderOwnerName}',
            //               style: TextStyle(
            //                 color: Colors.blue[800],
            //                 fontSize: 18.0,
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     });
          },
          onLongPress: () {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      ),
                      color: Colors.white70,
                    ),
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tender Info: ',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontSize: 22.0,
                          ),
                        ),
                        const SizedBox(width: 25, height: 10),
                        Text(
                          'Tender No.:   ${tender!.tenderNumber}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(width: 25, height: 10),
                        Text(
                          'Location:   ${tender!.tenderLocation}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(width: 25, height: 10),
                        Text(
                          'Direction:   ${tender!.tenderDirection}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(width: 25, height: 10),
                        Text(
                          'Action Time:   ${tender!.currentTime}',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 18.0,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //const SizedBox(height: 20),
                            SizedBox(
                              height: 35,
                              width: MediaQuery.of(context).size.width - 50,
                              child: ElevatedButton(
                                //Scan Once
                                onPressed: () async {
                                  await DatabaseService(
                                          uid: cUser.uid,
                                          data: tender!.tenderNumber)
                                      .updateLogFile(
                                          tender!.tenderNumber,
                                          tender!.tenderName,
                                          cUser.userSection,
                                          tender!.tenderSection,
                                          tender!.tenderOwnerName,
                                          'inward',
                                          cUser.userName,
                                          dateFormat.format(DateTime.now()),
                                          'Finished',
                                          cUser.userName);
                                  await DatabaseService(
                                          data: tender!.tenderNumber)
                                      .deleteTenderData(tender!.tenderNumber!);
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Finish",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
