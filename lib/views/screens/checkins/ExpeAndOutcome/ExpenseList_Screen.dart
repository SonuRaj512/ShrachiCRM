// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../../models/ExpenseAndOutcomeModel.dart';// Make sure this path is correct
//
// class ExpenseListScreen extends StatelessWidget {
//   final List<Expense> expenses;
//   final String tourSerialNo;
//
//   const ExpenseListScreen({
//     super.key,
//     required this.expenses,
//     required this.tourSerialNo,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//         title: Text(
//           "Expenses for Tour: $tourSerialNo",
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//       body: expenses.isEmpty
//           ? const Center(child: Text("No expenses found for this tour."))
//           : ListView.builder(
//         padding: const EdgeInsets.all(12.0),
//         itemCount: expenses.length,
//         itemBuilder: (context, index) {
//           final expense = expenses[index];
//           return Card(
//             color: Colors.grey[200],
//             elevation: 5,
//             //margin: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Expense Type: ${expense.type}",
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.greenAccent,
//                     ),
//                   ),
//                   const Divider(height: 10, color: Colors.grey),
//                   _buildInfoRow("Amount:", "₹${expense.amount}"),
//                   _buildInfoRow("Date:", DateFormat('yyyy-MM-dd').format(expense.date)),
//                   if (expense.description != null) _buildInfoRow("Description:", expense.description!),
//                   _buildInfoRow("Status:", expense.status),
//                   _buildInfoRow("Expense Status:", expense.expenseStatus),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2.0,),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120, // Align labels
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
//             ),
//           ),
//           const SizedBox(width: 100), // ✅ Horizontal space added
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(color: Colors.black54),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class ExpenseListScreen extends StatelessWidget {
//   // 🔥 Static data — yaha aap dummy values rakhe ho
//   final List<Map<String, dynamic>> expenses = [
//     {
//       "id": "V-11250019-1",
//       "expensetype": "conveyance",
//       "amount": "500.00",
//       "date": DateTime(2025, 11, 17),
//       "description": "Train travel",
//       "status": "unpaid",
//       "expense_status": "approval",
//     },
//     {
//       "id": "V-11250019-1",
//       "expensetype": "Nonconveyance",
//       "amount": "250.00",
//       "date": DateTime(2025, 11, 17),
//       "description": "Lunch",
//       "status": "paid",
//       "expense_status": "approved",
//     },
//   ];
//
//   final String tourSerialNo = "TP-11250019";
//   final String visitId = "123";
//
//   ExpenseListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         title: Text(
//           "Tour ID: $tourSerialNo",
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//
//       // ---------------- UI BODY ----------------
//       body: expenses.isEmpty
//           ? const Center(child: Text("No expenses found for this visit."))
//           : ListView.builder(
//         padding: const EdgeInsets.all(12.0),
//         itemCount: expenses.length,
//         itemBuilder: (context, index) {
//           final expense = expenses[index];
//
//           return Card(
//             color: Colors.grey[200],
//             elevation: 5,
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Visit ID: ${expense["id"]}",
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.greenAccent,
//                     ),
//                   ),
//                   const Divider(height: 10, color: Colors.grey),
//
//                   _buildInfoRow("Visit ID:", visitId),
//                   _buildInfoRow("Expense Type:", expense["expensetype"]),
//                   _buildInfoRow("Amount:", "₹${expense["amount"]}"),
//
//                   _buildInfoRow(
//                     "Date:",
//                     DateFormat('yyyy-MM-dd')
//                         .format(expense["date"]),
//                   ),
//
//                   if (expense["description"] != null)
//                     _buildInfoRow(
//                         "Description:", expense["description"]),
//
//                   _buildInfoRow("Status:", expense["status"]),
//                   _buildInfoRow("Expense Status:",
//                       expense["expense_status"]),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           const SizedBox(width: 20),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(color: Colors.black54),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../../api/api_services.dart';
// import '../../../../models/ExpenseAndOutcomeModel.dart';// Make sure this path is correct
//
// class ExpenseListScreen extends StatefulWidget {
//   final List<Expense> expenses;
//   final String tourSerialNo;
//   final String visitId;
//
//   const ExpenseListScreen({
//     super.key,
//     required this.expenses,
//     required this.tourSerialNo,
//     required this.visitId,
//   });
//
//   @override
//   State<ExpenseListScreen> createState() => _ExpenseListScreenState();
// }
//
// class _ExpenseListScreenState extends State<ExpenseListScreen> {
//   late Future<TourResponse> _tourData;
//
//   @override
//   void initState() {
//     super.initState();
//     _tourData = ApiService().fetchTours();
//   }
//   bool _isSearching = false;
//   String _searchQuery = "";
//
//  List _visit = [] ;
//   @override
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:AppBar(
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         title: _isSearching
//             ? TextField(
//           autofocus: true,
//           style: const TextStyle(color: Colors.white),
//           decoration: const InputDecoration(
//             hintText: "Search by Visit Id...",
//             hintStyle: TextStyle(color: Colors.white70),
//             border: InputBorder.none,
//           ),
//           onChanged: (value) {
//             setState(() {
//               _searchQuery = value;
//               _tourData = ApiService().fetchTours(visitSerialNo: value);
//             });
//           },
//         ): Text(
//           "Tour ID: ${widget.tourSerialNo}",
//           style: const TextStyle(color: Colors.white),
//         ),
//         actions: [
//           _isSearching
//               ? IconButton(
//             icon: const Icon(Icons.close),
//             onPressed: () {
//               setState(() {
//                 _isSearching = false;
//                 _searchQuery = "";
//                 _tourData = ApiService().fetchTours();
//               });
//             },
//           ): Padding(
//             padding: const EdgeInsets.only(top: 7.0),
//             child: IconButton(
//               icon: const Icon(Icons.search),
//               onPressed: () {
//                 setState(() {
//                   _isSearching = true;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//       body: widget.expenses.isEmpty
//           ? const Center(child: Text("No expenses found for this tour."))
//           : ListView.builder(
//         padding: const EdgeInsets.all(12.0),
//         itemCount: widget.expenses.length,
//         itemBuilder: (context, index) {
//           final expense = widget.expenses[index];
//           return Card(
//             color: Colors.grey[200],
//             elevation: 5,
//             //margin: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Expense ID: ${expense.id ?? 'N/A'}",
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.greenAccent,
//                     ),
//                   ),
//                   const Divider(height: 10, color: Colors.grey),
//                   //_buildInfoRow("VisitId", widget.visitId),
//                   _buildInfoRow("Expense Type:", expense.expensetype),
//                   _buildInfoRow("Amount:", "₹${expense.amount}"),
//                   _buildInfoRow("Date:", DateFormat('yyyy-MM-dd').format(expense.date)),
//                   if (expense.description != null) _buildInfoRow("Description:", expense.description!),
//                   _buildInfoRow("Status:", expense.status),
//                   _buildInfoRow("Expense Status:", expense.expenseStatus),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2.0,),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120, // Align labels
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
//             ),
//           ),
//           const SizedBox(width: 100), // ✅ Horizontal space added
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(color: Colors.black54),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/ExpenseAndOutcomeModel.dart';

class ExpenseListScreen extends StatelessWidget {
  final List<Visits1> visits; // <-- change this
  final String tourSerialNo;

  const ExpenseListScreen({
    super.key,
    required this.visits, // <-- change this
    required this.tourSerialNo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text(
          "Expenses for Tour: $tourSerialNo",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: visits.isEmpty
          ? const Center(child: Text("No visits or expenses found for this tour."))
          : ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: visits.length,
        itemBuilder: (context, visitIndex) {
          final visit = visits[visitIndex];
          final expenses = visit.expenses;

          return Card(
            color: Colors.grey[200],
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Visit Serial No: ${visit.visitSerialNo}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  const Divider(color: Colors.grey),

                  if (expenses.isEmpty)
                    const Text("No expenses for this visit."),
                  for (var expense in expenses) ...[
                    Card(
                      color: Colors.white,
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Expense ID: ${expense.id}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            _buildInfoRow("Type:", expense.type),
                            _buildInfoRow("Amount:", "₹${expense.amount}"),
                            _buildInfoRow("Date:", DateFormat('yyyy-MM-dd').format(expense.date)),
                            if (expense.description != null)
                              _buildInfoRow("Description:", expense.description!),
                            _buildInfoRow("Status:", expense.status),
                            _buildInfoRow("Expense Status:", expense.expenseStatus),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
