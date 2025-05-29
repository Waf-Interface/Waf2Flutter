// import 'package:flutter/material.dart';
// import 'package:msf/core/component/widgets/custom_dropdown.dart';
// import 'package:msf/core/component/widgets/custom_iconbutton.dart';
// import 'package:msf/core/component/widgets/dashboard_textfield.dart';
// import 'package:msf/core/component/widgets/status_widget.dart';
// import 'package:msf/core/utills/_colorconfig.dart';
//
// class HttpTab extends StatefulWidget {
//   const HttpTab({super.key});
//
//   @override
//   State<HttpTab> createState() => _HttpTabState();
// }
//
// class _HttpTabState extends State<HttpTab> {
//   TextEditingController httpportTextcontroller = TextEditingController();
//   TextEditingController httpsportTextcontroller = TextEditingController();
//   TextEditingController httpTextcontroller = TextEditingController();
//   TextEditingController httpsTextcontroller = TextEditingController();
//   @override
//   void initState() {
//     httpportTextcontroller.text = "80";
//     httpsportTextcontroller.text = "443";
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     httpTextcontroller.dispose();
//     httpportTextcontroller.dispose();
//     httpsTextcontroller.dispose();
//     httpsportTextcontroller.dispose();
//     super.dispose();
//   }
//
//   final List<String> ipList = [
//     "192.168.1.1 - Available",
//   ];
//
//   String? selectedIp;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
//           decoration: BoxDecoration(
//             color: Colors.black12,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Listen On:",
//                 style: TextStyle(fontSize: 20),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   const Text("IP:"),
//                   const SizedBox(width: 10),
//                   Container(
//                     decoration:
//                         BoxDecoration(borderRadius: BorderRadius.circular(10)),
//                     child: CustomDropdownWidget(
//                       list: ipList,
//                       value: ipList[0],
//                       onchangeValue: (value) {
//                         setState(() {
//                           selectedIp = value;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   const Text("Ports HTTP:"),
//                   const SizedBox(width: 10),
//                   SizedBox(
//                     width: 150,
//                     child: DashboardTextfield(
//                       textEditingController: httpportTextcontroller,
//                       maxLength: 5,
//                     ),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 5),
//               Row(
//                 children: [
//                   const Text(
//                     "Ports HTTPS:",
//                   ),
//                   const SizedBox(width: 10),
//                   SizedBox(
//                     width: 150,
//                     child: DashboardTextfield(
//                       textEditingController: httpsportTextcontroller,
//                       maxLength: 5,
//                     ),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 15),
//               SizedBox(
//                 width: 100,
//                 child: CustomIconbuttonWidget(
//                   backColor: primaryColor,
//                   onPressed: () {},
//                   icon: Icons.save,
//                   title: "Save",
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20),
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
//           decoration: BoxDecoration(
//             color: Colors.black12,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Real Application IPs:",
//                 style: TextStyle(fontSize: 20),
//               ),
//               const SizedBox(height: 15),
//               StatusWidget(
//                 title: "HTTP",
//                 backgrounColor: Colors.blueAccent[200],
//                 titleColor: Colors.blueAccent[900],
//               ),
//               const SizedBox(height: 10),
//               DashboardTextfield(
//                 textEditingController: httpTextcontroller,
//                 inputType: TextInputType.multiline,
//                 maxLines: 5,
//               ),
//               const SizedBox(height: 15),
//               StatusWidget(
//                 title: "HTTPS",
//                 backgrounColor: Colors.blueAccent[200],
//                 titleColor: Colors.blueAccent[900],
//               ),
//               const SizedBox(height: 10),
//               DashboardTextfield(
//                 textEditingController: httpTextcontroller,
//                 inputType: TextInputType.multiline,
//                 maxLines: 5,
//               ),
//               const SizedBox(height: 15),
//               SizedBox(
//                 width: 100,
//                 child: CustomIconbuttonWidget(
//                   backColor: primaryColor,
//                   onPressed: () {},
//                   icon: Icons.save,
//                   title: "Save",
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
