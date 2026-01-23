import 'package:file_observer/screens/log_page.dart';
import 'package:flutter/material.dart';
import 'package:file_observer/models/tender.dart';
import 'package:file_observer/screens/tenders_details.dart';
import 'package:provider/provider.dart';
import "dart:collection";

class SectionsGridView extends StatelessWidget {
  const SectionsGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Tender> tenders = Provider.of<List<Tender>>(context);

    List<String?> sections = [];

    if (tenders != null) {
      for (var i = 0; i < tenders.length; i++) {
        sections.add(tenders[i].tenderLocation);
      }
      sections = LinkedHashSet<String>.from(sections)
          .toList(); //find sections for the entered sections.
    }
    // ignore: unnecessary_null_comparison
    return sections != null
        ? GridView.builder(
            primary: false,
            padding: const EdgeInsets.all(17),
            scrollDirection: Axis.horizontal,
            itemCount: sections.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              // (MediaQuery.of(context).size.width-5)/60,
              //crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SectionTendersDetails(
                          sectionName: sections[index]!,
                          tenders: tenders,
                        )));
              },
              onLongPress: () async {
                final logFilter = sections[index]!.substring(0, 3).toLowerCase();
                print(logFilter);
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LogPage(
                          tenderNumber: logFilter,
                        )));
              },
              child: Container(
                //margin: EdgeInsets.all(5),
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/${sections[index]}.jpg'),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset.fromDirection(3.14 / 4, 10),
                      blurRadius: 10,
                      spreadRadius: 0,
                      color: Colors.green,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      height: 20,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(7),
                        ),
                        color: tenders
                                .where((val) =>
                                    val.tenderDirection!.contains('outward'))
                                .where((val) => val.tenderLocation!
                                    .contains(sections[index]!))
                                .isNotEmpty
                            ? Colors.red[300]
                            : Colors.green[300],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              '${tenders.where((val) => val.tenderLocation!.contains(sections[index]!)).where((element) => element.tenderDirection!.contains('outward')).length.toString()} / ${tenders.where((val) => val.tenderLocation!.contains(sections[index]!)).length.toString()}'),
                          const SizedBox(
                            width: 5,
                          ),
                          //Text(sections[index].substring(0, 3)),
                        ],
                      ),
                    ),
                  ],
                ),
                //onTap: ,
              ),
            ),
          )
        : const Image(image: AssetImage('assets/logo.jpg'));
  }
}
