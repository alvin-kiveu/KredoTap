import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KredoTap',
      color: Colors.white,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromARGB(255, 244, 251, 248),
          primaryVariant: const Color(0xFF2D4D3F),
          secondary: const Color(0xFF2D4D3F),
          secondaryVariant: const Color(0xFF2D4D3F),
        ),
        useMaterial3: true,
      ),
      home: SplashScreen(), // Use the SplashScreen as the initial screen
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'KredoTap')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.network(
          'https://umeskiasoftwares.com/images/kredotap.png',
          width: 100, // Adjust the width as needed
          height: 100, // Adjust the height as needed
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  //GET THE
  int _mpesaNumber = 0;
  int _airtimePhoneNumber = 0;
  double _airtimeAmount = 0;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = 'https://api.umeskiasoftwares.com/api/v1/kredotap';
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final body = jsonEncode({
        'mpesaNumber': _mpesaNumber.toString(),
        'airtimePhoneNumber': _airtimePhoneNumber.toString(),
        'airtimeAmount': _airtimeAmount.toString(),
      });

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        //GET THE RESPONSE FROM THE API
        final responseJson = jsonDecode(response.body);
        final resultCode = responseJson['ResultCode'];
        if (resultCode == "200") {
          final successMessage = responseJson['successMessage'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color.fromARGB(255, 0, 85, 3),
              content: Text(
                successMessage,
                style: TextStyle(color: Colors.white),
              ),
              duration: const Duration(seconds: 5),
            ),
          );
        } else {
          final errorMessage = responseJson['errorMessage'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Color.fromARGB(255, 130, 0, 0),
              content: Text(
                errorMessage,
                style: TextStyle(color: Colors.white),
                ),
              duration: const Duration(seconds: 5),
            ),
          );
        }
        _formKey.currentState!.reset();
      } else {
        print('Failed to send data. Error code: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Material(
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://umeskiasoftwares.com/images/kredotap.png',
                        width: 100, // Adjust the width as needed
                        height: 100, // Adjust the height as needed
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'M-Pesa Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(16.0),
                            prefixIcon: Icon(Icons.phone),
                            hintText: 'Enter M-Pesa number',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an M-Pesa number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _mpesaNumber = int.parse(value!);
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Airtime Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(16.0),
                            prefixIcon: Icon(Icons.phone),
                            hintText: 'Enter phone number for buying airtime',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the phone number for buying airtime';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _airtimePhoneNumber = int.parse(value!);
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Airtime Amount',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.all(16.0),
                            prefixIcon: Icon(Icons.money),
                            hintText: 'Enter airtime amount',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the airtime amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid amount';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _airtimeAmount = double.parse(value!);
                          },
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('BUY AIRTIME'),
                          style: ElevatedButton.styleFrom(
                            primary:
                                Colors.red, // Change the button color to red
                            minimumSize:
                                Size(double.infinity, 0), // Set width to 100%
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 32.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
