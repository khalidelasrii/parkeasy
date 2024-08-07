import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkeasy/app_localization.dart';
import 'package:parkeasy/core/constant/constants.dart';
import 'package:parkeasy/features/auth/presentation/bloc/user_information_bloc/user_information_bloc.dart';
import 'package:parkeasy/features/auth/presentation/bloc/user_information_bloc/user_information_event.dart';
import 'package:parkeasy/features/auth/presentation/bloc/user_information_bloc/user_information_state.dart';
import 'package:parkeasy/features/homeScreen/presentation/pages/home_screen.dart';

class InformationCompletePage extends StatelessWidget {
  const InformationCompletePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserInformationBloc(),
      child: _InformationCompleteView(),
    );
  }
}

class _InformationCompleteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: darkcolor,
          child: Stack(
            children: [
              _buildBackground(),
              _buildContent(context),
            ],
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
    return Column(
      children: [
        _buildLogo(context),
        _buildForm(context),
      ],
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
      height: MediaQuery.of(context).size.height * 0.5,
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
      child: BlocConsumer<UserInformationBloc, UserInformationState>(
        listener: (context, state) {
          if (state is Error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is UserInfoSaved) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => HomeScreen()));
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'complete information'.tr(context),
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.022),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              _buildProfileImage(context, state),
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

  Widget _buildProfileImage(BuildContext context, UserInformationState state) {
    return CircleAvatar(
      radius: MediaQuery.of(context).size.height * 0.05,
      backgroundColor: Colors.transparent,
      // child: ProfileWidget(
      //   isloading: state is Loading,
      //   imagePathbg: 'assets/profil.png',
      //   isEdit: true,
      //   imagePath: state is ImageUploaded ? state.imageUrl : '',
      //   onClicked: () => context.read<UserInformationBloc>().add(PickImage()),
      // ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextField(
      controller: TextEditingController(),
      decoration: InputDecoration(
        labelText: 'Nom Complet'.tr(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, UserInformationState state) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton(
        onPressed: state is Loading
            ? null
            : () {
                final bloc = context.read<UserInformationBloc>();
                final nameField =
                    context.findAncestorWidgetOfExactType<TextField>();
                final name = nameField?.controller?.text ?? '';
                bloc.add(SaveUserInfo(
                  name: name,
                  imageFile: state is ImagePicked ? state.imageFile : null,
                ));
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? purple
              : bluecolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.white),
          ),
        ),
        child: Text(
          'Suivant'.tr(context),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
