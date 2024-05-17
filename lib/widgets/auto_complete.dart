import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class PlaceApi {
  static const String googlePlacesApiKey =
      "AIzaSyDgHvrFLRxLKMa73qO_eb1j8NrFLoEIHDY";

  static Future<List<Map<String, dynamic>>> getSuggestions(String input) async {
    String groundURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$groundURL?input=$input&key=$googlePlacesApiKey';

    var responseResult = await http.get(Uri.parse(request));

    if (responseResult.statusCode == 200) {
      return (json.decode(responseResult.body)['predictions'] as List)
          .cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  static Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    String detailsURL =
        'https://maps.googleapis.com/maps/api/place/details/json';
    String request =
        '$detailsURL?place_id=$placeId&key=${PlaceApi.googlePlacesApiKey}';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      return json.decode(response.body)['result'];
    } else {
      throw Exception('Failed to load place details');
    }
  }
}

class AutoComplete extends StatefulWidget {
  const AutoComplete({Key? key}) : super(key: key);

  @override
  State<AutoComplete> createState() => _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {
  String tokenForSession = "12345";
  List<Map<String, dynamic>> listForPlaces = [];
  var uuid = Uuid();
  final TextEditingController searchController = TextEditingController();

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
    searchController.addListener(onModify);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void onModify() {
    if (tokenForSession.isEmpty) {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }
    makeSuggestions(searchController.text);
  }

  Future<void> handleListItemTap(int index) async {
    String placeId = listForPlaces[index]['place_id'];
    var placeDetails = await PlaceApi.getPlaceDetails(placeId);
    double lat = placeDetails['geometry']['location']['lat'];
    double lng = placeDetails['geometry']['location']['lng'];
    String selectedAddress = listForPlaces[index]['description'];
    print(selectedAddress);
    print(lat);
    print(lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto Complete'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listForPlaces.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    await handleListItemTap(index);
                  },
                  title: Text(
                    listForPlaces[index]['description'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
