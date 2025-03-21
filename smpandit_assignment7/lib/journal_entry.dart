import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'firebase_storage.dart';
import 'dart:io';

class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key}); 

  @override
  JournalEntryScreenState createState() => JournalEntryScreenState();
}

class JournalEntryScreenState extends State<JournalEntryScreen> {

  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _textController = TextEditingController();
  final CFStorage _firestoreService = CFStorage();

  File? _selectedImage;
  int _selectedRating = 0;


  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhotoWithCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }


  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _submitEntry() async {
    if (!_formKey.currentState!.validate()) {
      return; 
    }

    String text = _textController.text.trim();
    String? imageUrl;

    if (text.isNotEmpty) {
      if (_selectedImage != null) {
        imageUrl = await _firestoreService.uploadImage(_selectedImage!, "testUser");
      }

      _firestoreService.addJournalEntry(text, imageUrl, _selectedRating);

      if (mounted) {
        _textController.clear();
        setState(() {
          _selectedImage = null;
          _selectedRating = 0;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Journal Entry Added Successfully!')),
        );

        await Future.delayed(Duration(seconds: 1));

        if (mounted) { 
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("New Journal Entry"),
        backgroundColor: Color(0xFFe3aa99),
        foregroundColor: Colors.white,
      ),

      backgroundColor: Color(0xFFfef9ed),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); 
        },

        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(  
              key: _formKey,
              child: Column( 
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // Rating
                  Text(
                    "My Rating for the Day", 
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFa88a7e))
                  ),
                  
                  SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _selectedRating ? Icons.star : Icons.star_border, 
                          color: index < _selectedRating ? Colors.amber : Colors.grey, 
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedRating = index + 1; 
                          });
                        },
                      );
                    }),
                  ),
                  if (_selectedRating == 0)           // validation
                  Text(
                    "Please select a rating :)",
                    style: TextStyle(color: Color(0xFFCE380A), fontSize: 14),
                  ),

                  SizedBox(height: 10),


                  // Text field
                  TextFormField(
                    controller: _textController,
                    maxLines: 10,
                    style: TextStyle(color: Color(0xFFa88a7e)),
                    decoration: InputDecoration(
                      labelText: "Today I am grateful for...", 
                      labelStyle: TextStyle(color: Color(0xFFa88a7e)),
                      alignLabelWithHint: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: Color(0xFFa88a7e)),
                      ), 
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: Color(0xFFa88a7e)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(color: Color(0xFFa88a7e), width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter something you liked about today..";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),


                  // Image (optional)
                  _selectedImage != null
                    ? Column(
                        children: [
                          Image.file(_selectedImage!, height: 150),
                          SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _removeImage,
                            icon: Icon(Icons.cancel_rounded, color: Colors.white, size: 25,),
                            label: Text("Remove image", style: TextStyle(fontSize: 15)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFe3aa99),
                              foregroundColor: Colors.white,
                              minimumSize: Size(200, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: _pickImageFromGallery,
                            icon: Icon(Icons.photo_library, color: Colors.white, size: 25,),
                            label: Text("Pick from Gallery", style: TextStyle(fontSize: 15)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFe3aa99),
                              foregroundColor: Colors.white,
                              minimumSize: Size(200, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _takePhotoWithCamera,
                            icon: Icon(Icons.camera_alt, color: Colors.white, size: 25,),
                            label: Text("Take a Photo", style: TextStyle(fontSize: 15)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFe3aa99),
                              foregroundColor: Colors.white,
                              minimumSize: Size(200, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ],
                      ),

                  SizedBox(height: 35),


                  // Submit button
                  ElevatedButton(
                    onPressed: _submitEntry, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFa88a7e),
                      foregroundColor: Colors.white, 
                      minimumSize: Size(200, 50), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Submit",                 
                      style: TextStyle(fontSize: 15),
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
