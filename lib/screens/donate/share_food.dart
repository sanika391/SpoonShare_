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
import 'package:spoonshare/widgets/auto_complete.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';
import 'package:spoonshare/widgets/custom_text_field.dart';
import 'package:spoonshare/widgets/loader.dart';
import 'package:spoonshare/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

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
  bool _isActive = false;
  late double lat;
  late double lng;
  bool _addressSelected = false;

  String tokenForSession = "12345";
  List<Map<String, dynamic>> listForPlaces = [];
  var uuid = const Uuid();

  Future<void> makeSuggestions(String input) async {
    try {
      var suggestions = await PlaceApi.getSuggestions(input);
      setState(() {
        listForPlaces = suggestions;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _addressController.addListener(onModify);
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void onModify() {
    if (tokenForSession.isEmpty) {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }
    makeSuggestions(_addressController.text);
  }

  Future<void> handleListItemTap(int index) async {
    String placeId = listForPlaces[index]['place_id'];
    var placeDetails = await PlaceApi.getPlaceDetails(placeId);
    double selectedLat = placeDetails['geometry']['location']['lat'];
    double selectedLng = placeDetails['geometry']['location']['lng'];
    String selectedAddress = listForPlaces[index]['description'];
    print(selectedAddress);
    print(selectedLat);
    print(selectedLng);

    setState(() {
      _addressController.text = selectedAddress;
      lat =
          selectedLat; // Update the class-level variables with the selected values
      lng = selectedLng;
      _addressSelected = true; // Set _addressSelected to true
    });
  }

    @override
  Widget build(BuildContext context) {
    bool showExpandedList =
        _addressController.text.isNotEmpty && !_addressSelected;

    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildImageUploadBox(),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Venue*',
                controller: _venueController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Enter Address*',
                controller: _addressController,
              ),
              if (showExpandedList)
                Container(
                  height: 200, // Set the height of the suggestions container
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: listForPlaces.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          _addressSelected = true;
                          await handleListItemTap(index);
                        },
                        title: Text(
                          listForPlaces[index]['description'],
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'For whom it is? (Community)*',
                controller: _communityController,
              ),
              const SizedBox(height: 16),
              _buildDateAndTimeInputs(context),
              const SizedBox(height: 16),
              _buildDropdownInput(),
              const SizedBox(height: 16),
              _buildDailyActivityCheckbox(),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildDailyActivityCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _isActive,
          onChanged: (value) {
            setState(() {
              _isActive = value!;
            });
          },
        ),
        const Text('Daily Active'),
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
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                child: TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate =
                        await _selectDate(context, _dateController);
                    if (selectedDate != null) {
                      _dateController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Select Date*',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF9F1C),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF9F1C),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                child: TextFormField(
                  controller: _timeController,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? selectedTime =
                        await _selectTime(context, _timeController);
                    if (selectedTime != null) {
                      _timeController.text = selectedTime.format(context);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Select Time*',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF9F1C),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF9F1C),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                child: TextFormField(
                  controller: _toDateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate =
                        await _selectDate(context, _toDateController);
                    if (selectedDate != null) {
                      _toDateController.text =
                          selectedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Select Date*',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF9F1C),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF9F1C),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                child: TextFormField(
                  controller: _toTimeController,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? selectedTime =
                        await _selectTime(context, _toTimeController);
                    if (selectedTime != null) {
                      _toTimeController.text = selectedTime.format(context);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Select Time*',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF9F1C),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFFF9F1C),
                      ),
                    ),
                  ),
                ),
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
        color: const Color(0xFFFF9F1C),
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
    if (_imageFile == null ||
        _selectedFoodType.isEmpty ||
        _venueController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _communityController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _toDateController.text.isEmpty ||
        _toTimeController.text.isEmpty) {
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

      // Determine the daily active status
      bool dailyActive = _isActive;

    // Create a GeoPoint with the latitude and longitude
      GeoPoint location = GeoPoint(lat, lng);


      // Create a map with food details, including a timestamp
      Map<String, dynamic> foodData = {
        'userId': userId,
        'fullName': fullName,
        'imageUrl': imageUrl,
        'venue': venue,
        'address': address,
        'location': location,
        'community': community,
        'foodType': _selectedFoodType,
        'date': date,
        'time': time,
        'toDate': toDate,
        'toTime': toTime,
        'dailyActive': dailyActive,
        'verified': false,
        'timestamp': FieldValue.serverTimestamp(),
      };
      // Save food data under the user's document in the 'sharedFood' collection
      await FirebaseFirestore.instance
          .collection('food')
          .doc('sharedfood')
          .collection("foodData")
          .add(foodData);

      // Show success message
      showSuccessSnackbar(context, 'Food submitted successfully!');
      // Navigate to thank you screen
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ThankYouScreen()));
    } catch (e) {
      print('Error submitting food: $e');
      showErrorSnackbar(context, 'Error submitting food');
    } finally {
      // Clear text controllers and reset selected food type
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonFormField<String>(
          value: _selectedFoodType.isNotEmpty ? _selectedFoodType : null,
          hint: const Text('Food Type'),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Color(0xFFFF9F1C),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Color(0xFFFF9F1C),
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _selectedFoodType = value!;
            });
          },
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

class ShareFoodScreen extends StatelessWidget {
  const ShareFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Free Food'),
        backgroundColor: const Color(0xFFFF9F1C),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Lora',
            fontSize: 18,
            fontWeight: FontWeight.w700),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              ShareFoodScreenContent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
