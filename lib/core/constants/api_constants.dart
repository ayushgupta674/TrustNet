// lib/core/network/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'http://10.176.0.105:8080'; // Replace with your actual IP/domain

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';

  // NGO
  static const String ngoProfile = '/ngo/profile';
  static const String ngoSearch = '/ngo/search';
  static const String ngoNearby = '/ngo/nearby';

  // Campaigns
  static const String campaigns = '/campaigns';
  static const String campaignProof = '/proof';
  static const String campaignOutcome = '/outcome';
  static const String campaignTransparency = '/transparency';



  // Posts
  static const String posts = '/posts';
  static const String feed = '/posts/feed';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationsCount = '/notifications/count';
  static const String notificationsRead = '/notifications/read';

  // Volunteer
  static const String volunteerPosts = '/volunteer/posts';
  static const String volunteerApply = '/apply';

  // Reports (Fraud)
  static const String reports = '/reports';


  // Admin
  static const String adminVerifications = '/admin/verifications';
  static const String adminAnalytics = '/admin/analytics';

  static const String adminReports = '/reports/admin';


  // Donations

  static const String donationsInitiate = '/donations/initiate';
  static const String donationsVerify = '/donations/verify';
  static const String donationReceipt = '/donations';

  // lib/core/constants/api_constants.dart
// ... existing ...

// Post interactions
  // lib/core/constants/api_constants.dart

  static const String likePost = '/posts';      // will append /{postId}/like
  static const String comments = '/posts';      // will append /{postId}/comments
  static const String deleteComment = '/comments';

}