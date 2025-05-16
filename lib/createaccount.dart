import 'package:flutter/material.dart';
import 'package:lifeplan/validateInput/Validation.dart';
import 'package:lifeplan/db/dbsetup.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});
  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final LifeplanDatabase db = LifeplanDatabase();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  String success = '';
  Color successColor = Colors.black;

  bool validInput() =>
      emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmController.text.isNotEmpty;

  Future<void> inputSuccess() async {
    if (!validInput()) {
      setState(() {
        success = 'Please fill all fields!';
        successColor = Colors.red;
      });
      return;
    }
    if (!Validation.validPasswordLength(passwordController.text)) {
      setState(() {
        success = 'Password needs minimum 12 characters!';
        successColor = Colors.red;
      });
      return;
    }
    if (!Validation.validConfirmPassword(
        passwordController.text, confirmController.text)) {
      setState(() {
        success = 'Passwords do not match!';
        successColor = Colors.red;
      });
      return;
    }
    bool codeSent = await db.registerAndSendCode(
        emailController.text, passwordController.text);
    setState(() {
      success = codeSent
          ? 'Verification code sent to your email'
          : 'Invalid input!';
      successColor = codeSent ? Colors.green : Colors.red;
    });
  }

  Future<void> verifiedAccount() async {
    bool verified = await db.verifyUserAndAdd();
    if (verified) {
      Navigator.pushNamed(context, '/companiongender');
    } else {
      setState(() {
        success = 'Email has not been validated!';
        successColor = Colors.red;
      });
    }
  }

  static const Color bgTeal = Color(0xFFCDE7EF);
  static const Color appBarGrey = Color(0xFFB0B0B0);
  static const Color iconGrey = Color(0xFF4A4A4A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgTeal,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: appBarGrey,
        iconTheme: IconThemeData(color: iconGrey),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              'Get started with LifePlan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: iconGrey,
              ),
            ),
            const SizedBox(height: 24),

            // Email
            _inputField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              iconColor: iconGrey,
            ),
            const SizedBox(height: 16),

            // Password
            _inputField(
              controller: passwordController,
              label: 'Password',
              icon: Icons.lock_outline,
              iconColor: iconGrey,
              obscure: true,
            ),
            const SizedBox(height: 16),

            // Confirm
            _inputField(
              controller: confirmController,
              label: 'Confirm Password',
              icon: Icons.lock_outline,
              iconColor: iconGrey,
              obscure: true,
            ),
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: verifiedAccount,
                child: Text(
                  'Check Email Verification',
                  style: TextStyle(
                      color: iconGrey, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              success,
              textAlign: TextAlign.center,
              style: TextStyle(color: successColor, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            // Sign Up
            _actionButton(
              label: 'Sign Up',
              bgColor: appBarGrey,
              textColor: Colors.white,
              onTap: inputSuccess,
            ),
            const SizedBox(height: 12),
            // Already have
            _actionButton(
              label: 'Already have an account?',
              bgColor: Colors.white,
              textColor: appBarGrey,
              outline: true,
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color iconColor,
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: iconColor),
          hintText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
    bool outline = false,
  }) {
    return SizedBox(
      height: 48,
      child: outline
          ? OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: bgColor),
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(label,
            style: TextStyle(color: textColor, fontSize: 16)),
      )
          : ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child:
        Text(label, style: TextStyle(color: textColor, fontSize: 16)),
      ),
    );
  }
}
