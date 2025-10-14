import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/router.dart';
import '../../../core/utils/responsive.dart';
import '../../auth/state/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _cc = TextEditingController(text: '+91');
  final TextEditingController _phone = TextEditingController(
    text: '8129466718',
  );
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: Responsive.getAllPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Responsive.getSpacing(context)),
            Text(
              'Enter Your\nMobile Number',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: Responsive.getLargeFontSize(context),
              ),
            ),
            SizedBox(height: Responsive.getSpacing(context)),
            Text(
              'Let\'s get started! Enter your mobile number below.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
                fontSize: Responsive.getBodyFontSize(context),
              ),
            ),
            SizedBox(
              height: Responsive.getSpacing(
                context,
                mobile: 20,
                tablet: 24,
                desktop: 28,
              ),
            ),
            Form(
              key: _formKey,
              child: Row(
                children: [
                  SizedBox(
                    width: Responsive.getContainerWidth(
                      context,
                      mobile: 90,
                      tablet: 100,
                      desktop: 110,
                    ),
                    child: TextFormField(
                      controller: _cc,
                      style: TextStyle(
                        fontSize: Responsive.getBodyFontSize(context),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ),
                  SizedBox(width: Responsive.getSpacing(context)),
                  Expanded(
                    child: TextFormField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        fontSize: Responsive.getBodyFontSize(context),
                      ),
                      validator: (v) =>
                          (v == null || v.length < 6) ? 'Invalid' : null,
                      decoration: InputDecoration(
                        hintText: 'Enter Mobile Number',
                        hintStyle: TextStyle(
                          fontSize: Responsive.getBodyFontSize(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: Responsive.getButtonHeight(context),
              child: ElevatedButton(
                onPressed: auth.loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        final ok = await context.read<AuthProvider>().login(
                          countryCode: _cc.text.trim(),
                          phone: _phone.text.trim(),
                        );
                        if (ok && mounted) {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(AppRouter.routeHome);
                        } else if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(auth.error ?? 'Login failed'),
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: Responsive.getBodyFontSize(context),
                  ),
                ),
                child: auth.loading
                    ? SizedBox(
                        height: Responsive.getIconSize(context),
                        width: Responsive.getIconSize(context),
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.getBodyFontSize(context),
                        ),
                      ),
              ),
            ),
            SizedBox(height: Responsive.getSpacing(context)),
          ],
        ),
      ),
    );
  }
}
