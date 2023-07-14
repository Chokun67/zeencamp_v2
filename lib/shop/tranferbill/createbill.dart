import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeencamp_v2/application/tranferService/tranferservice.dart';
import 'package:zeencamp_v2/background.dart/appstyle.dart';
import 'package:zeencamp_v2/shop/tranferbill/qrbill.dart';
import '../../../background.dart/background.dart';
import '../../application/accountService/accountservice.dart';
import '../../application/shopService/shopservice.dart';
import '../../background.dart/securestorage.dart';
import '../../domain/dmstore/detailshopdm.dart';

class CreateBill extends StatefulWidget {
  const CreateBill({Key? key, required this.isReceive}) : super(key: key);
  final bool isReceive;

  @override
  State<CreateBill> createState() => _CreateBillState();
}

class _CreateBillState extends State<CreateBill> {
  final _ctrlSearch = TextEditingController();
  final String ip = AccountService().ipAddress;
  List<Store> storemenu = [];
  List<Store> storemenu2 = [];
  List<Store> sendmenu = [];
  List<int> amountmenu = [];
  List<bool> isCheckedList = [];
  List<TextEditingController> textControllers = [];
  Map<String, int> qrMap = {};

  bool hasError = false;
  var token = "";
  var idAccount = "";

  @override
  void initState() {
    super.initState();
    // token = context.read<AppData>().token;
    getData().then((_) {
      fetchData().then((_) {
        textControllers = List.generate(
          storemenu.length,
          (index) => TextEditingController(),
        );
        isCheckedList = List.generate(storemenu.length, (index) => false);
      });
    });
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
    idAccount = await SecureStorage().read("idAccount") as String;
  }

  Future<void> fetchData() async {
    List<Store> fetchedStores =
        await StoresService().fetchStoreData2(token, idAccount);
    setState(() {
      storemenu = fetchedStores;
    });
  }

  void filterData(String query) {
    setState(() {
      storemenu2 = storemenu
          .where((store) =>
              store.nameMenu.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    // คืนทรัพยากรของ Controllers เมื่อไม่ใช้งาน
    for (final controller in textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Stack(children: [
        Mystlye().buildBackground(
            widthsize,
            heightsize - MediaQuery.of(context).padding.vertical,
            context,
            widget.isReceive ? "สร้างบิลให้พอยท์" : "สร้างบิลรับพอยท์",
            true,
            0.25),
        Positioned(
            top: heightsize * 0.15,
            child: SizedBox(
                width: widthsize,
                child: Center(child: fieldSearchType(widthsize, heightsize)))),
        listMenu(widthsize, heightsize),
        Positioned(
            bottom: 0,
            child: Container(
              width: widthsize,
              height: heightsize * 0.05,
              color: Colors.amberAccent,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textControllers.isNotEmpty
                        ? Text(textControllers[0].text)
                        : const Text(''),
                    ElevatedButton(
                        onPressed: () {
                          for (int i = 0; i < isCheckedList.length; i++) {
                            if (isCheckedList[i]) {
                              String key = storemenu[i].id;
                              int value;
                              try {
                                value = int.parse(textControllers[i].text);
                                sendmenu.add(storemenu[i]);
                                amountmenu.add(value);
                                if (value < 1) {
                                  hasError = true;
                                  break;
                                }
                              } catch (e) {
                                hasError = true;
                                showAlertBox(
                                    context, "test", "กรุณากรอกตัวเลข");
                                break;
                              }
                              qrMap[key] = value;
                            }
                          }
                          if (!hasError) {
                            showAlertBox(context, "test", "$qrMap");

                            TranferService()
                                .buildqrcodeformenu(
                                    token, qrMap, widget.isReceive)
                                .then((value) => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => QrBill(
                                                hash: value!,
                                                amountmenu: amountmenu,
                                                menusend: sendmenu,
                                                isReceive: widget.isReceive)),
                                      ).then((value) =>
                                          {sendmenu = [], amountmenu = []})
                                    });

                            hasError = false;
                          } else {
                            hasError = false;
                          }
                        },
                        child: const Text("สร้าง QR"))
                  ]), // แก้ไขด้วยการตรวจสอบขนาดของ textControllers),
            ))
      ]))),
    );
  }

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
              hintText: "ค้นหา",hintStyle: mystyleText(heightsize, 0.02, kGray4A, false)),
        ),
      );

  Widget listMenu(widthsize, heightsize) {
    return Padding(
      padding: EdgeInsets.all(widthsize * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: heightsize * 0.15),
          Container(
            padding: EdgeInsets.only(top: heightsize * 0.1),
            height: heightsize * 0.75,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: widthsize * 0.02,
                      right: widthsize * 0.05,
                      bottom: heightsize * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("เลือกรายการ",
                          style: mystyleText(heightsize, 0.03, kGray4A, false)),
                      Text("จำนวน",
                          style: mystyleText(heightsize, 0.03, kGray4A, false))
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _ctrlSearch.text.isEmpty
                        ? storemenu.length
                        : storemenu2.length,
                    itemBuilder: (context, index) {
                      List<Store> displayList =
                          _ctrlSearch.text.isEmpty ? storemenu : storemenu2;
                      int originalIndex = storemenu.indexOf(displayList[index]);
                      return Padding(
                        padding: EdgeInsets.only(bottom: heightsize * 0.01),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isCheckedList[
                                  originalIndex], // สถานะเช็คบล็อก
                              onChanged: (bool? value) {
                                setState(() {
                                  isCheckedList[originalIndex] =
                                      value ?? false; // อัปเดตสถานะเช็คบล็อก
                                  textControllers[originalIndex].text = "";
                                });
                              },
                            ),
                            SizedBox(
                              width: widthsize * 0.2,
                              height: heightsize * 0.1,
                              child: Center(
                                child: Image.network(
                                  'http://$ip:17003/api/v1/util/image/${displayList[index].pictures}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: widthsize * 0.02),
                              width: widthsize * 0.25,
                              height: heightsize * 0.1,
                              color: isCheckedList[originalIndex]
                                  ? Colors.green
                                  : null, // สีของคอนเทนเนอร์
                              child: Center(
                                child: Text(
                                  displayList[index].nameMenu,
                                  style: TextStyle(
                                    fontSize: heightsize * 0.02,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (isCheckedList[originalIndex]) {
                                  int currentValue = int.tryParse(
                                          textControllers[originalIndex]
                                              .text) ??
                                      0;
                                  int decrementedValue = currentValue - 1;
                                  if (decrementedValue >= 0) {
                                    textControllers[originalIndex].text =
                                        decrementedValue.toString();
                                  }
                                }
                              },
                              icon: Icon(Icons.arrow_downward,
                                  size: heightsize * 0.03),
                            ),
                            SizedBox(
                              width: widthsize * 0.1,
                              height: heightsize * 0.03,
                              child: TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // จำกัดให้เป็นตัวเลขเท่านั้น
                                  ],
                                  readOnly: !isCheckedList[originalIndex],
                                  decoration: const InputDecoration(
                                    hintText: '',
                                  ),
                                  controller: textControllers[
                                      originalIndex] // ตรวจสอบขนาดของ textControllers
                                  ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (isCheckedList[originalIndex]) {
                                  int currentValue = int.tryParse(
                                          textControllers[originalIndex]
                                              .text) ??
                                      0;
                                  int incrementedValue = currentValue + 1;
                                  textControllers[originalIndex].text =
                                      incrementedValue.toString();
                                }
                              },
                              icon: Icon(Icons.arrow_upward,
                                  size: heightsize * 0.03),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
