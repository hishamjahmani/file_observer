import 'package:flutter/material.dart';
import 'package:file_observer/models/tender.dart';
import 'package:provider/provider.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key, required this.tenderNumber});
  final String tenderNumber;

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  String? certainTender;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String filter = widget.tenderNumber;
    List<TenderLog> tenderLog = Provider.of<List<TenderLog>>(context);

    tenderLog = tenderLog
        .where((element) => element.tenderNumber!.contains(filter))
        .toList();

    return Scaffold(
        appBar: AppBar(
          title: Text('Actions on Tender $filter'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text('${tenderLog[0].tenderName}', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 25, fontWeight: FontWeight.bold),),
              const SizedBox(height: 10.0),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                  child: DataTable(
                    dataRowMinHeight: 10,
                    dataRowMaxHeight: 90,
                    columnSpacing: 15,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Employee',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Location',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Time',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                        tenderLog.length,
                        (index) => DataRow(cells: <DataCell>[
                              DataCell(SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 4.5,
                                  //height: 40.0,
                                  child: Text(
                                    '${tenderLog[index].lastActionBy}',
                                    maxLines: 4,
                                    //overflow: TextOverflow.ellipsis,
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.justify,
                                  ))),
                              DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width / 4.5,
                                child: Text(
                                  '${tenderLog[index].tenderName}',
                                ),
                              )),
                              DataCell(
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 4.5,
                                  child: Text(
                                    '${tenderLog[index].currentTime}',
                                    style: TextStyle(
                                        color:
                                            tenderLog[index].tenderDirection ==
                                                    'outward'
                                                ? Colors.red[800]
                                                : Colors.green[800]),
                                  ),
                                ),
                              ),
                            ])),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
