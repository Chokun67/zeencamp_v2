import 'package:flutter/material.dart';
import 'package:zeencamp_v2/background.dart/appstyle.dart';
import 'package:zeencamp_v2/user/aboutshop/shopdetail.dart';
import '../../application/accountService/accountservice.dart';
import '../../application/shopService/shopservice.dart';
import '../../background.dart/background.dart';
import '../../background.dart/securestorage.dart';
import '../../domain/dmstore/allstore.dart';

class SearchShop extends StatefulWidget {
  const SearchShop({
    Key? key,
    required this.category,
  }) : super(key: key);
  final int category;

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
      body: SafeArea(
          child: Stack(children: [
        Mystlye().buildBackground(
            widthsize, heightsize, context, "ร้านนค้า", true, 0.25),
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
      ])),
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
              return InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShopDetail(
                                idshop: displayList[index].id,
                                nameshop: displayList[index].name,
                              )))
                },
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      displayList[index].storePicture.isNotEmpty
                          ? Container(
                            height: heightsize * 0.14,
                              width: widthsize * 0.44,
                            child: Image.network(
                                'http://$ip:17003/api/v1/util/image/${displayList[index].storePicture}',
                                fit: BoxFit.cover,
                              ),
                          )
                          : Container(
                              height: heightsize * 0.14,
                              width: widthsize * 0.44,
                              color: Colors.green), 
                      Text("ร้าน ${displayList[index].name}",
                          style: mystyleText(heightsize, 0.02, kGray4A, false)),
                      Text(
                        "id ${displayList[index].id}",
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
              hintText: "search"),
        ),
      );
}
