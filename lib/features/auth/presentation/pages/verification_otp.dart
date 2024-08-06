import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkeasy/core/constant/enum.dart';
import 'package:pinput/pinput.dart';

import 'package:parkeasy/core/constant/Constants.dart';
import 'package:parkeasy/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
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
              // Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (context) => InformationComplete()));
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
                          Text(
                            "Check your messages to validate".tr(context),
                            style: TextStyle(
                              fontSize: height * 0.019,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? white
                                  : darkcolor,
                            ),
                          ),
                          SizedBox(height: height * 0.04),
                          Pinput(
                            length: 6,
                            onChanged: (value) {
                              smsCode = value;
                              setState(() {});
                            },
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: !resend
                                  ? null
                                  : () => onResendSmsCode(context),
                              child: Text(!resend
                                  ? "00:${count.toString().padLeft(2, "0")}"
                                  : "resend code".tr(context)),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? purple
                                            : darkcolor,
                                    padding: EdgeInsets.symmetric(
                                        vertical: height * 0.02)),
                                onPressed: smsCode.length < 6 ||
                                        state.status == AppStatus.loading
                                    ? null
                                    : () => onVerifySmsCode(context),
                                child: state.status == AppStatus.loading
                                    ? CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        "Verify".tr(context),
                                        style: const TextStyle(
                                            color: Colors.white),
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
          );
        },
      ),
    );
  }
}
