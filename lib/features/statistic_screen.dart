import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';

class StatisticScreen extends StatefulWidget {

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController scrollbarController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Menu_Controller menuController = Get.find<Menu_Controller>();
  final String title = Get.arguments ?? "";
  int _selectedTabIndex = 0;

//  List<String> dropData = ["www.climbersoul.cl", "site1", "site2"];
  @override
  void initState() {
    _tabController = TabController(length: 9, vsync: this);
    super.initState();

    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    scrollbarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  PageBuilder(
        sectionWidgets: [
         Text("This page is currently at developments".tr),
        ]);
  }
}