import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C5CE7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.description,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Last updated: December 3, 2025',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Content
            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using Applaa, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by these terms, please do not use this service.',
            ),
            _buildSection(
              '2. Use License',
              'Permission is granted to temporarily use Applaa for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n• Modify or copy the materials\n• Use the materials for any commercial purpose\n• Attempt to decompile or reverse engineer any software\n• Remove any copyright or proprietary notations\n• Transfer the materials to another person',
            ),
            _buildSection(
              '3. User Account',
              'When you create an account with us, you must provide accurate, complete, and up-to-date information. Failure to do so constitutes a breach of the Terms. You are responsible for safeguarding your password and any activities or actions under your account.',
            ),
            _buildSection(
              '4. Privacy Policy',
              'Your use of Applaa is also governed by our Privacy Policy. Please review our Privacy Policy to understand our practices regarding your personal data.',
            ),
            _buildSection(
              '5. Content',
              'Our Service allows you to post, link, store, share and otherwise make available certain information, text, graphics, or other material. You are responsible for the content that you post to the Service, including its legality, reliability, and appropriateness.',
            ),
            _buildSection(
              '6. Prohibited Uses',
              'You may not use Applaa:\n\n• In any way that violates applicable laws or regulations\n• To transmit advertising or promotional material\n• To impersonate or attempt to impersonate the Company or another user\n• In any way that infringes upon the rights of others\n• To engage in any conduct that restricts or inhibits anyone\'s use of the Service',
            ),
            _buildSection(
              '7. Termination',
              'We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms. Upon termination, your right to use the Service will immediately cease.',
            ),
            _buildSection(
              '8. Limitation of Liability',
              'In no event shall Applaa, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.',
            ),
            _buildSection(
              '9. Changes to Terms',
              'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will try to provide at least 30 days notice prior to any new terms taking effect.',
            ),
            _buildSection(
              '10. Contact Us',
              'If you have any questions about these Terms, please contact us at:\n\nEmail: support@applaa.com\nWebsite: www.applaa.com',
            ),

            const SizedBox(height: 32),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: const Color(0xFF6C5CE7),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'By using Applaa, you acknowledge that you have read and understood these Terms & Conditions.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

