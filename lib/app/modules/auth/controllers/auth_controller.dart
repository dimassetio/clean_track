import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:clean_track/app/data/models/user_model.dart';
import 'package:clean_track/app/routes/app_pages.dart';

AuthController authC = Get.find<AuthController>();

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream<User?> streamAuth() => _auth.authStateChanges();

  var _user = UserModel().obs;
  UserModel get user => _user.value;
  set user(UserModel value) => _user.value = value;

  late Rx<User?> firebaseUser;

  bool get isLoggedIn => firebaseUser.value != null;

  Future<UserModel?> getActiveUser() async {
    try {
      if (_auth.currentUser is User) {
        // if (_auth.currentUser!.emailVerified) {
        var user = await UserModel(id: _auth.currentUser?.uid).getUser();
        return user;
        // } else {
        //   _auth.signOut();
        //   return null;
        // }
      } else {
        return null;
      }
    } on Exception catch (e) {
      printError(info: e.toString());
      return null;
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      return await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
            user.id = value.user?.uid;
            var getUserModel = await user.getUser();
            if (getUserModel == null) {
              await _auth.signOut();
              return "Data user tidak ditemukan";
              // } else if ((!(value.user?.emailVerified ?? false))) {
              //   await value.user!.sendEmailVerification();
              //   await _auth.signOut();
              //   return "Email belum diverifikasi";
            } else if (!(getUserModel.isActive ?? false)) {
              await _auth.signOut();
              return "User tidak aktif";
            } else {
              user = getUserModel;
              return null;
            }
          });
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<UserCredential> createUser(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    String? role,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        var faUser = userCredential.user!;
        UserModel userModel = UserModel(
          id: faUser.uid,
          email: email,
          name: name,
          role: role ?? Role.user,
          isActive: true,
        );
        await userModel.save(isSet: true);
        await faUser.sendEmailVerification();
        return null;
      }
      return "Gagal mendaftarkan user";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Future<User?> signInWithGoogle() async {
  //   _googleSignIn.signOut();
  //   GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //   printInfo(info: "$googleUser");
  //   if (googleUser == null) {
  //     // The user canceled the sign-in
  //     return null;
  //   }

  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   final UserCredential userCredential =
  //       await _auth.signInWithCredential(credential);
  //   return userCredential.user;
  // }

  Future signOut() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.AUTH_LOGIN);
  }

  _streamUser(User? value) {
    try {
      value == null
          ? user = UserModel()
          : _user.bindStream(user.streamByUid(firebaseUser.value?.uid));
    } catch (e) {
      user = UserModel();
      // print(e);
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (error) {
      printError(info: "${error.message}");
      return error.message;
    } catch (e) {
      return e.toString();
    }
  }

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, (callback) => _streamUser);
    _streamUser(firebaseUser.value);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
