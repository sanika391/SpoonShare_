import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spoonshare/models/users/user.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';
import 'package:spoonshare/widgets/custom_text_field.dart';

class NGO {
  final String name;
  final String description;

  NGO(this.name, this.description);

  @override
  String toString() {
    return name;
  }
}

class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({Key? key}) : super(key: key);

  @override
  _VolunteerScreenState createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final GlobalKey<FormFieldState<NGO?>> _ngoKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Fetch user profile data
    fetchUserProfileData();
  }

  Future<void> fetchUserProfileData() async {
    // Initialize UserProfile instance
    UserProfile userProfile = UserProfile();

    // Load user profile data
    await userProfile.loadUserProfile();

    // Set text controllers with fetched data
    setState(() {
      _fullNameController.text = userProfile.getFullName();
      _mobileNoController.text = userProfile.getContactNumber();
      _emailController.text = userProfile.getEmail();
    });
  }

  String? _selectedGender;
  DateTime? _selectedBirthday;
  NGO? _selectedNGO;

  final List<NGO> _ngoOptions = [
    NGO('NGO 1', 'Description for NGO 1'),
    NGO('NGO 2', 'Description for NGO 2'),
    NGO('NGO 3', 'Description for NGO 3'),
  ];

  bool _validateFields() {
    return _fullNameController.text.isNotEmpty &&
        _mobileNoController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _selectedGender != null &&
        _selectedBirthday != null &&
        (_occupationController.text.isNotEmpty ||
            _addressController.text.isNotEmpty) &&
        _linkedinController.text.isNotEmpty &&
        _selectedNGO != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Form'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Full Name*',
              controller: _fullNameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Mobile No*',
              controller: _mobileNoController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email Address*',
              controller: _emailController,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Choose your desired border color
                  width: 1.0, // Adjust the width as needed
                ),
                borderRadius: BorderRadius.circular(
                    5.0), // Adjust the border radius as needed
              ),
              padding: const EdgeInsets.all(6),
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                hint: const Text('Select Gender*'),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                items: ['Male', 'Female', 'Prefer not to say']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Birthday*',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  setState(() {
                    _selectedBirthday = selectedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Occupation*',
              controller: _occupationController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Address*',
              controller: _addressController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'LinkedIn/Instagram Profile Links*',
              controller: _linkedinController,
            ),
            const SizedBox(height: 16),
            Autocomplete<NGO>(
              key: _ngoKey,
              optionsBuilder: (TextEditingValue textEditingValue) {
                return _ngoOptions.where((NGO option) {
                  return option.name.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      );
                });
              },
              onSelected: (NGO? value) {
                setState(() {
                  _selectedNGO = value;
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                return TextFormField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Select NGO*',
                    border: OutlineInputBorder(),
                  ),
                );
              },
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<NGO> onSelected,
                  Iterable<NGO> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: SizedBox(
                      height: 200.0,
                      child: ListView.builder(
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final NGO option = options.elementAt(index);
                          return GestureDetector(
                            onTap: () {
                              onSelected(option);
                            },
                            child: ListTile(
                              title: Text(option.name),
                              subtitle: Text(option.description),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildSubmitButton()
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
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
        onTap: () {},
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

  Future<void> _submitForm() async {
    if (_validateFields()) {
      try {
        // Add volunteer data to Firebase
        await FirebaseFirestore.instance.collection('volunteers').add({
          'fullName': _fullNameController.text,
          'mobileNo': _mobileNoController.text,
          'email': _emailController.text,
          'gender': _selectedGender,
          'birthday': _selectedBirthday,
          'occupation': _occupationController.text,
          'address': _addressController.text,
          'linkedin': _linkedinController.text,
          'ngo': _selectedNGO!.name,
        });

        // Clear all text controllers after successful submission
        _fullNameController.clear();
        _mobileNoController.clear();
        _emailController.clear();
        _occupationController.clear();
        _addressController.clear();
        _linkedinController.clear();
        _selectedGender = null;
        _selectedBirthday = null;
        _selectedNGO = null;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Form submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (error) {
        // Show error message if submission fails
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit form. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Show error message indicating that all fields are required
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
