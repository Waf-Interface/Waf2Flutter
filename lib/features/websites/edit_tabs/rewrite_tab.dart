// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:msf/core/component/widgets/custom_iconbutton.dart';
// import 'package:msf/core/component/widgets/dashboard_textfield.dart';
// import 'package:msf/core/utills/_colorconfig.dart';
//
// class RewriteTab extends StatefulWidget {
//   const RewriteTab({super.key});
//
//   @override
//   State<RewriteTab> createState() => _RewriteTabState();
// }
//
// class _RewriteTabState extends State<RewriteTab> {
//   final List<Map<String, String>> headers = [];
//   final List<String> paths = [];
//   final TextEditingController keyController = TextEditingController();
//   final TextEditingController valueController = TextEditingController();
//   final TextEditingController pathController = TextEditingController();
//
//   @override
//   void dispose() {
//     keyController.dispose();
//     valueController.dispose();
//     pathController.dispose();
//
//     super.dispose();
//   }
//
//   void addHeader() {
//     if (keyController.text.isNotEmpty && valueController.text.isNotEmpty) {
//       setState(() {
//         headers.add({
//           "key": keyController.text,
//           "value": valueController.text,
//         });
//       });
//       keyController.clear();
//       valueController.clear();
//     }
//   }
//
//   void addPath() {
//     if (pathController.text.isNotEmpty) {
//       setState(() {
//         paths.add(pathController.text);
//       });
//       pathController.clear();
//     }
//   }
//
//   void removeHeader(List selectedList, int index) {
//     setState(() {
//       selectedList.removeAt(index);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Insert Headers & Deny Paths",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         ExpansionPanelList.radio(
//           initialOpenPanelValue: false,
//           children: [
//             ExpansionPanelRadio(
//               value: 0,
//               backgroundColor: Get.theme.scaffoldBackgroundColor,
//               headerBuilder: (context, isExpanded) {
//                 return const ListTile(
//                   title: Text(
//                     "Insert Headers",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 );
//               },
//               body: Padding(
//                 padding: const EdgeInsets.only(
//                   left: 20.0,
//                   bottom: 15,
//                   top: 10,
//                   right: 20,
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: DashboardTextfield(
//                             textEditingController: keyController,
//                             hintText: "Header Key",
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: DashboardTextfield(
//                             textEditingController: valueController,
//                             hintText: "Header Value",
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: headers.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 5.0),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: DashboardTextfield(
//                                   textEditingController: TextEditingController(
//                                     text: headers[index]["key"],
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: DashboardTextfield(
//                                   textEditingController: TextEditingController(
//                                     text: headers[index]["value"],
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               IconButton(
//                                 onPressed: () => removeHeader(headers, index),
//                                 icon:
//                                     const Icon(Icons.close, color: Colors.red),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           CustomIconbuttonWidget(
//                             backColor: Colors.green[800]!,
//                             onPressed: addHeader,
//                             icon: Icons.add,
//                             title: "Add Header",
//                           ),
//                           CustomIconbuttonWidget(
//                             backColor: primaryColor,
//                             onPressed: addHeader,
//                             icon: Icons.add,
//                             title: "Save",
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             ExpansionPanelRadio(
//               value: 1,
//               backgroundColor: Get.theme.scaffoldBackgroundColor,
//               headerBuilder: (context, isExpanded) {
//                 return const ListTile(
//                   title: Text(
//                     "Denied Paths",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 );
//               },
//               body: Padding(
//                 padding: const EdgeInsets.only(
//                   left: 20.0,
//                   bottom: 15,
//                   top: 10,
//                   right: 20,
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: DashboardTextfield(
//                             textEditingController: pathController,
//                             hintText: "/some/resources/admin/",
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: paths.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 5.0),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: DashboardTextfield(
//                                   textEditingController: TextEditingController(
//                                     text: paths[index],
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               IconButton(
//                                 onPressed: () => removeHeader(paths, index),
//                                 icon:
//                                     const Icon(Icons.close, color: Colors.red),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(right: 10),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           CustomIconbuttonWidget(
//                             backColor: Colors.green[800]!,
//                             onPressed: addPath,
//                             icon: Icons.add,
//                             title: "Add Path",
//                           ),
//                           CustomIconbuttonWidget(
//                             backColor: primaryColor,
//                             onPressed: () {},
//                             icon: Icons.save,
//                             title: "Save",
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
