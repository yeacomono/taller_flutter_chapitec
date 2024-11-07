import 'package:chapitec_app/feature/home/home_page.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  initialLocation: '/${HomePage.name}',
  routes: [
    GoRoute(
      name: HomePage.name,
      path: '/${HomePage.name}',
      builder: (_, state) => const HomePage(),
    )
  ],
);
