import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile {
  late String userId = FirebaseAuth.instance.currentUser!.uid;
  late String fullName = '';
  late String email = '';
  late String contactNumber = '';
  late String profileImageUrl = '';
  late String role = '';
  late String organisation = '';

  static final UserProfile _instance = UserProfile._internal();

  factory UserProfile() {
    return _instance;
  }

  UserProfile._internal() {
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? '';
    fullName = prefs.getString('fullName') ?? '';
    email = prefs.getString('email') ?? '';
    contactNumber = prefs.getString('contactNumber') ?? '';

    // Fetch role and organisation from Firestore
    await loadUserDataFromFirestore();

    // Save profileImageUrl to instance variable
    profileImageUrl = prefs.getString('profileImageUrl') ?? '';

    // Rest of the method remains unchanged
  }

  Future<void> loadUserDataFromFirestore() async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDoc = await users.doc(userId).get();

      role = userDoc['role'];
      organisation = userDoc['organisation'];

      // Save role and organisation to SharedPreferences
      saveRoleAndOrganisationToSharedPreferences();
    } catch (e) {
      print('Error loading user data from Firestore: $e');
    }
  }

  void saveRoleAndOrganisationToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('role', role);
    prefs.setString('organisation', organisation);
  }

  bool isAuthenticated() {
    return email.isNotEmpty;
  }

  String getFullName() {
    return fullName;
  }

  String getEmail() {
    return email;
  }

  String getContactNumber() {
    return contactNumber;
  }

  String getUserId() {
    return userId;
  }

  String getProfileImageUrl() {
    return profileImageUrl;
  }

  String getRole() {
    return role;
  }

  String getOrganisation() {
    return organisation;
  }
}
