import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../application/accountService/accountservice.dart';
import '../../application/tranferService/tranferservice.dart';
import '../../background.dart/appstyle.dart';
import '../../background.dart/background.dart';
import '../../background.dart/securestorage.dart';
import '../../domain/dmtranfer/historydm.dart';
import 'detailtran.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<DepositModel> history = [];
  var pointid = 0;
  var token = "";
  var idAccount = "";
  var idname = "";

    @override
  void initState() {
    super.initState();
    // token = context.read<AppData>().token;
    getData().then((_) {
       AccountService().apigetpoint(token).then((value) => setState(() {
            pointid = value.point;
            idAccount = value.id;
            idname = value.name;
          }));
      fetchData();
    });
  }

  Future<void> getData() async {
    token = await SecureStorage().read("token") as String;
    idAccount = await SecureStorage().read("idAccount") as String;
  }

  void fetchData() async {
    // token = context.read<AppData>().token;
    List<DepositModel> fetchedStores = await TranferService().getTranfer(token);
    setState(() {
      history = fetchedStores;
    });
  }

  @override
  Widget build(BuildContext context) {
    final heightsize = MediaQuery.of(context).size.height;
    final widthsize = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Stack(children: [
                Mystlye().buildBackground(
            widthsize, heightsize, context, "ประวัติ", true, 0.22),
                Padding(
          padding: EdgeInsets.all(widthsize * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heightsize * 0.15),
              Center(child: showPoint(widthsize, heightsize)),
              SizedBox(height: heightsize*0.05),
              SizedBox(
                    width: widthsize,
                    height: heightsize - heightsize * 0.5,
                    child: historyPointTranfer(widthsize, heightsize, context))
            ],
          ),
                ),
              ])),
    );
  }

  Widget showPoint(widthsize, heightsize) => Container(
        padding: EdgeInsets.all(widthsize * 0.05),
        width: widthsize * 0.8,
        height: heightsize * 0.127,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: kWhite,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(idname,
                    style: mystyleText(heightsize, 0.022, kBlack, true)),
                Text("User ID $idAccount",
                    style: mystyleText(heightsize, 0.02, kGray4A, false))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(NumberFormat("#,##0").format(pointid),
                    style: mystyleText(heightsize, 0.04, kGray4A, true)),
                Text("พอยท์",
                    style: mystyleText(heightsize, 0.02, kGray4A, true)),
              ],
            )
          ],
        ),
      );

  Widget historyPointTranfer(widthsize, heightsize, context) =>
      SingleChildScrollView(
        child: Column(children: [
          Column(
            children: [
              buildList(widthsize, heightsize, context),
            ],
          )
        ]),
      );

  Widget buildList(widthsize, heightsize, context) => Column(
        children: [
          ListView.builder(
            itemCount: history.length,
            padding: EdgeInsets.all(widthsize * 0.04),
            physics: const ScrollPhysics(parent: null),
            shrinkWrap: true,
            itemBuilder: (BuildContext buildList, int index) {
              history.sort((a, b) => b.date.compareTo(a.date));
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailTranfer(
                              idAccount: idAccount,
                              state: history[index].state,
                              payee: history[index].opposite,
                              date: "${history[index].date}",
                              point: history[index].point)));
                },
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Color(0xFFFFFFFF),
                  ),
                  margin: EdgeInsets.only(bottom: widthsize * 0.025),
                  padding: EdgeInsets.only(
                      bottom: widthsize * 0.02,
                      top: widthsize * 0.02,
                      left: widthsize * 0.07,
                      right: widthsize * 0.06),
                  height: heightsize * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${history[index].date}",
                              style: TextStyle(fontSize: heightsize * 0.02)),
                          Text(
                            isDeposit(history, index)
                                ? "ได้รับ Point"
                                : "โอน Point",
                            style: TextStyle(
                                fontSize: heightsize * 0.03,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Text(
                        isDeposit(history, index)
                            ? "+${NumberFormat("#,##0").format(history[index].point)}"
                            : NumberFormat("#,##0")
                                .format(history[index].point),
                        style: TextStyle(
                            color: isDeposit(history, index)
                                ? const Color(0xFF2CC14D)
                                : const Color(0xFFEB3F3F),
                            fontSize: heightsize * 0.04,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );

  bool isDeposit(List history, int index) {
    return history[index].state == "deposit";
  }
}