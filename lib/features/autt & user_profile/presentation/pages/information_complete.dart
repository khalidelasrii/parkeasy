import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parkeasy/core/constant/constants.dart';
import 'package:parkeasy/core/constant/enum.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:parkeasy/routes.dart';

class InformationCompletePage extends StatefulWidget {
  const InformationCompletePage({super.key});

  @override
  State<InformationCompletePage> createState() =>
      _InformationCompletePageState();
}

class _InformationCompletePageState extends State<InformationCompletePage> {
  final TextEditingController nameController = TextEditingController();
  File? imageProfile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    imageProfile = null;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: darkcolor,
              child: Stack(
                children: [
                  _buildBackground(),
                  _buildContent(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Opacity(
        opacity: opacity,
        child: Image.asset('assets/bg.png', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(context),
            _buildForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        'assets/logo.png',
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.3,
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? darkmodeback
            : white,
        borderRadius: BorderRadius.circular(13.0),
        border: Border.all(
          color:
              Theme.of(context).brightness == Brightness.dark ? purple : white,
          width: 0.3,
        ),
      ),
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.025),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AppStatus.error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error ?? 'Error')));
          } else if (state.status == AppStatus.success && state.user != null) {
            context.go(Routes.mapPage);
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Veuillez compléter votre information !',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.022),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              _buildProfileImage(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              _buildNameField(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              _buildSubmitButton(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: imageProfile == null
          ? CircleAvatar(
              radius: MediaQuery.of(context).size.height * 0.05,
              backgroundColor: Colors.transparent,
              child: const Icon(Icons.person, size: 40),
            )
          : ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: Image.file(
                imageProfile!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageProfile = File(image.path);
      });
    }
  }

  Widget _buildNameField(BuildContext context) {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: 'Nom complet',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer votre nom complet';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context, AuthState state) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final bloc = context.read<AuthBloc>();
            bloc.add(SaveUserInfoEvent(
                name: nameController.text, image: imageProfile));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? bluecolor
              : purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(color: Colors.white),
          ),
        ),
        child: state.status == AppStatus.loading
            ? const CircularProgressIndicator()
            : const Text(
                'Enregistrer',
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
