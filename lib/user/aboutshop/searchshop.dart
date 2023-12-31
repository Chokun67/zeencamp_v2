import 'package:flutter/material.dart';
import 'package:zeencamp_v2/background.dart/appstyle.dart';
import 'package:zeencamp_v2/user/aboutshop/shopdetail.dart';
import '../../application/accountService/accountservice.dart';
import '../../application/shopService/shopservice.dart';
import '../../background.dart/background.dart';
import '../../background.dart/securestorage.dart';
import '../../domain/dmstore/allstore.dart';

class SearchShop extends StatefulWidget {
  const SearchShop(
      {Key? key, required this.category, required this.lat, required this.lon})
      : super(key: key);
  final int category;
  final double lat;
  final double lon;

  @override
  State<SearchShop> createState() => _SearchShopState();
}

class _SearchShopState extends State<SearchShop> {
  final String ip = AccountService().ipAddress;
  List<Allstore> stores = [];
  List<Allstore> filteredList = [];
  var token = "";
  @override
  initState() {
    super.initState();
    fetchData();
    // token = context.read<AppData>().token;
    // List<Allstore> stores = await getStores(token);
  }

  void fetchData() async {
    int category = widget.category;
    token = await SecureStorage().read("token") as String;
    // List<Allstore> fetchedStores = await StoresService().getStores(token);
    late List<Allstore> fetchedStores;
    if (category > 0) {
      fetchedStores = await StoresService().getmenucategory(token, category);
    } else {
      fetchedStores = await StoresService().getStores(token);
    }
    setState(() {
      stores = fetchedStores;
    });
  }

  void filterData(String query) {
    setState(() {
      filteredList = stores
          .where(
              (store) => store.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  final _ctrlSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kWhiteF32,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(children: [
          Mystlye().buildBackground(
              widthsize,
              heightsize - MediaQuery.of(context).padding.vertical,
              context,
              "ร้านค้า",
              true,
              0.26),
          Padding(
            padding: EdgeInsets.all(widthsize * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: heightsize * 0.25),
                allShop(widthsize, heightsize)
              ],
            ),
          ),
          Positioned(
              top: heightsize * 0.15,
              child: SizedBox(
                  width: widthsize,
                  child: Center(child: fieldSearchType(widthsize, heightsize))))
        ]),
      )),
    );
  }

  Widget allShop(widthsize, heightsize) => SingleChildScrollView(
        child: Column(children: [
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            physics: const ScrollPhysics(parent: null),
            shrinkWrap: true,
            itemCount: _ctrlSearch.text.isEmpty
                ? stores.length
                : filteredList.length, // จำนวนรายการข้อมูลใน GridView
            itemBuilder: (BuildContext context, int index) {
              List<Allstore> displayList =
                  _ctrlSearch.text.isEmpty ? stores : filteredList;
              stores.sort((a, b) {
                double distanceToA = calculateDistance(widget.lat, widget.lon,
                    extractLoca(a.location, 0), extractLoca(a.location, 1));
                double distanceToB = calculateDistance(widget.lat, widget.lon,
                    extractLoca(b.location, 0), extractLoca(b.location, 1));
                return distanceToA.compareTo(distanceToB);
              });
              Allstore store = stores[index];
              double distanceToStore = calculateDistance(
                  widget.lat,
                  widget.lon,
                  extractLoca(store.location, 0),
                  extractLoca(store.location, 1));
              return InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShopDetail(
                                idshop: displayList[index].id,
                                nameshop: displayList[index].name,
                                lat: widget.lat,
                                lon: widget.lon,
                              )))
                },
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      displayList[index].storePicture.isNotEmpty
                          ? Container(
                              height: heightsize * 0.14,
                              width: widthsize * 0.44,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                child: Image.network(
                                  'http://$ip:17003/api/v1/util/image/${displayList[index].storePicture}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: heightsize * 0.14,
                              width: widthsize * 0.44,
                              color: Colors.green),
                      Text(" ${displayList[index].name}",
                          style: mystyleText(heightsize, 0.02, kGray4A, false)),
                      Text(
                        " ${distanceToStore.toStringAsFixed(2)} ก.ม.",
                        style: mystyleText(heightsize, 0.02, kGray4A, false),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ]),
      );

  Widget fieldSearchType(widthsize, heightsize) => SizedBox(
        width: widthsize * 0.8,
        height: heightsize * 0.06,
        child: TextField(
          onChanged: (value) => filterData(value),
          controller: _ctrlSearch,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFFAD6800), width: 1),
                  borderRadius: BorderRadius.circular(10)),
              fillColor: const Color(0xFFFFFFFF),
              filled: true,
              prefixIcon: const Icon(Icons.search),
              hintText: "ค้นหา",
              hintStyle: mystyleText(heightsize, 0.02, kGray4A, false)),
        ),
      );
}
