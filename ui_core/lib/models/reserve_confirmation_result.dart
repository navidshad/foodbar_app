class ReserveConfirmationResult {
  String message;
  bool succeed;
  int? reservationId;

  ReserveConfirmationResult({
    this.message = '',
    this.reservationId,
    this.succeed = false,
  });
}
