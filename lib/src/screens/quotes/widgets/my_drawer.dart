import 'package:ecom_app_bloc/src/providers/theme_provider.dart';
import 'package:ecom_app_bloc/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themePro = Provider.of<ThemeProvider>(context, listen: false);
    ValueNotifier darkMode = ValueNotifier<bool>(false);
    // final themeMode = context.watch<ThemeBloc>().state.themeMode;
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 50, backgroundColor: Colors.green.shade50),
            SizedBox(height: 10),
            DrawerTile(title: 'Profile', icon: Icons.person),
            DrawerTile(title: 'Settings', icon: Icons.settings),
            DrawerTile(title: 'About', icon: Icons.error),
            ValueListenableBuilder(
              valueListenable: darkMode,
              builder: (context, value, child) {
                return SwitchListTile(
                  thumbColor: WidgetStateProperty.resolveWith((state) {
                    if (state.contains(WidgetState.selected)) {
                      return Colors.white;
                    } else {
                      return Colors.grey;
                    }
                  }),
                  trackColor: WidgetStateProperty.resolveWith((state) {
                    if (state.contains(WidgetState.selected)) {
                      return Colors.green;
                    }
                    return Colors.grey.shade300;
                  }),
                  inactiveTrackColor: Colors.red,
                  value: Utils.getCurrentTheme(),
                  onChanged: (isDark) {
                    Utils.saveCurrentTheme(themePro.isDarkMode);
                    themePro.toggleTheme();
                    // darkMode.value = !darkMode.value;
                    // context.read<ThemeBloc>().add(ChangeThemeEvent(isDark));
                  },
                  secondary: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.dark_mode),
                      SizedBox(width: 20),
                      Text('Dark Mode', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  const DrawerTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      leading: Icon(icon),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}
