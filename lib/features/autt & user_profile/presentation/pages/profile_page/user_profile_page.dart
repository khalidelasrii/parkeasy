import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkeasy/core/constant/constants.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/entities/user_entity.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/presentation/bloc/theme_bloc/theme_cubit.dart';
import 'package:parkeasy/routes.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // final screenSize = MediaQuery.of(context).size;
// final screenWidth = screenSize.width;
// final screenHeight = screenSize.height
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final isDarkMode = themeState.themeMode.brightness == Brightness.dark;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  context.go(Routes.mapPage);
                },
                icon: const Icon(Icons.arrow_back)),
            flexibleSpace: SafeArea(
              child: Center(
                child: Text(
                  'Mon profil',
                  style: TextStyle(
                    fontSize: 20 * MediaQuery.of(context).textScaler.scale(1.0),
                  ),
                ),
              ),
            ),
          ),
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final user = authState.user;
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: constraints.maxHeight * 0.05,
                      horizontal: constraints.maxWidth * 0.05,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDarkMode ? bluecolor : Colors.transparent,
                        ),
                        color: isDarkMode ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: constraints.maxHeight * 0.04,
                          horizontal: constraints.maxWidth * 0.05,
                        ),
                        child: Column(
                          children: [
                            _buildProfileHeader(user, constraints),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            Expanded(
                              child: ListView(
                                children: [
                                  _buildProfileOption(
                                      icon: Icons.account_circle_outlined,
                                      title: '${user?.name}',
                                      onTap: () => _changeUserName(user!),
                                      trailing: const Icon(Icons.edit)),
                                  _buildProfileOption(
                                    icon: Icons.language,
                                    title: 'Langues',
                                    onTap: () => _changeLanguage(context),
                                    trailing: const Icon(
                                        Icons.keyboard_arrow_right_sharp),
                                  ),
                                  _buildProfileOption(
                                    icon: Icons.info,
                                    title: 'À propos',
                                    onTap: () => _showAbout(context),
                                    trailing: const Icon(
                                        Icons.keyboard_arrow_right_sharp),
                                  ),
                                  _buildProfileOption(
                                    icon: Icons.contact_support,
                                    title: 'Contactez-nous',
                                    onTap: () => _contactUs(context),
                                    trailing: const Icon(
                                        Icons.keyboard_arrow_right_sharp),
                                  ),
                                  _buildProfileOption(
                                    icon: Icons.brightness_6,
                                    title: 'Dark Mode',
                                    trailing: Switch(
                                      value: isDarkMode,
                                      onChanged: (value) {
                                        context.read<ThemeBloc>().toggleTheme();
                                      },
                                    ),
                                    onTap: () {},
                                  ),
                                  _buildProfileOption(
                                    icon: Icons.business,
                                    title: 'Devenir Manager ?',
                                    onTap: () => _becomeManager(context),
                                    trailing: const Icon(
                                        Icons.keyboard_arrow_right_sharp),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.02),
                            _buildLogoutButton(context),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(UserEntity? user, BoxConstraints constraints) {
    return Padding(
      padding: EdgeInsets.only(bottom: constraints.maxHeight * 0.04),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: constraints.maxWidth * 0.2,
            height: constraints.maxWidth * 0.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3.0,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: constraints.maxWidth * 0.1,
              backgroundImage: user?.profileUrl != null
                  ? NetworkImage(user!.profileUrl!)
                  : null,
              child: user?.profileUrl == null
                  ? Icon(Icons.person, size: constraints.maxWidth * 0.1)
                  : null,
            ),
          ),
          GestureDetector(
            onTap: _changeProfileImage,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: constraints.maxWidth * 0.03,
              child: Icon(Icons.camera_alt,
                  size: constraints.maxWidth * 0.04, color: Colors.white),
            ),
          ),
        ],
      ),
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
      title: Text(title,
          style: TextStyle(
              fontSize: 16 * MediaQuery.of(context).textScaler.scale(1.0))),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _logout(context),
        icon: const Icon(Icons.logout),
        label: Text('Se déconnecter',
            style: TextStyle(
                fontSize: 16 * MediaQuery.of(context).textScaler.scale(1.0))),
      ),
    );
  }

  void _changeUserName(UserEntity user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newName = user.name ?? '';
        return AlertDialog(
          title: const Text('Changer le nom'),
          content: TextField(
            onChanged: (value) {
              newName = value;
            },
            decoration: const InputDecoration(hintText: "Nouveau nom"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmer'),
              onPressed: () {
                if (newName.isNotEmpty) {
                  // context.read<AuthBloc>().add(UpdateUserNameEvent(newName));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _changeProfileImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Changer l\'image de profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choisir depuis la galerie'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Prendre une photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _takePhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImageFromGallery() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // context.read<AuthBloc>().add(UpdateProfileImageEvent(image.path));
        print("Image sélectionnée : ${image.path}");
      } else {
        print("Aucune image sélectionnée");
      }
    } catch (e) {
      print("Erreur lors de la sélection de l'image : $e");
    }
  }

  void _takePhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      // context.read<AuthBloc>().add(UpdateProfileImageEvent(photo.path));
    }
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
    context.go(Routes.authPage);
  }
}
