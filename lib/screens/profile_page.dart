import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'country_flags.dart';

class ProfilePage extends StatefulWidget {
  final ValueNotifier<bool> isDarkMode;

  const ProfilePage({super.key, required this.isDarkMode});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instagramController = TextEditingController();
  final _emailController = TextEditingController();
  final _accommodationController = TextEditingController();
  String? selectedAccommodation;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isEditable = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          _fullNameController.text = data['fullName'];
          _phoneController.text = data['phone'];
          //_countryCodeController.text = data['phone'].substring(0, 2);
          _instagramController.text = data['instagram'];
          _emailController.text = data['email'];
          setState(() {
            selectedAccommodation = data['accommodation'];
          });
        }
      }
    }
  }

  void _saveChanges() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'fullName': _fullNameController.text,
        'phone': _phoneController.text,
        'instagram': _instagramController.text,
        'email': _emailController.text,
        'accommodation': _accommodationController.text,
      });
      setState(() {
        _isEditable = false;
      });
    }
  }

  void _resetPassword() {
    final user = _auth.currentUser;
    if (user != null) {
      _auth.sendPasswordResetEmail(email: user.email!);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent')));
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Dark Mode', style: TextStyle(fontSize: 18)),
                  ValueListenableBuilder(
                    valueListenable: widget.isDarkMode,
                    builder: (context, isDark, child) {
                      return Switch(
                        value: isDark,
                        onChanged: (value) {
                          widget.isDarkMode.value = value;
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),
              Center(
                child: Text(
                  'Personal Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 24),
              Text('Full Name', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              TextFormField(
                controller: _fullNameController,
                enabled: _isEditable,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),
              SizedBox(height: 16),
              Text('Phone Number', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                enabled: _isEditable,
                decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      ),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: 16),
              Text('Instagram', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              TextFormField(
                controller: _instagramController,
                enabled: _isEditable,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),
              SizedBox(height: 16),
              Text('Email', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),
              SizedBox(height: 16),
              Text('Accommodation', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedAccommodation,
                onChanged: _isEditable
                    ? (String? newValue) {
                        setState(() {
                          selectedAccommodation = newValue;
                        });
                      }
                    : null,
                items: <String>[
                  'Woodward Buildings',
                  'Kemp Porter Buildings',
                  'Eastside Halls',
                  'Southside Halls',
                  'Beit Halls',
                  'Xenia',
                  'Wilsons House'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
                disabledHint: selectedAccommodation != null
                    ? Text(selectedAccommodation!)
                    : null,
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _isEditable ? _saveChanges : () {
                    setState(() {
                      _isEditable = true;
                    });
                  },
                  child: Text(_isEditable ? 'Save' : 'Edit Profile'),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _resetPassword,
                  child: Text('Reset Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
