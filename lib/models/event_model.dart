class EventModel {
  final String id;
  final String name;
  final String artist;
  final String description;
  final String category;
  final String date;
  final String time;
  final String city;
  final String venue;
  final double basePrice;
  final String imageEmoji;
  final String imageColor;
  final bool isFeatured;
  final List<TicketType> ticketTypes;
  bool isFavorite;

  EventModel({
    required this.id,
    required this.name,
    required this.artist,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.city,
    required this.venue,
    required this.basePrice,
    required this.imageEmoji,
    required this.imageColor,
    this.isFeatured = false,
    required this.ticketTypes,
    this.isFavorite = false,
  });
}

class TicketType {
  final String id;
  final String name;
  final double price;
  final List<String> benefits;
  final String badge;

  const TicketType({
    required this.id,
    required this.name,
    required this.price,
    required this.benefits,
    required this.badge,
  });
}
