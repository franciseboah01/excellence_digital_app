class ApiConstants {
  // URLs
  static const String baseUrl =
      'http://10.0.2.2:8000/api/v1'; // Android Emulator
  // static const String baseUrl = 'http://localhost:8000/api/v1'; // iOS Simulator
  // static const String baseUrl = 'https://api.excellencedigital.ci/api/v1'; // Production

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String user = '/user';
  static const String updateProfile = '/profile';
  static const String updatePassword = '/profile/password';

  // Public
  static const String home = '/home';
  static const String services = '/services';
  static const String formations = '/formations';
  static const String blog = '/blog';
  static const String blogCategories = '/blog/categories';
  static const String faq = '/faq';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String demandeService = '/demande-service';
  static const String search = '/search';
  static const String searchAutocomplete = '/search/autocomplete';

  // Client
  static const String clientDashboard = '/client/dashboard';
  static const String clientFormations = '/client/formations';
  static const String clientFormationsDisponibles =
      '/client/formations/disponibles';
  static String clientInscrireFormation(int formationId) =>
      '/client/formations/$formationId/inscrire';
  static const String clientQcms = '/client/qcms';
  static String clientDemarrerQcm(int qcmId) => '/client/qcms/$qcmId/demarrer';
  static String clientSoumettreQcm(int qcmId) =>
      '/client/qcms/$qcmId/soumettre';
  static const String clientCertificats = '/client/certificats';
  static const String clientDemandes = '/client/demandes';
  static const String clientPaiements = '/client/paiements';
  static const String clientProcessPaiement = '/client/paiements/process';
  static const String clientTemoignages = '/client/temoignages';

  // Notifications & Messages
  static const String notifications = '/notifications';
  static const String notificationsMarkRead = '/notifications/mark-read';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static const String messages = '/messages';
  static String conversation(int userId) => '/messages/$userId';

  // Timeouts
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
