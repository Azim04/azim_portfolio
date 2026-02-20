// lib/screens/contact_screen.dart
//
// Mobile-style contact sheet layout.
// Form validation is local; submission delegates to Formspree endpoint
// (no backend needed — just update the FORM_ID constant).
// Success state morphs the submit button into an animated checkmark.
// Social link icons scale/glow on hover for desktop; provide ripple on mobile.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_providers.dart';
import '../theme/colors.dart';
import '../widgets/section_header.dart';

// ── Replace with your Formspree form ID (free tier works) ─────────
const _kFormspreeId = 'YOUR_FORMSPREE_FORM_ID';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    ref.read(contactFormStateProvider.notifier).state =
        ContactFormState.loading;

    try {
      final response = await http.post(
        Uri.parse('https://formspree.io/f/$_kFormspreeId'),
        body: {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'message': _messageController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        ref.read(contactFormStateProvider.notifier).state =
            ContactFormState.success;
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
        // Reset after 4 seconds
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            ref.read(contactFormStateProvider.notifier).state =
                ContactFormState.idle;
          }
        });
      } else {
        ref.read(contactFormStateProvider.notifier).state =
            ContactFormState.error;
      }
    } catch (_) {
      ref.read(contactFormStateProvider.notifier).state =
          ContactFormState.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(screenProvider).isDark;
    final formState = ref.watch(contactFormStateProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.heroGradient
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFFF8F6FF), const Color(0xFFEFF6FF)],
                ),
        ),
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 28),
                    SectionHeader(
                      tag: 'CONTACT',
                      title: "Let's Build Together",
                      subtitle:
                          "Whether it's a Flutter gig, architecture chat, or "
                          "a great idea — my inbox is open.",
                      isDark: isDark,
                    ),
                    const SizedBox(height: 28),

                    // Social links
                    _SocialLinks(isDark: isDark)
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 200.ms)
                        .slideY(begin: 0.2, curve: Curves.easeOut),

                    const SizedBox(height: 28),

                    // Divider label
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: isDark
                                ? AppColors.glassBorder
                                : Colors.grey.shade200,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR SEND A MESSAGE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textMuted
                                  : Colors.grey.shade400,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: isDark
                                ? AppColors.glassBorder
                                : Colors.grey.shade200,
                          ),
                        ),
                      ],
                    ).animate(delay: 400.ms).fadeIn(duration: 400.ms),

                    const SizedBox(height: 24),

                    // Contact form
                    if (formState == ContactFormState.success)
                      _SuccessCard(isDark: isDark)
                          .animate()
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            duration: 500.ms,
                            curve: Curves.elasticOut,
                          )
                          .fadeIn(duration: 300.ms)
                    else
                      _ContactForm(
                        formKey: _formKey,
                        nameController: _nameController,
                        emailController: _emailController,
                        messageController: _messageController,
                        isDark: isDark,
                        formState: formState,
                        onSubmit: _submitForm,
                      ).animate(delay: 500.ms).fadeIn(duration: 500.ms).slideY(
                            begin: 0.2,
                            curve: Curves.easeOut,
                          ),

                    const SizedBox(height: 40),

                    // Footer
                    _Footer(isDark: isDark)
                        .animate(delay: 700.ms)
                        .fadeIn(duration: 500.ms),

                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Social links row ──────────────────────────────────────────────

class _SocialLinks extends StatelessWidget {
  final bool isDark;
  const _SocialLinks({required this.isDark});

