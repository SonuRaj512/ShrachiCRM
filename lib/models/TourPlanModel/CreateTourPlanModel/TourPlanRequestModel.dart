class TourPlanRequest {
  final String startDate;
  final String endDate;
  final String tourPlanOption;
  final List<Map<String, dynamic>> visits;

  TourPlanRequest({
    required this.startDate,
    required this.endDate,
    required this.tourPlanOption,
    required this.visits,
  });

  Map<String, dynamic> toJson() {
    return {
      "start_date": startDate,
      "end_date": endDate,
      "tour_plan_option": tourPlanOption,
      "visits": visits,
    };
  }
}
