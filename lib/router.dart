import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home.dart';
import 'groups.dart';
import 'explore.dart';
import 'profile.dart';
import 'group_chat.dart';

/// Central place where we define all the routes (screens) in the app.
///
/// - `GoRouter` is a package that replaces the older `Navigator.push` style.
/// - It knows which URL/path should show which widget.
/// - We expose this as `appRouter` so `MaterialApp.router` in `main.dart`
///   can use it.
final GoRouter appRouter = GoRouter(
  // This is the first route/screen that will be shown when the app starts.
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      // URL path for the Home page.
      path: '/',
      // Optional route name; can be used instead of the raw string path.
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        // Return the widget that should be shown when we are on `/`.
        return const HomePage();
      },
    ),
    GoRoute(
      // URL path for the Groups page.
      //
      // We conceptually place this "between" Home and Explore in the tab order,
      // but each route is still fully independent and can be deep‑linked.
      path: '/groups',
      name: 'groups',
      builder: (BuildContext context, GoRouterState state) {
        return const GroupsPage();
      },
    ),
    GoRoute(
      path: '/explore',
      name: 'explore',
      builder: (BuildContext context, GoRouterState state) {
        return const ExplorePage();
      },
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (BuildContext context, GoRouterState state) {
        return const ProfilePage();
      },
    ),
    GoRoute(
      // Route for the **group chat** screen.
      //
      // We keep the URL simple (`/groups/chat`) and pass the actual group
      // details via `state.extra`. That way we do not have to encode complex
      // names in the URL path itself.
      path: '/groups/chat',
      name: 'groupChat',
      builder: (BuildContext context, GoRouterState state) {
        // `extra` is a generic `Object?`, so we safely cast it and provide a
        // sensible fallback if nothing was passed.
        final Object? extra = state.extra;
        String groupName = 'Group';

        if (extra is Map<String, String>) {
          groupName = extra['name'] ?? groupName;
        }

        return GroupChatPage(groupName: groupName);
      },
    ),
  ],
);
