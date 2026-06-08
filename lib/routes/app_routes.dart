import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/music_taste_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/event_detail_screen.dart';
import '../screens/ticket_select_screen.dart';
import '../screens/payment_screen.dart';
import '../screens/purchase_success_screen.dart';
import '../screens/my_tickets_screen.dart';
import '../screens/profile_screen.dart';
import '../models/event_model.dart';
import '../models/ticket_model.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const musicTaste = '/music-taste';
  static const home = '/home';
  static const search = '/search';
  static const eventDetail = '/event-detail';
  static const ticketSelect = '/ticket-select';
  static const payment = '/payment';
  static const purchaseSuccess = '/purchase-success';
  static const myTickets = '/my-tickets';
  static const profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    musicTaste: (_) => const MusicTasteScreen(),
    home: (_) => const HomeScreen(),
    search: (_) => const SearchScreen(),
    myTickets: (_) => const MyTicketsScreen(),
    profile: (_) => const ProfileScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case eventDetail:
        final event = settings.arguments as EventModel;
        return MaterialPageRoute(builder: (_) => EventDetailScreen(event: event));
      case ticketSelect:
        final event = settings.arguments as EventModel;
        return MaterialPageRoute(builder: (_) => TicketSelectScreen(event: event));
      case payment:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => PaymentScreen(
          event: args['event'] as EventModel,
          ticketType: args['ticketType'] as TicketType,
          quantity: args['quantity'] as int,
        ));
      case purchaseSuccess:
        final ticket = settings.arguments as PurchasedTicket;
        return MaterialPageRoute(builder: (_) => PurchaseSuccessScreen(ticket: ticket));
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
