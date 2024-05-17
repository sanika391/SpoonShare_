// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoonshare/models/users/user.dart';
import 'package:spoonshare/screens/volunteer/volunteer_form.dart';
import 'package:spoonshare/services/auth.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spoonshare/widgets/loader.dart';
import 'package:spoonshare/widgets/snackbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    Key? key,
    required this.name,
    required this.role,
  }) : super(key: key);

  final String name;
  final String role;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isEditing = false;
  AuthService authService = AuthService();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController contactController;
  late TextEditingController orgController;
  late TextEditingController roleController;
  late TextEditingController profileImageController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    contactController = TextEditingController();
    orgController = TextEditingController();
    roleController = TextEditingController();
    profileImageController = TextEditingController();
    loadUserProfileData();
  }

  Future<void> loadUserProfileData() async {
    UserProfile userProfile = UserProfile();
    await userProfile.loadUserProfile();

    setState(() {
      nameController.text = widget.name;
      emailController.text = userProfile.getEmail();
      contactController.text = userProfile.getContactNumber();
      orgController.text = userProfile.getOrganisation();
      roleController.text = userProfile.getRole();
      profileImageController.text = userProfile.getProfileImageUrl();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello👋 ${widget.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Lora',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.role,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 16,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                          height: 0,
                          letterSpacing: 1.68,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFF9F1C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.logout),
                          color: Colors.white,
                          onPressed: () {
                            authService.signOut(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.black.withOpacity(0.1),
                    ),
                    borderRadius:
                        BorderRadius.circular(15), // Added border radius
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: SizedBox(
                  width: 312,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center content
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: Colors.black.withOpacity(0.1),
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: profileImageController
                                      .text.isNotEmpty
                                  ? NetworkImage(profileImageController.text)
                                  : const NetworkImage(
                                      "https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2264922221.jpg",
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    await pickFile();
                                  }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: 350,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.info_outline),
                                const SizedBox(width: 8),
                                const Text(
                                  'Personal Information',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Spacer(),
                                isEditing
                                    ? Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.cancel),
                                            onPressed: () {
                                              setState(() {
                                                isEditing = false;
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.check),
                                            onPressed: () {
                                              setState(() {
                                                isEditing = false;
                                              });
                                            },
                                          ),
                                        ],
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          setState(() {
                                            isEditing = true;
                                          });
                                        },
                                      ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                            const SizedBox(height: 16),
                            buildEditableField(
                              'Name / नाम',
                              nameController,
                              TextInputType.text,
                            ),
                            const SizedBox(height: 16),
                            buildEditableField(
                              'Email / ईमेल',
                              emailController,
                              TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            buildEditableField(
                              'Contact / संपर्क',
                              contactController,
                              TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            if (isEditing)
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isEditing = false;
                                  });
                                  await updateUserProfile();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black,
                                ),
                                child: const Text('Submit'),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        width: 325,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.info_outline),
                                SizedBox(width: 8),
                                Text(
                                  'Organisation Information',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                /* const Spacer(),
                                isEditing
                                    ? Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.cancel),
                                            onPressed: () {
                                              setState(() {
                                                isEditing = false;
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.check),
                                            onPressed: () {
                                              setState(() {
                                                isEditing = false;
                                              });
                                            },
                                          ),
                                        ],
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          setState(() {
                                            isEditing = true;
                                          });
                                        },
                                      ), 
                              */
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.black.withOpacity(0.2),
                            ),
                            const SizedBox(height: 16),
                            buildEditableField(
                              'Organisation',
                              orgController,
                              TextInputType.text,
                            ),
                            const SizedBox(height: 16),
                            buildEditableField(
                              'Role',
                              roleController,
                              TextInputType.text,
                            ),
                            const SizedBox(height: 16),
                            if (isEditing)
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isEditing = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black,
                                ),
                                child: const Text('Submit'),
                              ),
                            if (widget.role == 'Individual')
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const VolunteerFormScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black,
                                ),
                                child: const Text('Become A Volunteer'),
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
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget buildEditableField(
    String label,
    TextEditingController controller,
    TextInputType keyboardType,
  ) {
    return isEditing
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.4),
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                controller.text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );
  }

  Future<void> pickFile() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    late final Map<Permission, PermissionStatus> status;
    if (androidInfo.version.sdkInt <= 32) {
      status = await [
        Permission.storage,
      ].request();
    } else {
      status = await [Permission.photos, Permission.notification].request();
    }

    var allAccepted = true;
    status.forEach((permission, status) {
      if (status != PermissionStatus.granted) {
        allAccepted = false;
      }
    });

    if (allAccepted) {
      XFile? pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage != null) {
        File imageFile = File(pickedImage.path);

        // Assuming you have a function to get the current user ID
        String userId = FirebaseAuth.instance.currentUser!.uid;

        // Upload the image to Firebase Storage
        String imageUrl = await uploadImageToFirebaseStorage(imageFile, userId);

        // Update the profile image URL
        updateProfileImage(imageUrl);

        showSuccessSnackbar(context, "Profile Image Upload successfully!");
      }
    } else {
      showErrorSnackbar(context, 'Storage permission denied');
      print('Storage permission denied');
    }
  }

  Future<String> uploadImageToFirebaseStorage(
      File imageFile, String userId) async {
    try {
      showLoadingDialog(context);

      String fileName = 'profile_$userId.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('users/profileImages/$fileName');

      await storageReference.putFile(imageFile);

      String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return '';
    } finally {
      Navigator.pop(context);
    }
  }

  Future<void> updateProfileImage(String imageUrl) async {
    UserProfile userProfile = UserProfile();

    try {
      showLoadingDialog(context);

      setState(() {
        userProfile.profileImageUrl = imageUrl;
        profileImageController.text = imageUrl;
      });

      // Update in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('profileImageUrl', imageUrl);

      // Assuming you have a Firestore collection named 'users'
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Perform the update
      await users.doc(userId).update({
        'profileImageUrl': imageUrl,
      });

      showSuccessSnackbar(context, "Profile image updated successfully!");

      print("Profile image updated successfully!");
    } catch (e) {
      // Handle the exception
      showErrorSnackbar(context, "Error updating profile image: $e");
      print("Error updating profile image: $e");
    } finally {
      Navigator.pop(context);
    }
  }

  Future<void> updateUserProfile() async {
    UserProfile userProfile = UserProfile();
    showLoadingDialog(context); // Show loader
    try {
      // Update locally
      setState(() {
        userProfile.fullName = nameController.text;
        userProfile.email = emailController.text;
        userProfile.contactNumber = contactController.text;
      });

      // Update in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('fullName', nameController.text);
      prefs.setString('email', emailController.text);
      prefs.setString('contactNumber', contactController.text);

      // Assuming you have a Firestore collection named 'users'
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Perform the update
      await users.doc(userId).update({
        'fullName': nameController.text,
        'email': emailController.text,
        'contactNumber': contactController.text,
      });

      print("Updated successfully!");
    } catch (e) {
      print("Error updating user profile: $e");
    } finally {
      Navigator.pop(context); // Dismiss loader
    }
  }

/*  Future<void> updateOrganisationAndRole() async {
    UserProfile userProfile = UserProfile();

    setState(() {
      userProfile.organisation = orgController.text;
      userProfile.role = roleController.text;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('organisation', orgController.text);
    prefs.setString('role', roleController.text);

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    String userId = FirebaseAuth.instance.currentUser!.uid;

    await users.doc(userId).update({
      'organisation': orgController.text,
      'role': roleController.text,
    });

    print("Organisation and role updated successfully!");
  }*/
}
