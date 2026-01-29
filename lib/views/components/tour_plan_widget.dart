import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class TourPlanWidget extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final Color intervalBackgroundColor;
  final IconData intervalIcon;
  final Color intervalIconColor;
  final String intervalText;
  final Color intervalTextColor;
  final bool showStats;
  final Color? statsBackgroundColor;
  final IconData? statsIcon;
  final Color? statsIconColor;
  final String? statsText;
  final Color? statsTextColor;
  final Widget? trailing;
  final String? tour_status;
  final String? expenseStatusLabel;   // "Partially Approved"
  final String? expenseStatusKey;     // "partial"
  final bool isLocked;

  // final String? Expense_status;

  const TourPlanWidget({
    super.key,
    required this.title,
    this.showStats = false,
    required this.onTap,
    required this.intervalBackgroundColor,
    required this.intervalIcon,
    required this.intervalIconColor,
    required this.intervalText,
    required this.intervalTextColor,
    this.statsBackgroundColor,
    this.statsIcon,
    this.statsIconColor,
    this.statsText,
    this.statsTextColor,
    this.trailing,
    this.tour_status,
    this.expenseStatusLabel,
    this.expenseStatusKey,
    this.isLocked = false, // 👈 Default false rakha
    //this.Expense_status,
  });

  @override
  State<TourPlanWidget> createState() => _TourPlanWidgetState();
}

class _TourPlanWidgetState extends State<TourPlanWidget> {
  Color getStatusTextColor(String status) {
    switch (status) {
      case 'Tour Completed':
      case 'Tour Complete':
        return Colors.green;

      case 'Tour is Going On':
        return Color(0xFFFF6D00);

      case 'Tour Partially Completed':
        return Colors.orange;

      case 'Tour Not Completed':
        return Colors.red;

      default:
        return Colors.grey.shade600;
    }
  }
  // 👉 OLD function replace karke ye use karo
  // ExpenseStatusUI getExpenseStatusUI(String? status) {
  //   switch (status) {
  //     case "confirmed":
  //       return const ExpenseStatusUI(
  //         color: Colors.green,
  //         label: "Expense : Approved",
  //       );
  //
  //     case "approval":
  //       return const ExpenseStatusUI(
  //         color: Colors.blue,
  //         label: "Expense : Send For Approval",
  //       );
  //
  //     case "partial":
  //       return const ExpenseStatusUI(
  //         color: Colors.orange,
  //         label: "Expense : Partially Approved",
  //       );
  //
  //     case "no_expense":
  //       return ExpenseStatusUI(
  //         color: Colors.grey.shade600,
  //         label: "Expense : No Expense",
  //       );
  //
  //     case "pending":
  //       return const ExpenseStatusUI(
  //         color: Colors.amber,
  //         label: "Expense : Pending",
  //       );
  //
  //     case "rejected":
  //       return const ExpenseStatusUI(
  //         color: Colors.red,
  //         label: "Expense : Rejected",
  //       );
  //
  //     default:
  //       return const ExpenseStatusUI(
  //         color: Colors.grey,
  //         label: "Expense : Unknown",
  //       );
  //   }
  // }

  Color _expenseStatusColor(String? status) {
    switch (status) {
      case "confirmed":
        return Colors.green;

      case "approval":
        return Colors.blue;

      case "partial":
        return Colors.orange;

      case "no_expense":
        return Colors.grey.shade600;

      case "pending":
      case "rejected":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }
void initState(){
    super.initState();
    //print("Expense Status ${widget.expenseStatusLabel}");
    //print("Expense Status ${widget.expenseStatusKey}");
   // print("Tour Status ${widget.tour_status}");
}

  @override
  Widget build(BuildContext context) {
    //final expenseUI = getExpenseStatusUI(widget.expenseStatusKey);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          // 👈 2. Background color change logic (Locked = Deep Grey, Normal = White)
          color: widget.isLocked ? const Color(0xFFD6D6D6) : Colors.white,
          //color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                 if (widget.isLocked)
                  const Icon(
                    Ionicons.lock_closed,
                    color: Colors.red,
                    size: 18,
                  ),
              ],
            ),
            // 🟢 Title
            // Text(
            //   widget.title,
            //   style: const TextStyle(
            //     color: Colors.black,
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            const SizedBox(height: 10.0),

            // 🟢 Interval row + trailing button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        color: widget.intervalBackgroundColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        widget.intervalIcon,
                        color: widget.intervalIconColor,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      widget.intervalText,
                      style: TextStyle(color: widget.intervalTextColor),
                    ),
                  ],
                ),

                // 🟢 Optional trailing button
                if (widget.trailing != null) widget.trailing!,
              ],
            ),
            const SizedBox(height: 10.0),

            // 🟢 Optional Stats Section
            if (widget.showStats)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      color: widget.statsBackgroundColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      widget.statsIcon,
                      color: widget.statsIconColor,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    widget.statsText ?? '',
                    style: TextStyle(
                      color: widget.statsTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // const Text(
                //   "Status :",
                //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(width: 22),

                Text(
                  widget.tour_status ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: getStatusTextColor(widget.tour_status ?? ''), // 👈 only text color
                  ),
                ),
              ],
            ),
            Text(
              widget.expenseStatusLabel ?? '',
              style: TextStyle(
                color: _expenseStatusColor(widget.expenseStatusKey),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 👉 Expense status ke liye color + label ek saath rakhne ke liye
class ExpenseStatusUI {
  final Color color;
  final String label;

  const ExpenseStatusUI({
    required this.color,
    required this.label,
  });
}
