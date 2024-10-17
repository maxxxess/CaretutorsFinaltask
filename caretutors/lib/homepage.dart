import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _imageUrl;

  Future<String> fetchImageUrl() async {
    final response = await http.get(Uri.parse(
        'https://api.nasa.gov/planetary/apod?api_key=18QBwoiRpbFgeYBSl3PxFHi2aoJjrt7lIindJfng'));
    print(response);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['hdurl'];
    } else {
      throw Exception('Failed to load image');
    }
  }

  void showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<String>(
          future: fetchImageUrl(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AlertDialog(
                content: SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                content: Text('Failed to load image'),
              );
            } else if (snapshot.hasData) {
              return AlertDialog(
                content: Image.network(snapshot.data!),
              );
              print('aasd');
            } else {
              return AlertDialog(
                content: Text('No image available'),
              );
            }
          },
        );
      },
    );
  }

  // Open date picker using showDatePicker
  DateTime? _selectedDate;

  // Function to open the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // Default to current date
      firstDate: DateTime(2000), // Minimum date
      lastDate: DateTime(2101), // Maximum date
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Image.asset('images/logo.png'),
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width * 0.25,
              )
              // Button to fetch image
              /* ElevatedButton(
                onPressed: _fetchImage,
                child: Text('Fetch Image'),
              ),
          
              SizedBox(height: 20),
          
              // Display the image if available
              _imageUrl != null
                  ? Image.network(_imageUrl!)
                  : Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[300],
                      child: Center(child: Text('No Image')),
                    ),
          */
              ,
              ElevatedButton(
                  onPressed: () {
                    fetchImageUrl();
                    showImageDialog(context);
                  },
                  child: Text('Image Pick')),

              // Date picker
              Column(
                children: [
                  Text(
                    _selectedDate == null
                        ? 'No date selected!'
                        : 'Selected Date: ${_selectedDate!.toLocal()}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () =>
                        _selectDate(context), // Call the date picker
                    child: Text('Select Date'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
