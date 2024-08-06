import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:parkeasy/app_localization.dart';
import 'package:parkeasy/core/constant/Constants.dart';
import 'package:parkeasy/core/constant/enum.dart';
import 'package:parkeasy/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:parkeasy/features/auth/presentation/widgets/auth_info.dart';
import 'package:parkeasy/routes.dart';
// import 'package:applicationparck/User/Auth/verification_otp.dart';
// import 'package:applicationparck/User/InformationComplete.dart';
// import 'package:applicationparck/User/map.dart';
// import 'package:applicationparck/app_localization.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AppStatus.success &&
              state.verificationId != null) {
            final AuthInfo authInfo =
                AuthInfo(state.verificationId, state.phoneNumber);
            context.go(Routes.verification, extra: authInfo);
          } else if (state.status == AppStatus.success && state.user != null) {
            if (state.user!.accountStatus == AccountStatus.initial) {
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => InformationComplete()));
            } else {
              // Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (context) => MapPage()));
            }
          } else if (state.status == AppStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'An error occurred')),
            );
          }
        },
        builder: (context, state) {
          return Container(
            color: darkcolor,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      'assets/bg.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: height * 0.1),
                    Image.asset(
                      'assets/logo.png',
                      width: width * 0.65,
                      height: height * 0.3,
                    ),
                    Container(
                      width: width * 0.8,
                      padding: EdgeInsets.all(width * 0.03),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13.0),
                        border: Border.all(
                          color: Colors.white,
                          width: 0.3,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IntlPhoneField(
                            invalidNumberMessage: '',
                            initialCountryCode: "MA",
                            onChanged: (value) {
                              context.read<AuthBloc>().add(UserLoginPhoneEvent(
                                  phone: value.completeNumber));
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          if (state.error != null)
                            Text(
                              state.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          state.status == AppStatus.loading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  width: width * 0.75,
                                  height: height * 0.06,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.read<AuthBloc>().add(
                                          UserLoginPhoneEvent(
                                              phone: state.phoneNumber ?? ''));
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                              bluecolor),
                                      shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          side: const BorderSide(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Suivant'.tr(context),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                          SizedBox(height: height * 0.02),
                          const Divider(),
                          GestureDetector(
                            onTap: () {
                              context.read<AuthBloc>().add(GoogleSignInEvent());
                            },
                            child: Image.asset(
                              'assets/google.png',
                              width: width * 0.085,
                              height: height * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
