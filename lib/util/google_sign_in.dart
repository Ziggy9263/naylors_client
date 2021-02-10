import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:naylors_client/models/models.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<AuthInfo> signInWithGoogle() async {
  await Firebase.initializeApp();

  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  if (user != null) {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoURL != null);
    String token = await user.getIdToken(true);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle Succeeded: $user');

    AuthInfo authInfo =
        new AuthInfo(token: token, email: user.email, isAdmin: false);

    return authInfo;
  }

  return null;
}

Future<void> signOutGoogle() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  await googleSignIn.signOut();

  print('signOutOfGoogle Succeeded');
}
