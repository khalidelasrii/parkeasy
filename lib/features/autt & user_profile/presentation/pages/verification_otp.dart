import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:parkeasy/core/constant/enum.dart';
import 'package:parkeasy/routes.dart';
import 'package:pinput/pinput.dart';
import 'package:parkeasy/core/constant/Constants.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:parkeasy/app_localization.dart';

class VerificationOtp extends StatefulWidget {
  const VerificationOtp(
      {super.key, required this.verificationId, required this.phoneNumber});
  final String verificationId;
  final String phoneNumber;

  @override
  State<VerificationOtp> createState() => _VerificationOtpState();
}

class _VerificationOtpState extends State<VerificationOtp> {
  String smsCode = "";
  bool loading = false;
  bool resend = false;
  int count = 20;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    decompte();
  }

  void decompte() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (count < 1) {
        timer.cancel();
        count = 20;
        resend = true;
        setState(() {});
        return;
      }
      count--;
      setState(() {});
    });
  }

  void onResendSmsCode(BuildContext context) {
    resend = false;
    setState(() {});
    BlocProvider.of<AuthBloc>(context)
        .add(UserLoginPhoneEvent(phone: widget.phoneNumber));
    decompte();
  }

  void onVerifySmsCode(BuildContext context) {
    loading = true;
    setState(() {});
    BlocProvider.of<AuthBloc>(context)
        .add(VerificationOTPEvent(smsCode, widget.verificationId));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AppStatus.success && state.user != null) {
            if (state.user!.accountStatus == AccountStatus.initial) {
              context.go(Routes.informationCompleteUser);
            } else {
              context.go(Routes.mapPage);
            }
          } else if (state.status == AppStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error ?? 'An error occurred')),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Container(
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
                      SizedBox(width: double.infinity, height: height * 0.1),
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
                            Center(
                              child: Text(
                                "Check your messages to validate".tr(context),
                                style: TextStyle(
                                  fontSize: height * 0.019,
                                  color: Theme.of(context).brightness !=
                                          Brightness.dark
                                      ? white
                                      : darkcolor,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.04),
                            Pinput(
                              length: 6,
                              defaultPinTheme: PinTheme(
                                width: 56,
                                height: 56,
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              focusedPinTheme: PinTheme(
                                width: 56,
                                height: 56,
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              submittedPinTheme: PinTheme(
                                width: 56,
                                height: 56,
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (value) {
                                smsCode = value;
                                setState(() {});
                              },
                              onCompleted: (value) {
                                context.read<AuthBloc>().add(
                                    VerificationOTPEvent(
                                        smsCode, widget.verificationId));
                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? bluecolor
                                              : darkcolor,
                                      padding: EdgeInsets.symmetric(
                                          vertical: height * 0.02)),
                                  onPressed: smsCode.length < 6 ||
                                          state.status == AppStatus.loading
                                      ? null
                                      : () => onVerifySmsCode(context),
                                  child: state.status == AppStatus.loading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : Text(
                                          "Suivant".tr(context),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                ),
                                TextButton(
                                  onPressed: !resend
                                      ? null
                                      : () => onResendSmsCode(context),
                                  child: Text(
                                    !resend
                                        ? "00:${count.toString().padLeft(2, "0")}"
                                        : "Pas recu".tr(context),
                                    style: TextStyle(color: bluecolor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
