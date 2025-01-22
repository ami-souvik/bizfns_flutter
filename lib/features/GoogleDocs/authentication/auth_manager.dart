import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/documents.readonly',
    'https://www.googleapis.com/auth/drive.readonly',
    'https://www.googleapis.com/auth/documents',
    'https://www.googleapis.com/auth/drive.file',
    'https://www.googleapis.com/auth/drive'
  ],
);

class AuthManager {
  static Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      print('account: ${account?.toString()}');
      return account;
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<GoogleSignInAccount?> signInSilently() async {
    try{
      var account = await _googleSignIn.signInSilently();
      print('account: $account');
      return account;
    }catch(e, stackTrace){
      print('$e $stackTrace');
      return null;
    }
  }

  static Future<void> signOut() async {
    try {
      _googleSignIn.disconnect();
    } catch (error) {
      print(error);
    }
  }
}
