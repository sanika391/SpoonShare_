// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spoonshare/models/users/user.dart';
import 'package:spoonshare/widgets/bottom_navbar.dart';
import 'package:spoonshare/widgets/custom_text_field.dart';
import 'package:spoonshare/widgets/snackbar.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class NGO {
  final String ngoname;
  final String description;

  NGO(this.ngoname, this.description);

  @override
  String toString() {
    return ngoname;
  }
}

class VolunteerFormScreen extends StatefulWidget {
  const VolunteerFormScreen({Key? key}) : super(key: key);

  @override
  _VolunteerFormScreenState createState() => _VolunteerFormScreenState();
}

class _VolunteerFormScreenState extends State<VolunteerFormScreen> {
  final RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  final RegExp mobileRegex = RegExp(r'^(\+|00)?[0-9]{10,15}$');

  final RegExp linkedinRegex = RegExp(
    r'^(https?:\/\/)?([\w]+\.)?linkedin\.com\/.*$',
  );

  final RegExp instagramRegex = RegExp(
    r'^(https?:\/\/)?(www\.)?instagram\.com\/[A-Za-z0-9_.]+\/?$',
  );

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final GlobalKey<FormFieldState<NGO?>> _ngoKey = GlobalKey();

  List<NGO> _ngos = [];

  @override
  void initState() {
    super.initState();
    fetchNGOData();
    fetchUserProfileData();
  }

  Future<void> fetchNGOData() async {
    try {
      // Fetch NGO data from Firestore
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('ngos').get();

      // Convert query snapshot to a list of NGO objects
      List<NGO> ngos = querySnapshot.docs.map((doc) {
        return NGO(doc['ngoName'], doc['description']);
      }).toList();

      print(ngos);

      setState(() {
        _ngos = ngos;
      });
    } catch (error) {
      // Handle errors if any
      print('Error fetching NGO data: $error');
    }
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
  //
  // bool _validateFields() {
  //   return _fullNameController.text.isNotEmpty &&
  //       _mobileNoController.text.isNotEmpty &&
  //       _emailController.text.isNotEmpty &&
  //       _selectedGender != null &&
  //       _selectedBirthday != null &&
  //       (_occupationController.text.isNotEmpty ||
  //           _addressController.text.isNotEmpty) &&
  //       _linkedinController.text.isNotEmpty &&
  //       _selectedNGO != null;
  // }
  bool _validateFields() {
    bool isValid = true;

    if (_fullNameController.text.isEmpty) {
      isValid = false;
    }

    if (!emailRegex.hasMatch(_emailController.text)) {
      isValid = false;
      showErrorSnackbar(context, 'Please enter a valid email address');
    }

    if (!mobileRegex.hasMatch(_mobileNoController.text)) {
      isValid = false;
      showErrorSnackbar(context, 'Please enter a valid mobile number');
    }

    if (_selectedGender == null) {
      isValid = false;
    }

    if (_selectedBirthday == null) {
      isValid = false;
    }

    if (_occupationController.text.isEmpty && _addressController.text.isEmpty) {
      isValid = false;
    }

    if (_linkedinController.text.isEmpty ||
        (!linkedinRegex.hasMatch(_linkedinController.text) &&
            !instagramRegex.hasMatch(_linkedinController.text))) {
      isValid = false;
      showErrorSnackbar(
          context, 'Please enter a valid LinkedIn or Instagram profile link');
    }

    if (_selectedNGO == null) {
      isValid = false;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Form'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              label: 'Full Name*',
              controller: _fullNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // InternationalPhoneNumberInput(
            //   selectorConfig: const SelectorConfig(
            //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            //     setSelectorButtonAsPrefixIcon: true,
            //     leadingPadding: 20,
            //     useEmoji: true,
            //   ),
            //   hintText: 'Phone number',
            //   validator: (userInput) {
            //     if (userInput!.isEmpty) {
            //       return 'Please enter your phone number';
            //     }
            //
            //     // Ensure it is only digits and optional '+' or '00' for the country code.
            //     if (!RegExp(r'^(\+|00)?[0-9]+$').hasMatch(userInput)) {
            //       return 'Please enter a valid phone number';
            //     }
            //
            //     return null; // Return null when the input is valid
            //   },
            //   onInputChanged: (PhoneNumber number) {
            //     userPhone = number.phoneNumber;
            //   },
            //   onInputValidated: (bool value) {
            //     print(value);
            //   },
            //   ignoreBlank: false,
            //   autoValidateMode: AutovalidateMode.onUserInteraction,
            //   selectorTextStyle: const TextStyle(color: Colors.black),
            //   initialValue: number,
            //   textFieldController: _mobileNoController,
            //   formatInput: true,
            //   keyboardType: const TextInputType.numberWithOptions(
            //       signed: true, decimal: true),
            //   onSaved: (PhoneNumber number) {
            //     userPhone = number.phoneNumber;
            //   },
            // ),
            //
            CustomTextField(
              label: 'Mobile No*',
              controller: _mobileNoController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your mobile number';
                } else if (!mobileRegex.hasMatch(value)) {
                  return 'Please enter a valid mobile number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email Address*',
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                } else if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                hint: const Text('Select Gender*'),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Color(0xFFFF9F1C),
                        width: isDarkMode ? 2.0 : 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Color(0xFFFF9F1C),
                        width: isDarkMode ? 2.0 : 1.0,
                      ),
                    )),
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
            Padding(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "Birthday*",
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white60 : Colors.black87,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Color(0xFFFF9F1C),
                        width: isDarkMode ? 2.0 : 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Color(0xFFFF9F1C),
                        width: isDarkMode ? 2.0 : 1.0,
                      ),
                    )),
                readOnly: true,
                controller: _selectedBirthday == null
                    ? null
                    : TextEditingController(
                        text:
                            '${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}',
                      ),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your LinkedIn or Instagram profile link';
                } else if (!linkedinRegex.hasMatch(value) &&
                    !instagramRegex.hasMatch(value)) {
                  return 'Please enter a valid LinkedIn or Instagram profile link';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
              child: Autocomplete<NGO>(
                key: _ngoKey,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  final options = _ngos.where((ngo) => ngo.ngoname
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()));
                  return options.toList();
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
                    decoration: InputDecoration(
                      labelText: 'Select NGO*',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
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
                      labelStyle: TextStyle(
                        color: isDarkMode ? Colors.white60 : Colors.black87,
                        fontFamily: 'DM Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
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
                        height: 250.0,
                        child: ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final NGO option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                title: Text(option.ngoname),
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
            ),
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

    return Center(
      child: Container(
        width: screenWidth * 0.8667,
        height: screenHeight * 0.05625,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFF9F1C),
          borderRadius: BorderRadius.circular(50),
        ),
        child: InkWell(
          onTap: () {
            _submitForm();
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
          'ngo': _selectedNGO!.ngoname,
          'verified': false,
        });

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
        showSuccessSnackbar(context, 'Form submitted successfully');
        Navigator.pop(context);
      } catch (error) {
        // Show error message if submission fails
        showErrorSnackbar(context, 'Error submitting form: $error');
      }
    } else {
      // Show error message indicating that all fields are required
      showErrorSnackbar(context, 'All fields are required');
    }
  }
}
