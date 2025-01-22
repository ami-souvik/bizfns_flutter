class JobScheduleModel{
  final String time;
  final List<Jobs> jobList;

  JobScheduleModel({
    required this.time,
    required this.jobList
});
}


class Jobs{
  final int id;
  final int jobNo;
  final List<int> staffNo;
  final List<int> custNo;

  Jobs({
    required this.id,
    required this.jobNo,
    required this.staffNo,
    required this.custNo
});
}