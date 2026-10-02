import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/auth_viewmodel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _obscurePassword = true;

  static const Color _navyPrimary = Color(0xFF183661);
  static const Color _bgLight = Color(0xFFF4F6F9);

  // Direct image URL extracted from your Google link
  // Google's direct unblocked server link for your exact image (tbnid: MdVeiXHnh5OYKM)
  static const String _heroImageUrl =
      'https://res.cloudinary.com/nwvgdxul/image/upload/f_auto/q_auto/login_page_image.jpg';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showHelpSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Login Help & Support",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.lock_reset, color: _navyPrimary),
              title: Text("Trouble signing in?"),
              subtitle: Text(
                "Use Google or GitHub Sign-In for instant 1-tap campus access.",
              ),
            ),
            ListTile(
              leading: Icon(Icons.support_agent, color: Colors.blue),
              title: Text("Contact Campus Support"),
              subtitle: Text("support@xalecampus.in"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVM = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: _bgLight,
      body: SafeArea(
        child: Stack(
          children: [
            // Top Half-Vanishing Marketplace Banner (Higher Opacity & Vibrant Gradient)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 310,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white, // Top par clear aur vibrant
                      Colors.white, // Beech tak poora visible
                      Colors.transparent, // Niche smooth fade
                    ],
                    stops: [0.0, 0.65, 1.0],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Opacity(
                  opacity: 0.60, // <-- Opacity boosted from 0.35 to 0.60 for rich colors
                  child: Image.network(
                    _heroImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),

            // Bottom-Left Decorative Navy Corner
            Positioned(
              bottom: -50,
              left: -50,
              child: Transform.rotate(
                angle: 0.6,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: _navyPrimary,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                ),
              ),
            ),

            // Bottom-Right Watermark
            const Positioned(
              bottom: 20,
              right: 24,
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(-6 / 360),
                child: Text(
                  "Your Campus,\nYour Marketplace",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // SafeArea Wrapped Interactive Content (Status Bar Clash Fixed)
            SafeArea(
              child: Stack(
                children: [
                  // Top-Right Help Button (Safely below status bar)
                  Positioned(
                    top: 8,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: const Icon(
                          Icons.help_outline_rounded,
                          color: _navyPrimary,
                        ),
                        onPressed: _showHelpSheet,
                      ),
                    ),
                  ),

                  // Main Centered Login Content
                  Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              size: 54,
                              color: _navyPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "XALE",
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              color: _navyPrimary,
                              letterSpacing: 2,
                            ),
                          ),
                          const Text(
                            "CAMPUS MARKETPLACE",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2C4C7E),
                              letterSpacing: 2.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 45,
                            height: 3.5,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Connect   •   Buy   •   Sell   •   Grow",
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF334155),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Form Card
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFF4A6583),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF7F9FC),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    prefixIcon: const Icon(
                                      Icons.lock_outline_rounded,
                                      color: Color(0xFF4A6583),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: const Color(0xFF4A6583),
                                      ),
                                      onPressed: () => setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF7F9FC),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Sign In Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: authVM.isLoading
                                        ? null
                                        : () {
                                            final email = _emailController.text
                                                .trim();
                                            final pass = _passwordController
                                                .text
                                                .trim();
                                            if (_isLogin) {
                                              authVM.signIn(
                                                email: email,
                                                password: pass,
                                              );
                                            } else {
                                              authVM.signUp(
                                                email: email,
                                                password: pass,
                                              );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _navyPrimary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: authVM.isLoading
                                        ? const SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                _isLogin
                                                    ? "Sign In"
                                                    : "Sign Up",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.arrow_forward_rounded,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        "OR",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Google Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: OutlinedButton.icon(
                                    onPressed: () => authVM.signInWithGoogle(),
                                    icon: Image.network(
                                      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/120px-Google_%22G%22_logo.svg.png',
                                      height: 22,
                                      errorBuilder: (_, _, _) => const Icon(
                                        Icons.g_mobiledata,
                                        size: 28,
                                        color: Colors.red,
                                      ),
                                    ),
                                    label: const Text(
                                      "Continue with Google",
                                      style: TextStyle(
                                        color: Color(0xFF1E293B),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF8FAFC),
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // GitHub Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: OutlinedButton.icon(
                                    onPressed: () => authVM.signInWithGitHub(),
                                    icon: Image.network(
                                      'https://cdn-icons-png.flaticon.com/512/25/25231.png',
                                      height: 22,
                                      errorBuilder: (_, _, _) => const Icon(
                                        Icons.code,
                                        color: Colors.black,
                                      ),
                                    ),
                                    label: const Text(
                                      "Continue with GitHub",
                                      style: TextStyle(
                                        color: Color(0xFF1E293B),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF8FAFC),
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _isLogin
                                          ? "Don't have an account? "
                                          : "Already have an account? ",
                                      style: const TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          setState(() => _isLogin = !_isLogin),
                                      child: Text(
                                        _isLogin ? "Sign Up" : "Sign In",
                                        style: const TextStyle(
                                          color: Color(0xFF0056D2),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
