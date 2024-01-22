// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spoonshare/models/users/user.dart';
import 'package:spoonshare/screens/donate/thank_you.dart';
import 'package:spoonshare/widgets/custom_text_field.dart';
import 'package:spoonshare/widgets/loader.dart';
import 'package:spoonshare/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ShareFoodScreenContent extends StatefulWidget {
  @override
  _ShareFoodScreenContentState createState() => _ShareFoodScreenContentState();
}

class _ShareFoodScreenContentState extends State<ShareFoodScreenContent> {
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _communityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();

  File? _imageFile;
  String _selectedFoodType = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildImageUploadBox(),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Venue',
          controller: _venueController,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Enter Address',
          controller: _addressController,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'For whom it is? (Commuity)',
          controller: _communityController,
        ),
        const SizedBox(height: 16),
        _buildDateAndTimeInputs(context),
        const SizedBox(height: 16),
        _buildDropdownInput(),
        const SizedBox(height: 16),
        _buildSubmitButton(),
      ],
    );
  }

Widget _buildDateAndTimeInputs(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('From Date'),
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate = await _selectDate(context, _dateController);
                    if (selectedDate != null) {
                      _dateController.text = selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Select Date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('From Time'),
                TextField(
                  controller: _timeController,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? selectedTime = await _selectTime(context, _timeController);
                    if (selectedTime != null) {
                      _timeController.text = selectedTime.format(context);
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Select Time',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('To Date'),
                TextField(
                  controller: _toDateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate = await _selectDate(context, _toDateController);
                    if (selectedDate != null) {
                      _toDateController.text = selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Select Date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('To Time'),
                TextField(
                  controller: _toTimeController,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? selectedTime = await _selectTime(context, _toTimeController);
                    if (selectedTime != null) {
                      _toTimeController.text = selectedTime.format(context);
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Select Time',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

Future<DateTime?> _selectDate(
    BuildContext context, TextEditingController controller) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );

  if (picked != null) {
    controller.text = picked.toLocal().toString().split(' ')[0];
  }

  return picked;
}

Future<TimeOfDay?> _selectTime(
    BuildContext context, TextEditingController controller) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (picked != null) {
    controller.text = picked.format(context);
  }

  return picked;
}

  Widget _buildImageUploadBox() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              pickFile();
            },
            child: Container(
              width: 280,
              height: 180,
              decoration: ShapeDecoration(
                color: Colors.black.withOpacity(0.07999999821186066),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Colors.black.withOpacity(0.6000000238418579),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _imageFile == null
                  ? const Icon(
                      Icons.camera_alt,
                      size: 48,
                      color: Colors.grey,
                    )
                  : Image.file(
                      _imageFile!,
                      width: 48, // Adjust the size as needed
                      height: 48, // Adjust the size as needed
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '* Fill below details to share food',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickFile() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    late final Map<Permission, PermissionStatus> status;
    if (androidInfo.version.sdkInt <= 32) {
      status = await [
        Permission.storage,
        Permission
            .camera, // Request camera permission for devices with SDK <= 32
      ].request();
    } else {
      status = await [
        Permission.photos,
        Permission.camera,
        Permission.notification,
      ].request();
    }

    var allAccepted = true;
    status.forEach((permission, status) {
      if (status != PermissionStatus.granted) {
        allAccepted = false;
      }
    });

    if (allAccepted) {
      // Show options for gallery or camera
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Pick from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Capture with Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.camera);
                },
              ),
            ],
          );
        },
      );
    } else {
      print('Storage or camera permission denied');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: source,
    );

    if (pickedImage != null) {
      _imageFile = File(pickedImage.path);
      _imageController.text = _imageFile!.path;
      setState(() {});
    }
  }

  Widget _buildSubmitButton() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.8667,
      height: screenHeight * 0.05625,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(50),
      ),
      child: InkWell(
        onTap: () {
          submitFood();
        },
        child: const Center(
          child: Text(
            'Submit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              letterSpacing: 0.36,
            ),
          ),
        ),
      ),
    );
  }

  void submitFood() async {
    // Check if all required fields are filled
    if (_imageFile == null || _selectedFoodType.isEmpty) {
      // Show an error message to the user
      showErrorSnackbar(context, 'Please fill all required fields');
      return;
    }

    try {
      showLoadingDialog(context);

      String userId = FirebaseAuth.instance.currentUser!.uid;
      UserProfile userProfile = UserProfile();
      String fullName = userProfile.getFullName();
      String venue = _venueController.text;
      String address = _addressController.text;
      String community = _communityController.text;
      String date = _dateController.text;
      String time = _timeController.text;
      String toDate = _toDateController.text;
      String toTime = _toTimeController.text;

      // Upload the image to Firebase Storage
      String imageUrl = await uploadImageToFirebaseStorage(_imageFile, venue);

      // Create a map with food details, including a timestamp
      Map<String, dynamic> foodData = {
        'userId': userId,
        'fullName': fullName,
        'imageUrl': imageUrl,
        'venue': venue,
        'address': address,
        'community': community,
        'foodType': _selectedFoodType,
        'date': date,
        'time': time,
        'toDate': toDate,
        'toTime': toTime,
        'timestamp': FieldValue.serverTimestamp(),
      };
      // Save food data under the user's document in the 'sharedFood' collection
      await FirebaseFirestore.instance
          .collection('food')
          .doc('sharedfood')
          .collection("foodData")
          .add(foodData);

      Navigator.of(context).pop();
      showSuccessSnackbar(context, 'Food submitted successfully!');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ThankYouScreen()));
    } catch (e) {
      print('Error submitting food: $e');
      showErrorSnackbar(context, 'Error submitting food');
    } finally {
      _venueController.clear();
      _addressController.clear();
      _communityController.clear();
      _imageController.clear();
      _dateController.clear();
      _timeController.clear();
      _toDateController.clear();
      _toTimeController.clear();
      _imageFile = null;

      setState(() {
        _selectedFoodType = '';
      });
    }
  }

  Widget _buildDropdownInput() {
    return Container(
      width: double.infinity,
      height: 46,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.30,
            color: Colors.black.withOpacity(0.6000000238418579),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButton<String>(
          items: const [
            DropdownMenuItem<String>(
              value: 'veg',
              child: Text('Veg'),
            ),
            DropdownMenuItem<String>(
              value: 'nonveg',
              child: Text('Non-Veg'),
            ),
            DropdownMenuItem<String>(
              value: 'both',
              child: Text('Both'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedFoodType = value!;
            });
          },
          value: _selectedFoodType.isNotEmpty ? _selectedFoodType : null,
          hint: const Text('Food Type'),
          style: const TextStyle(color: Colors.black),
          isExpanded: true,
        ),
      ),
    );
  }

  Future<String> uploadImageToFirebaseStorage(
      File? imageFile, String venue) async {
    if (imageFile == null) {
      throw Exception('Image file is null');
    }

    try {
      String fileName = 'food/shared_food/$venue.jpg';

      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);

      await storageReference.putFile(imageFile);

      String downloadURL = await storageReference.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      throw Exception('Error uploading image to Firebase Storage');
    }
  }
}
