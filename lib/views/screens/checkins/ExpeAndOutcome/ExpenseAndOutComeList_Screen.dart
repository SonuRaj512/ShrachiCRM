// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../../api/api_services.dart';
// import '../../../../models/ExpenseAndOutcomeModel.dart';
// import 'ExpenseList_Screen.dart';
// import 'OutcomeList_Screen.dart'; // For date formatting
//
//
// class OutComeList_Screeen extends StatefulWidget {
//   const OutComeList_Screeen({super.key});
//
//   @override
//   State<OutComeList_Screeen> createState() => _OutComeList_ScreeenState();
// }
//
// class _OutComeList_ScreeenState extends State<OutComeList_Screeen> {
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
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:AppBar(
//       backgroundColor: Colors.blue,
//       foregroundColor: Colors.white,
//       title: _isSearching
//           ? TextField(
//         autofocus: true,
//         style: const TextStyle(color: Colors.white),
//         decoration: const InputDecoration(
//           hintText: "Search by Serial No...",
//           hintStyle: TextStyle(color: Colors.white70),
//           border: InputBorder.none,
//         ),
//         onChanged: (value) {
//           setState(() {
//             _searchQuery = value;
//             _tourData = ApiService().fetchTours(serialNo: value);
//           });
//         },
//       ): const Text("Outcome List",style: TextStyle(color: Colors.white),),
//       actions: [
//         _isSearching
//           ? IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: () {
//             setState(() {
//               _isSearching = false;
//               _searchQuery = "";
//               _tourData = ApiService().fetchTours();
//             });
//           },
//         ): Padding(
//               padding: const EdgeInsets.only(top: 7.0),
//               child: IconButton(
//                   icon: const Icon(Icons.search),
//                   onPressed: () {
//                     setState(() {
//                       _isSearching = true;
//                     });
//                   },
//               ),
//         ),
//       ],
//     ),
//      body: FutureBuilder<TourResponse>(
//         future: _tourData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.tours.isEmpty) {
//             return const Center(child: Text("No tours available."));
//           } else {
//             final tours = snapshot.data!.tours;
//             return ListView.builder(
//               padding: const EdgeInsets.all(8.0),
//               itemCount: tours.length,
//               itemBuilder: (context, index) {
//                 final tour = tours[index];
//                 return Card(
//                   elevation: 7,
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   color: Colors.grey[200], // Lighter grey for better readability
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "TourId : ${tour.serialNo}",
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                         const Divider(height: 10, color: Colors.grey),
//                         _buildInfoRow("Start Date:", DateFormat('yyyy-MM-dd').format(tour.startDate)),
//                         _buildInfoRow("End Date:", DateFormat('yyyy-MM-dd').format(tour.endDate)),
//                         _buildInfoRow("Status:", tour.status),
//                         // You can iterate through visits if you want to show details for each visit
//                         // For simplicity, let's just show a count here or iterate if needed
//                         _buildInfoRow("Number of Visits:", tour.visits.length.toString()),
//
//                         // Buttons for Expenses and Outcomes (assuming per visit)
//                         // For demonstration, let's assume we take the first visit's expenses/outcomes
//                         // You might need a more complex structure if you want to show for all visits or let the user select a visit.
//                         if (tour.visits.isNotEmpty)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 10.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 Column(
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(Icons.money, color: Colors.green, size: 30),
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => ExpenseListScreen(
//                                               expenses: tour.visits.expand((visit) => visit.expenses).toList(),
//                                               tourSerialNo: tour.serialNo,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     const Text("Expenses", style: TextStyle(fontSize: 12)),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(Icons.check_circle_outline, color: Colors.purple, size: 30),
//                                       onPressed: () {
//                                         // Collect all checkins with outcomes from all visits for this tour
//                                         final List<Checkins> outcomesWithData = tour.visits
//                                             .where((visit) => visit.checkins != null && visit.checkins!.outcome != null)
//                                             .map((visit) => visit.checkins!)
//                                             .toList();
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => OutcomeDetailScreen(
//                                               checkins: outcomesWithData,
//                                               tourSerialNo: tour.serialNo,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     const Text("Outcomes", style: TextStyle(fontSize: 12)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//      ),
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
//             width: 120, // Align labels
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value, // This 'value' is expected to be a non-nullable String
//               style: const TextStyle(color: Colors.black54),
//             ),
//           ),
//         ],
//       ),
//     );
//   }}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../../../api/api_services.dart';
// import '../../../../models/ExpenseAndOutcomeModel.dart';
// import 'ExpenseList_Screen.dart';
// import 'OutcomeList_Screen.dart';
//
//
// class OutComeList_Screeen extends StatefulWidget {
//   const OutComeList_Screeen({super.key});
//
//   @override
//   State<OutComeList_Screeen> createState() => _OutComeList_ScreeenState();
// }
//
// class _OutComeList_ScreeenState extends State<OutComeList_Screeen> {
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
//
//   @override
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
//             hintText: "Search by Tour Id...",
//             hintStyle: TextStyle(color: Colors.white70),
//             border: InputBorder.none,
//           ),
//           onChanged: (value) {
//             setState(() {
//               _searchQuery = value;
//               _tourData = ApiService().fetchTours(serialNo: value);
//             });
//           },
//         ): const Text("Outcome List",style: TextStyle(color: Colors.white),),
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
//       body: FutureBuilder<TourResponse>(
//         future: _tourData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.tours.isEmpty) {
//             return const Center(child: Text("No tours available."));
//           } else {
//             final tours = snapshot.data!.tours;
//             return ListView.builder(
//               padding: const EdgeInsets.all(8.0),
//               itemCount: tours.length,
//               itemBuilder: (context, index) {
//                 final tour = tours[index];
//                 return Card(
//                   elevation: 7,
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   color: Colors.grey[200], // Lighter grey for better readability
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "TourId : ${tour.serialNo}",
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                         const Divider(height: 10, color: Colors.grey),
//                         // Using null-aware operator for dynamic fields that can be null
//                         _buildInfoRow("Start Date :", DateFormat('yyyy-MM-dd').format(tour.startDate)),
//                         _buildInfoRow("End Date :", DateFormat('yyyy-MM-dd').format(tour.endDate)),
//                         _buildInfoRow("Status :", tour.status),
//                         // _buildInfoRow("Visit Date :", tour.visitDate?.toString() ?? 'Nil'),
//                         // _buildInfoRow("Visit Purpose :", tour.visitPurpose?.toString() ?? 'Nil'),
//                         _buildInfoRow("Number of Visits :", tour.visits.length.toString()),
//
//                         if (tour.visits.isNotEmpty)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 10.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 Column(
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(Icons.money, color: Colors.green, size: 30),
//
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => ExpenseListScreen(
//                                               expenses: tour.visits.expand((visit) => visit.expenses).toList(),
//                                               visitId: tour.visits.map((v) => v.visitSerialNo).join(""),
//                                               tourSerialNo: tour.serialNo,                                            ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     const Text("Expenses", style: TextStyle(fontSize: 12)),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     IconButton(
//                                       icon: const Icon(Icons.check_circle_outline, color: Colors.purple, size: 30),
//                                       onPressed: () {
//                                         // Collect all checkins with outcomes from all visits for this tour
//                                         final List<Checkins> outcomesWithData = tour.visits
//                                             .where((visit) => visit.checkins != null && visit.checkins!.outcome != null)
//                                             .map((visit) => visit.checkins!)
//                                             .toList();
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => OutcomeDetailScreen(
//                                               checkins: outcomesWithData,
//                                               tourSerialNo: tour.serialNo,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                     const Text("Outcomes", style: TextStyle(fontSize: 12)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
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
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(color: Colors.black87),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../api/api_services.dart';
import '../../../../models/ExpenseAndOutcomeModel.dart';
import 'ExpenseList_Screen.dart';
import 'OutcomeList_Screen.dart';

class ExpenseAndOutCome_Screeen extends StatefulWidget {
  const ExpenseAndOutCome_Screeen({super.key});

  @override
  State<ExpenseAndOutCome_Screeen> createState() => _ExpenseAndOutCome_ScreeenState();
}

class _ExpenseAndOutCome_ScreeenState extends State<ExpenseAndOutCome_Screeen> {
  late Future<TourResponse> _tourData;

  @override
  void initState() {
    super.initState();
    _tourData = ApiService().fetchTours();
  }
  bool _isSearching = false;
  String _searchQuery = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: _isSearching
            ? TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search by Serial No...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _tourData = ApiService().fetchTours(serialNo: value);
            });
          },
        ): const Text("Outcomes List",style: TextStyle(color: Colors.white),),
        actions: [
          _isSearching
              ? IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchQuery = "";
                _tourData = ApiService().fetchTours();
              });
            },
          ): Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<TourResponse>(
        future: _tourData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.tours.isEmpty) {
            return const Center(child: Text("No tours available."));
          } else {
            final tours = snapshot.data!.tours;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: tours.length,
              itemBuilder: (context, index) {
                final tour = tours[index];
                return Card(
                  elevation: 7,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.grey[200], // Lighter grey for better readability
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "TourId : ${tour.serialNo}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const Divider(height: 10, color: Colors.grey),
                        // Using null-aware operator for dynamic fields that can be null
                        _buildInfoRow("Start Date :", DateFormat('yyyy-MM-dd').format(tour.startDate)),
                        _buildInfoRow("End Date :", DateFormat('yyyy-MM-dd').format(tour.endDate)),
                        _buildInfoRow("Status :", tour.status),
                        // _buildInfoRow("Visit Date :", tour.visitDate?.toString() ?? 'Nil'),
                        // _buildInfoRow("Visit Purpose :", tour.visitPurpose?.toString() ?? 'Nil'),
                        _buildInfoRow("Number of Visits :", tour.visits.length.toString()),

                        if (tour.visits.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.money, color: Colors.green, size: 30),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ExpenseListScreen(
                                              // expenses: tour.visits.expand((visit) => visit.expenses).toList(),
                                              // tourSerialNo: tour.serialNo,
                                              visits: tour.visits,
                                              tourSerialNo: tour.serialNo,

                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const Text("Expenses", style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.check_circle_outline, color: Colors.purple, size: 30),
                                      onPressed: () {
                                        // Collect all checkins with outcomes from all visits for this tour
                                        final List<Checkins> outcomesWithData = tour.visits
                                            .where((visit) => visit.checkins != null && visit.checkins!.outcome != null)
                                            .map((visit) => visit.checkins!)
                                            .toList();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OutcomeDetailScreen(
                                              checkins: outcomesWithData,
                                              tourSerialNo: tour.serialNo,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const Text("Outcomes", style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Align labels
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}