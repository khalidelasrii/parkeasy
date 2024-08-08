import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/entities/user_entity.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/presentation/bloc/theme_bloc/theme_cubit.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Mon profil'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final user = authState.user;
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildProfileHeader(user),
                    const SizedBox(height: 20),
                    _buildProfileOption(
                      icon: Icons.language,
                      title: 'Langues',
                      onTap: () => _changeLanguage(context),
                    ),
                    _buildProfileOption(
                      icon: Icons.info,
                      title: 'À propos',
                      onTap: () => _showAbout(context),
                    ),
                    _buildProfileOption(
                      icon: Icons.contact_support,
                      title: 'Contactez-nous',
                      onTap: () => _contactUs(context),
                    ),
                    _buildProfileOption(
                      icon: Icons.brightness_6,
                      title: 'Dark Mode',
                      trailing: Switch(
                        value: themeState.themeMode == ThemeMode.dark,
                        onChanged: (value) =>
                            context.read<ThemeBloc>().toggleTheme(),
                      ),
                      onTap: () {},
                    ),
                    _buildProfileOption(
                      icon: Icons.business,
                      title: 'Devenir Manager ?',
                      onTap: () => _becomeManager(context),
                    ),
                    Spacer(),
                    _buildLogoutButton(context),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserEntity? user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              user?.profileUrl != null ? NetworkImage(user!.profileUrl!) : null,
          child: user?.profileUrl == null ? Icon(Icons.person, size: 40) : null,
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user?.name ?? 'User', style: TextStyle(fontSize: 20)),
            GestureDetector(
              onTap: _changeProfileImage,
              child: Icon(Icons.edit, size: 20),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _logout(context),
      icon: Icon(Icons.logout),
      label: Text('Se déconnecter'),
    );
  }

  void _changeProfileImage() {
    // Logique pour changer l'image de profil
  }

  void _changeLanguage(BuildContext context) {
    // Logique pour changer la langue
  }

  void _showAbout(BuildContext context) {
    // Logique pour afficher la page à propos
  }

  void _contactUs(BuildContext context) {
    // Logique pour contacter le support
  }

  void _becomeManager(BuildContext context) {
    // Logique pour devenir manager
  }

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(SingOutEvent());

    // context.go(Routes.authPage);
  }
}