  static final _links = [
    _SocialLink(
      icon: FontAwesomeIcons.github,
      label: 'GitHub',
      sublabel: '@Azim04',
      url: 'https://github.com/Azim04',
      color: const Color(0xFF6E40C9),
    ),
    _SocialLink(
      icon: FontAwesomeIcons.linkedin,
      label: 'LinkedIn',
      sublabel: 'azim-shaikh04',
      url: 'https://www.linkedin.com/in/azim-shaikh04/',
      color: const Color(0xFF0A66C2),
    ),
    _SocialLink(
      icon: FontAwesomeIcons.envelope,
      label: 'Email',
      sublabel: '04.shaikh.azim@...',
      url: 'mailto:04.shaikh.azim@gmail.com',
      color: AppColors.accent,
    ),
    _SocialLink(
      icon: FontAwesomeIcons.phone,
      label: 'Phone',
      sublabel: '+91 7776885120',
      url: 'tel:+917776885120',
      color: AppColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: _links
              .asMap()
              .entries
              .map(
                (e) => _SocialCard(
                  link: e.value,
                  isDark: isDark,
                )
                    .animate(delay: Duration(milliseconds: e.key * 80))
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: 0.15, curve: Curves.easeOut),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SocialLink {
  final IconData icon;
  final String label;
  final String sublabel;
  final String url;
  final Color color;

  const _SocialLink({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.url,
    required this.color,
  });
}

class _SocialCard extends StatefulWidget {
  final _SocialLink link;
  final bool isDark;
  const _SocialCard({required this.link, required this.isDark});

  @override
  State<_SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<_SocialCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          // Copy phone/email to clipboard as fallback
          if (widget.link.url.startsWith('tel:')) {
            await Clipboard.setData(
              ClipboardData(text: widget.link.sublabel),
            );
          }
          final uri = Uri.parse(widget.link.url);
          if (await canLaunchUrl(uri)) launchUrl(uri);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..scale(_hovered ? 1.03 : 1.0, _hovered ? 1.03 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: _hovered
                ? widget.link.color.withOpacity(0.1)
                : (widget.isDark ? AppColors.surface : Colors.white),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered
                  ? widget.link.color.withOpacity(0.4)
                  : (widget.isDark
                      ? AppColors.glassBorder
                      : Colors.grey.shade100),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.link.color.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: widget.link.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: FaIcon(
                    widget.link.icon,
                    size: 14,
                    color: widget.link.color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.link.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: widget.isDark
                            ? AppColors.textPrimary
                            : AppColors.textDark,
                      ),
                    ),
                    Text(
                      widget.link.sublabel,
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.isDark
                            ? AppColors.textMuted
                            : Colors.grey.shade400,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Contact form ──────────────────────────────────────────────────

class _ContactForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController messageController;
  final bool isDark;
  final ContactFormState formState;
  final VoidCallback onSubmit;

  const _ContactForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.messageController,
    required this.isDark,
    required this.formState,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FormField(
              controller: nameController,
              label: 'Name',
              hint: 'Your name',
              icon: Icons.person_outline_rounded,
              isDark: isDark,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            _FormField(
              controller: emailController,
              label: 'Email',
              hint: 'your@email.com',
              icon: Icons.email_outlined,
              isDark: isDark,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            _FormField(
              controller: messageController,
              label: 'Message',
              hint: "What's on your mind?",
              icon: Icons.message_outlined,
              isDark: isDark,
              maxLines: 4,
              validator: (v) => v == null || v.trim().length < 10
                  ? 'Message must be at least 10 characters'
                  : null,
            ),
            const SizedBox(height: 22),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: _SubmitButton(
                formState: formState,
                onTap: onSubmit,
              ),
            ),

            if (formState == ContactFormState.error) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.error.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 16, color: AppColors.error),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Failed to send. Check your connection or configure '
                        'Formspree with a valid form ID.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool isDark;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.isDark,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textSecondary : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textPrimary : AppColors.textDark,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: maxLines == 1
                ? Icon(icon, size: 17, color: AppColors.textMuted)
                : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: maxLines > 1 ? 14 : 0,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final ContactFormState formState;
  final VoidCallback onTap;

  const _SubmitButton({
    required this.formState,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = formState == ContactFormState.loading;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.send_rounded, size: 16, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Send Message',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── Success state ─────────────────────────────────────────────────

class _SuccessCard extends StatelessWidget {
  final bool isDark;
  const _SuccessCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success.withOpacity(0.12),
              border: Border.all(
                color: AppColors.success.withOpacity(0.4),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.check_rounded,
                color: AppColors.success,
                size: 32,
              ),
            ),
          ).animate().scale(
                begin: const Offset(0.3, 0.3),
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: 20),
          Text(
            "Message sent! 🎉",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimary : AppColors.textDark,
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          Text(
            "I'll get back to you within 24 hours.",
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textSecondary : Colors.grey.shade500,
            ),
          ).animate(delay: 350.ms).fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}

// ── Footer ────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  final bool isDark;
  const _Footer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: isDark ? AppColors.glassBorder : Colors.grey.shade200,
        ),
        const SizedBox(height: 16),
        Text(
          '© 2025 Azim Shaikh · Built with Flutter',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.textMuted : Colors.grey.shade400,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
