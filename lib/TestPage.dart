import 'package:flutter/material.dart';
import 'package:myvirtualwallet/DepositPage.dart';
import 'package:myvirtualwallet/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'HomePage.dart';
import 'customWidgets.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final panelController = PanelController();
  final double tabBarHeight = 80;
  int _selectedIndex = 1;
  static List<Widget> _pages = <Widget>[
    HomePage(),
    DepositPage(),
    Icon(
      Icons.ac_unit_rounded,
      size: 150,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(

    body:
        //IndexedStack to preserve the state of the pages.
    IndexedStack(
      index: _selectedIndex,
      children: _pages,
    ),
    /*Center(
      child: _pages.elementAt(_selectedIndex),
    ),*/
    /*SlidingUpPanel(
      controller: panelController,
      maxHeight: MediaQuery.of(context).size.height - tabBarHeight,
      panelBuilder: (scrollController) => buildSlidingPanel(
        scrollController: scrollController,
        panelController: panelController,
      ),
      body: Text("whatsdfdsfsdfsdfdsfsfsdfdsfsdfsdfdsfdsfsdddddddddddddssssssssssssssssssssssssssssssssssssssssssss"),
    ),*/
    bottomNavigationBar: BottomNavigationBar(
      fixedColor: GlobalConstants.APPPRIMARYCOLOUR,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Deposit',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    ),
  );

  Widget buildSlidingPanel({
    required PanelController panelController,
    required ScrollController scrollController,
  }) =>
      DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(tabBarHeight - 8),
            child: GestureDetector(
              onTap: () => panelController.open(),
              child: AppBar(
                title: buildDragIcon(), // Icon(Icons.drag_handle),
                centerTitle: true,
                bottom: TabBar(
                  tabs: [
                    Tab(child: Text('tab1')),
                    Tab(child: Text('tab2')),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              TabWidget(scrollController: scrollController),
              TabWidget(scrollController: scrollController),
            ],
          ),
        ),
      );

  Widget buildTabBar({
    required VoidCallback onClicked,
  }) =>
      PreferredSize(
        preferredSize: Size.fromHeight(tabBarHeight - 8),
        child: GestureDetector(
          onTap: onClicked,
          child: AppBar(
            title: buildDragIcon(), // Icon(Icons.drag_handle),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(child: Text('tab1')),
                Tab(child: Text('tab2')),
              ],
            ),
          ),
        ),
      );

  Widget buildDragIcon() => Container(
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.3),
      borderRadius: BorderRadius.circular(8),
    ),
    width: 40,
    height: 8,
  );
}


class TabWidget extends StatelessWidget {
  const TabWidget({
    Key? key,
    required this.scrollController,
  }) : super(key: key);
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(16),
    controller: scrollController,
    children: [
      Text(
        'aha',
        textAlign: TextAlign.center,
      ),
      Container(
        height: 300,
        width: 300,
      ),
      Text(
          "something"),
    ],
  );
}