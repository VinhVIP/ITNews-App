import 'package:flutter/material.dart';
import 'package:it_news/app.dart';
import 'package:it_news/core/exceptions/route_exception.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/presentation/screens/change_password/change_password_page.dart';
import 'package:it_news/presentation/screens/home/home_page.dart';
import 'package:it_news/presentation/screens/login/login_page.dart';
import 'package:it_news/presentation/screens/post_detail/post_page.dart';
import 'package:it_news/presentation/screens/profile/profile_edit.dart';
import 'package:it_news/presentation/screens/signup/signup_page.dart';
import 'package:it_news/presentation/screens/splash/splash_page.dart';

class AppRouter {
  static const String init = '/';
  static const String splash = '/splash';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPass = '/forgotpass';
  static const String changePass = '/changepass';
  static const String profile = '/profile';
  static const String post = '/post';

  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case init:
        return SlideRightRoute(widget: const MyApp());
      case splash:
        return SlideRightRoute(widget: const SplashPage());
      case home:
        return SlideRightRoute(widget: const HomePage());
      case login:
        return SlideRightRoute(widget: const LoginPage());
      case signup:
        return SlideRightRoute(widget: const SignUpPage());
      case post:
        final args = settings.arguments as PostFull;
        return SlideRightRoute(widget: PostPage(post: args));
      case profile:
        return SlideRightRoute(widget: const ProfileEditPage());
      case changePass:
        return SlideRightRoute(widget: const ChangePasswordPage());
      default:
        throw const RouteException('Route not found!');
    }
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRightRoute({
    required this.widget,
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return widget;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
