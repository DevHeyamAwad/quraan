import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mydrawer.dart';
import 'surah_builder.dart';
import 'constant.dart';
import 'package:ytquran/arabic_sura_number.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Go to bookmark',
        child: const Icon(Icons.bookmark),
        backgroundColor: Colors.green,
        onPressed: () async {
          fabIsClicked = true;
          if (await readBookmark() == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SurahBuilder(
                          arabic: quran[0],
                          sura: bookmarkedSura - 1,
                          suraName: arabicName[bookmarkedSura - 1]['name'],
                          ayah: bookmarkedAyah,
                        )));
          }
        },
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                    context: context, delegate: DataSearch(list: quran[0]));
                print('lllllllllllllll');
              },
              icon: Icon(Icons.search))
        ],
        centerTitle: true,
        title: const Text(
          //"القرآن",
          "Quran",
          style: TextStyle(
              //fontFamily: 'quran',
              fontSize: 35,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 2.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ]),
        ),
        backgroundColor: const Color.fromARGB(255, 56, 115, 59),
      ),
      body: FutureBuilder(
        future: readJson(),
        builder: (
          BuildContext context,
          AsyncSnapshot snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return indexCreator(snapshot.data, context);
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }

  Container indexCreator(quran, context) {
    return Container(
      color: const Color.fromARGB(255, 221, 250, 236),
      child: ListView(
        children: [
          for (int i = 0; i < 114; i++)
            Container(
              color: i % 2 == 0
                  ? const Color.fromARGB(255, 253, 247, 230)
                  : const Color.fromARGB(255, 253, 251, 240),
              child: TextButton(
                child: Row(
                  children: [
                    ArabicSuraNumber(i: i),
                    const SizedBox(
                      width: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Text(
                      arabicName[i]['name'],
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.black87,
                          fontFamily: 'quran',
                          shadows: [
                            Shadow(
                              offset: Offset(.5, .5),
                              blurRadius: 1.0,
                              color: Color.fromARGB(255, 130, 130, 130),
                            )
                          ]),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                onPressed: () {
                  fabIsClicked = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SurahBuilder(
                              arabic: quran[0],
                              sura: i,
                              suraName: arabicName[i]['name'],
                              ayah: 0,
                            )),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// class DataSearch extends SearchDelegate {
//   List<dynamic>? list;
//   var filterNum;
//   var filterSuraName;
//   List filterData = [];
//   DataSearch({this.list});
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//           onPressed: () {
//             query = '';
//           },
//           icon: Icon(Icons.clear))
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         close(context, null);
//       },
//       icon: Icon(Icons.arrow_back),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     List filteredData = [];
//     if (query.isNotEmpty) {
//       filteredData = list!
//           .where((element) =>
//               element['aya_text_emlaey'].toString().contains(query.trim()))
//           .toList();

//       return ListView.separated(
//         itemBuilder: (context, index) {
//           return ListTile(
//             onTap: () {
//               Navigator.pushReplacementNamed(context, '/', arguments: [
//                 filteredData[index]['page'],
//                 filteredData[index]['id']
//               ]);
//             },
//             title: Text(
//               filteredData[index]['aya_text'],
//               textDirection: TextDirection.rtl,
//               style: TextStyle(fontFamily: 'Hafs'),
//               textAlign: TextAlign.right,
//             ),
//             subtitle: Text(
//               filteredData[index]['sura_name_ar'],
//               textDirection: TextDirection.rtl,
//               textAlign: TextAlign.right,
//             ),
//             leading: Column(
//               children: [
//                 Text('الصفحة'),
//                 Text(
//                   filteredData[index]['page'].toString(),
//                   textDirection: TextDirection.rtl,
//                   textAlign: TextAlign.right,
//                 )
//               ],
//             ),
//           );
//         },
//         itemCount: filteredData.length,
//         separatorBuilder: (BuildContext context, int index) {
//           return Divider();
//         },
//       );
//     } else {
//       return Column(
//         children: [],
//       );
//     }
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     if (query.isNotEmpty) {
//       filterData = list!
//           .where((element) => element['aya_text_emlaey'].contains(query.trim()))
//           .toList();
//       return ListView.separated(
//         itemBuilder: (context, index) {
//           filterNum = filterData[index]['page'];
//           filterSuraName = filterData[index];
//           return ListTile(
//             onTap: () {
//               Navigator.pushReplacementNamed(context, '/', arguments: [
//                 filterData[index]['page'],
//                 filterData[index]['id']
//               ]);
//             },
//             title: Text(
//               filterData[index]['aya_text_emlaey'],
//               textDirection: TextDirection.rtl,
//               style: TextStyle(fontFamily: 'Hafs'),
//               textAlign: TextAlign.right,
//             ),
//             subtitle: Text(
//               filterData[index]['sura_name_ar'],
//               textDirection: TextDirection.rtl,
//               textAlign: TextAlign.right,
//             ),
//             leading: Column(
//               children: [
//                 Text('الصفحة'),
//                 Text(
//                   filterData[index]['page'].toString(),
//                   textDirection: TextDirection.rtl,
//                   textAlign: TextAlign.right,
//                 )
//               ],
//             ),
//           );
//         },
//         itemCount: filterData.length,
//         separatorBuilder: (BuildContext context, int index) {
//           return Divider();
//         },
//       );
//     } else {
//       return Column(
//         children: [],
//       );
//     }
//   }
// }

class DataSearch extends SearchDelegate {
  List<dynamic>? list;
  var filterNum;
  var filterSuraName;
  List filterData = [];
  DataSearch({this.list});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List filteredData = [];
    if (query.isNotEmpty) {
      filteredData = list!
          .where((element) =>
              element['aya_text_emlaey'].toString().contains(query.trim()))
          .toList();

      return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/', arguments: [
                filteredData[index]['page'],
                filteredData[index]['id']
              ]);
            },
            title: Text(
              filteredData[index]['aya_text'],
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: 'Hafs'),
              textAlign: TextAlign.right,
            ),
            subtitle: Text(
              filteredData[index]['sura_name_ar'],
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            leading: Column(
              children: [
                Text('الصفحة'),
                Text(
                  filteredData[index]['page'].toString(),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                )
              ],
            ),
          );
        },
        itemCount: filteredData.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      );
    } else {
      return Column(
        children: [],
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      filterData = list!
          .where((element) => element['aya_text_emlaey'].contains(query.trim()))
          .toList();
      return ListView.separated(
        itemBuilder: (context, index) {
          filterNum = filterData[index]['page'];
          filterSuraName = filterData[index];
          return ListTile(
            onTap: () {
              onTap:
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahBuilder(
                      sura: filterData[index]['page'],
                      ayah: filterData[index]['id'],
                    ),
                  ),
                );
              };
            },
            title: Text(
              filterData[index]['aya_text_emlaey'],
              textDirection: TextDirection.rtl,
              style: TextStyle(fontFamily: 'Hafs'),
              textAlign: TextAlign.right,
            ),
            subtitle: Text(
              filterData[index]['sura_name_ar'],
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            leading: Column(
              children: [
                Text('الصفحة'),
                Text(
                  filterData[index]['page'].toString(),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                )
              ],
            ),
          );
        },
        itemCount: filterData.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      );
    } else {
      return Column(
        children: [],
      );
    }
  }
}
