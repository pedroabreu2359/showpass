import 'event_model.dart';

class PurchasedTicket {
  final String id;
  final EventModel event;
  final TicketType ticketType;
  final int quantity;
  final double totalPrice;
  final String purchaseDate;
  final String seatCode;
  final String qrCode;

  PurchasedTicket({
    required this.id,
    required this.event,
    required this.ticketType,
    required this.quantity,
    required this.totalPrice,
    required this.purchaseDate,
    required this.seatCode,
    required this.qrCode,
  });
}
