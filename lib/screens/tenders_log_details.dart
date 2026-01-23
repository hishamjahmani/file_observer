import 'package:flutter/material.dart';
import 'package:file_observer/models/tender.dart';
import 'package:file_observer/shared/constants.dart';

class SectionTendersLogDetails extends StatefulWidget {
  const SectionTendersLogDetails(
      {super.key, required this.sectionName, required this.tenders});
  final String sectionName;
  final List<TenderLog> tenders;

  @override
  State<SectionTendersLogDetails> createState() =>
      _SectionTendersLogDetailsState();
}

class _SectionTendersLogDetailsState extends State<SectionTendersLogDetails> {
  String? certainTender;

  @override
  void initState() {
    super.initState();
    certainTender = '';
  }

  final TextEditingController searchTextEditingControllerByNo =
      TextEditingController();
  final TextEditingController searchTextEditingControllerByName =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    String filter = widget.sectionName;
    List<TenderLog> tenders;

    if (widget.sectionName != 'all') {
      if (certainTender == '') {
        tenders = widget.tenders
            .where((element) => element.tenderSection!.contains(filter))
            .toList();
      } else {
        tenders = widget.tenders
            .where((element) => element.tenderSection!.contains(filter))
            .where((element) =>
                element.tenderNumber!.contains(certainTender!) ||
                element.tenderName!.contains(certainTender!))
            .toList();
      }
    } else {
      tenders = widget.tenders
          .where((element) =>
              element.tenderNumber!.contains(certainTender!) ||
              element.tenderName!.contains(certainTender!))
          .toList();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Tenders of $filter'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
           /*   Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    setState(() => certainTender = val);
                  },
                ),
              ),
              */
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
                      hintText: 'Search a tender by NAME/Number'),
                  onChanged: (val) {
                    setState(() {
                      certainTender = val;
                    });
                  },
                ),
              ),
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
                          'File No.\nAction',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Tender Name\nOwner',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Location\nLast Action By',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                        tenders.length,
                        (index) => DataRow(cells: <DataCell>[
                              DataCell(SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 4.5,
                                  //height: 40.0,
                                  child: Text(
                                    '${tenders[index].tenderNumber}\n${tenders[index].actionOnTender}',
                                    maxLines: 4,
                                    //overflow: TextOverflow.ellipsis,
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.justify,
                                  ))),
                              DataCell(SizedBox(
                                width: MediaQuery.of(context).size.width / 4.5,
                                child: Text(
                                  '${tenders[index].tenderName}\n${tenders[index].tenderOwnerName}',
                                ),
                              )),
                              DataCell(
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 4.5,
                                  child: Text(
                                    '${tenders[index].tenderLocation}\n(${tenders[index].lastActionBy})\n${tenders[index].currentTime}',
                                    style: TextStyle(
                                        color: tenders[index].tenderDirection ==
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
