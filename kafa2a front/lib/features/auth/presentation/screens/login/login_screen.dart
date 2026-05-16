import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/config/routes_manager.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/core/utils/validators.dart';
import 'package:kafa2a/core/widgets/default_submit_button.dart';
import 'package:kafa2a/core/widgets/ui_utils.dart';
import 'package:kafa2a/features/auth/data/models/login_request.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_states.dart';
import 'package:kafa2a/features/auth/presentation/screens/login/widgets/email_form_field.dart';
import 'package:kafa2a/features/auth/presentation/screens/login/widgets/password_form_field.dart';
import 'package:kafa2a/features/auth/presentation/screens/widgets/label_text_form_widget.dart';
import 'package:kafa2a/features/auth/presentation/screens/widgets/title_widget.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String userType =
        ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: 350.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border:
                        Border.all(color: ColorsManager.blue, width: 1.2.w)),
                child: Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleWidget(title: AppLocalizations.of(context).login),
                        LabelTextFormWidget(
                            label: AppLocalizations.of(context).email),
                        EmailFormField(
                          controller: emailController,
                        ),
                        SizedBox(height: 20.h),
                        LabelTextFormWidget(
                            label: AppLocalizations.of(context).password),
                        PasswordFormField(
                          controller: passwordController,
                          validator: (password) =>
                              Validators.validatePassword(password, context),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                          child: BlocListener<AuthCubit, AuthStates>(
                            listener: (_, state) {
                              if (state is AuthLoadingState) {
                                UIUtils.showLoading(context);
                              } else if (state is AuthErrorState) {
                                UIUtils.hideLoading(context);
                                UIUtils.showMessage(state.error);
                              } else if (state is AuthSuccessState) {
                                UIUtils.hideLoading(context);
                                if (userType == UserType.user) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    RoutesManager.homeUser,
                                    (route) => false,
                                  );
                                } else {
                                  if (context
                                          .read<AuthCubit>()
                                          .provider!
                                          .status ==
                                      ProviderStatus.approved) {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      RoutesManager.homeProvider,
                                      (route) => false,
                                    );
                                  } else {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      RoutesManager.homeSuspendedProvider,
                                      (route) => false,
                                    );
                                  }
                                }
                              }
                            },
                            child: DefaultSubmitButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (userType == UserType.user) {
                                      context.read<AuthCubit>().loginUser(
                                            LoginRequest(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text),
                                          );
                                    } else {
                                      context.read<AuthCubit>().loginProvider(
                                            LoginRequest(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text),
                                          );
                                    }
                                  }
                                },
                                label: AppLocalizations.of(context).login),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context).dontHaveAnAccount),
                  TextButton(
                      onPressed: () {
                        if (userType == UserType.user) {
                          Navigator.pushNamed(
                              context, RoutesManager.registerUser);
                        } else {
                          Navigator.pushNamed(
                              context, RoutesManager.registerProvider);
                        }
                      },
                      child: Text(AppLocalizations.of(context).register)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
