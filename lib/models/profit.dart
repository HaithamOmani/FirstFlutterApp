class Profit {
  final int year;
  final int month;
  final double amount;
  final String investorName;
  final String date;

  Profit({
    required this.year,
    required this.month,
    required this.amount,
    required this.investorName,
    required this.date,
  });

  factory Profit.fromJson(Map<String, dynamic> json) {
    return Profit(
      year: json['year'],
      month: json['month'],
      amount: json['amount'],
      investorName: json['investorName'],
      date: json['date'],
    );
  }
}
