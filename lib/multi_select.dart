// import 'package:flutter/material.dart';
// class MultiSelectableDropdown extends StatefulWidget {
//   List<bool> category;
//   final List<Subject> subjectList;
//   MultiSelectableDropdown(this.category, this.subjectList);
//   @override
//   _MultiSelectableDropdownState createState() =>
//       _MultiSelectableDropdownState();
// }

// class _MultiSelectableDropdownState extends State<MultiSelectableDropdown> {
//   List<Widget> _buildsubjectList() {
//     List<Widget> s = [];
//     for (int i = 0; i < widget.subjectList.length; i++) {
//       s.add(
//         Container(
//           child: Row(
//             children: <Widget>[
//               Checkbox(
//                   value: widget.category[i],
//                   onChanged: i != 0
//                       ? (val) {
//                           setState(() {
//                             widget.category[i] = val;
//                             if (val == false) {
//                               widget.category[0]=false;
//                             } else {
//                               bool flag=false;
//                               for (int i = 1; i < widget.subjectList.length; i++) {
//                                 if (widget.category[i] == false) {
//                                   flag=true;break;
//                                 }
//                               }
//                               if (flag) {
//                                 widget.category[0]=false;
//                               } else {
//                                 widget.category[0]=true;
//                               }
//                             }
//                           });
//                         }
//                       : (val) {
//                           setState(() {
//                             if (val == false) {
//                               for (int i = 0; i < widget.category.length; i++) {
//                                 widget.category[i] = false;
//                               }
//                             } else {
//                               for (int i = 0; i < widget.category.length; i++) {
//                                 widget.category[i] = true;
//                               }
//                             }
//                           });
//                         }),
//               Text(
//                 widget.subjectList[i].subjectName,
//                 style: TextStyle(fontSize: 16.0),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//     return s;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: _buildsubjectList(),
//       ),
//     );
//   }
// }