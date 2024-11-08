class Tender {
  final String? tenderNumber;
  final String? tenderName;
  final String? currentTime;
  final String? tenderOwnerName;
  final String? currentEmployee;
  final String? tenderSection;
  final String? tenderDirection;
  final String? tenderLocation;
  final String? actionOnTender;
  final String? lastActionBy;

  Tender(
      {this.tenderNumber,
      this.tenderName,
      this.tenderOwnerName,
      this.currentTime,
      this.currentEmployee,
      this.tenderSection,
      this.tenderDirection,
      this.tenderLocation,
      this.actionOnTender,
      this.lastActionBy});
}

class TenderLog{
  final String? tenderNumber;
  final String? tenderName;
  final String? currentTime;
  final String? tenderOwnerName;
  final String? currentEmployee;
  final String? tenderSection;
  final String? tenderDirection;
  final String? tenderLocation;
  final String? actionOnTender;
  final String? lastActionBy;

  TenderLog(
      {this.tenderNumber,
      this.tenderName,
      this.tenderOwnerName,
      this.currentTime,
      this.currentEmployee,
      this.tenderSection,
      this.tenderDirection,
      this.tenderLocation,
      this.actionOnTender,
      this.lastActionBy});
}
