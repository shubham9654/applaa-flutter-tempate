import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

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
          'Privacy Policy',
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
                      Icons.privacy_tip,
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
                          'Privacy Policy',
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

            // Introduction
            _buildSection(
              'Introduction',
              'At Applaa, we take your privacy seriously. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application. Please read this privacy policy carefully.',
            ),

            // Content
            _buildSection(
              '1. Information We Collect',
              'We may collect information about you in a variety of ways. The information we may collect includes:\n\n• Personal Data: Name, email address, phone number, and other contact information you voluntarily provide\n• Derivative Data: Information automatically collected when you use our app, such as device information and usage statistics\n• Financial Data: Payment information processed securely through third-party payment processors\n• Geolocation Data: Location information if you grant permission',
            ),
            _buildSection(
              '2. How We Use Your Information',
              'We use the information we collect or receive to:\n\n• Create and manage your account\n• Process your transactions\n• Improve our services and user experience\n• Send you updates and promotional materials\n• Monitor and analyze usage and trends\n• Prevent fraudulent transactions and protect against criminal activity\n• Respond to customer service requests\n• Comply with legal obligations',
            ),
            _buildSection(
              '3. Disclosure of Your Information',
              'We may share information we have collected about you in certain situations:\n\n• By Law or to Protect Rights: If required by law or to protect our rights\n• Third-Party Service Providers: With service providers that perform services on our behalf\n• Business Transfers: In connection with mergers, sales, or acquisitions\n• With Your Consent: When you have given us explicit permission',
            ),
            _buildSection(
              '4. Data Security',
              'We use administrative, technical, and physical security measures to protect your personal information. While we have taken reasonable steps to secure the information you provide, please be aware that no security measures are perfect or impenetrable.',
            ),
            _buildSection(
              '5. Your Privacy Rights',
              'Depending on your location, you may have certain rights regarding your personal information:\n\n• Access: Request access to your personal data\n• Correction: Request correction of inaccurate data\n• Deletion: Request deletion of your personal data\n• Objection: Object to processing of your data\n• Data Portability: Request transfer of your data\n• Withdraw Consent: Withdraw previously given consent',
            ),
            _buildSection(
              '6. Cookies and Tracking Technologies',
              'We may use cookies and similar tracking technologies to track activity on our Service and hold certain information. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent.',
            ),
            _buildSection(
              '7. Third-Party Services',
              'We may use third-party service providers to help us operate our business:\n\n• Analytics providers (e.g., Google Analytics)\n• Payment processors (e.g., Stripe, PayPal)\n• Cloud storage providers\n• Authentication services (e.g., Firebase)\n• Advertising partners\n\nThese third parties have their own privacy policies.',
            ),
            _buildSection(
              '8. Children\'s Privacy',
              'Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.',
            ),
            _buildSection(
              '9. International Data Transfers',
              'Your information may be transferred to and maintained on computers located outside of your state, province, country, or other governmental jurisdiction where data protection laws may differ.',
            ),
            _buildSection(
              '10. Data Retention',
              'We will retain your personal information only for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required by law.',
            ),
            _buildSection(
              '11. Changes to This Privacy Policy',
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.',
            ),
            _buildSection(
              '12. Contact Us',
              'If you have questions or comments about this Privacy Policy, please contact us at:\n\nEmail: privacy@applaa.com\nWebsite: www.applaa.com\nAddress: [Your Company Address]',
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
                    Icons.shield_outlined,
                    color: const Color(0xFF6C5CE7),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your privacy is important to us. We are committed to protecting your personal information.',
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

