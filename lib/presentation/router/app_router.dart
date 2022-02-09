import 'package:flutter/material.dart';
import 'package:it_news/app.dart';
import 'package:it_news/core/exceptions/route_exception.dart';
import 'package:it_news/data/models/post.dart';
import 'package:it_news/data/models/post_full.dart';
import 'package:it_news/data/models/tag.dart';
import 'package:it_news/data/models/user.dart';
import 'package:it_news/presentation/screens/administer/browse_page.dart';
import 'package:it_news/presentation/screens/administer/spam_page.dart';
import 'package:it_news/presentation/screens/authors/author_profile.dart';
import 'package:it_news/presentation/screens/authors/authors_page.dart';
import 'package:it_news/presentation/screens/authors/posts_of_author.dart';
import 'package:it_news/presentation/screens/change_password/change_password_page.dart';
import 'package:it_news/presentation/screens/discover/discover_page.dart';
import 'package:it_news/presentation/screens/home/home_page.dart';
import 'package:it_news/presentation/screens/login/login_page.dart';
import 'package:it_news/presentation/screens/post_detail/post_page.dart';
import 'package:it_news/presentation/screens/profile/profile_edit.dart';
import 'package:it_news/presentation/screens/signup/signup_page.dart';
import 'package:it_news/presentation/screens/splash/splash_page.dart';
import 'package:it_news/presentation/screens/tags/posts_of_tag.dart';
import 'package:it_news/presentation/screens/tags/tags_page.dart';
import 'package:it_news/presentation/screens/write_post/access_and_tags.dart';
import 'package:it_news/presentation/screens/write_post/preview_post.dart';
import 'package:it_news/presentation/screens/write_post/write_post_page.dart';

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
  static const String discover = '/discover';
  static const String tags = '/tags';
  static const String authors = '/authors';
  static const String postsOfTag = '/postsOfTag';
  static const String postsOfAuthor = '/postsOfAuthor';
  static const String authorProfile = '/authorProfile';
  static const String browse = '/browse';
  static const String spam = '/spam';
  static const String writePost = '/writePost';
  static const String previewPost = '/previewPost';
  static const String accessAndTags = '/accessAndTags';

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
      case discover:
        return SlideRightRoute(widget: const DiscoverPage());
      case tags:
        return SlideRightRoute(widget: const TagsPage());
      case authors:
        return SlideRightRoute(widget: const AuthorsPage());
      case postsOfTag:
        final args = settings.arguments as Tag;
        return SlideRightRoute(widget: PostsOfTag(tag: args));
      case postsOfAuthor:
        final args = settings.arguments as User;
        return SlideRightRoute(widget: PostsOfAuthor(author: args));
      case authorProfile:
        final args = settings.arguments as User;
        return SlideRightRoute(widget: AuthorProfile(author: args));
      case browse:
        return SlideRightRoute(widget: const BrowsePage());
      case spam:
        return SlideRightRoute(widget: const SpamPage());
      case writePost:
        final args = settings.arguments as PostFull;
        return SlideRightRoute(widget: WritePostPage(postFull: args));
      case previewPost:
        final args = settings.arguments as PostFull;
        return SlideRightRoute(widget: PreviewPost(postFull: args));
      case accessAndTags:
        final args = settings.arguments as PostFull;
        return SlideRightRoute(widget: PostConfigure(postFull: args));
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
