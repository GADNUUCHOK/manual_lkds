import 'package:flutter/material.dart';
import 'package:manual_lkds/navigation/fluro_router.dart';

class DrawerNavigation extends StatelessWidget {
  const DrawerNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const DrawerHeader(
            child: null,
          ),
          ListTile(
            title: const Text('Online LKDS Manual'),
            leading: const Icon(Icons.menu_book_sharp),
            onTap: () {
              FluroRouterNavigation.router
                  .navigateTo(context, '/manual', clearStack: true);
            },
          ),
          ListTile(
            title: const Text('Offline Library Documents'),
            leading: const Icon(Icons.library_books),
            onTap: () {
              FluroRouterNavigation.router
                  .navigateTo(context, '/library', clearStack: true);
            },
          )
        ],
      ),
    );
  }
}
