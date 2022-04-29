import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({ Key? key }) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image; 
  bool _isLoadig = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoadig = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      userName: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    setState(() {
      _isLoadig = false;
    });
    if(res != 'success'){
      showSnackBar(res, context);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex : 2),
            //svg image
            SvgPicture.asset(
              "assets/ic_instagram.svg",
              color: primaryColor,
              height: 64,
            ),
            const SizedBox(height: 64.0),
            Stack(
              children: [
                _image != null ? CircleAvatar(
                  radius: 64.0,
                  backgroundImage: MemoryImage(_image!),
                ) : const
                CircleAvatar(
                  radius: 64.0,
                  backgroundImage: NetworkImage('https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg'),
                ),
                Positioned(
                  bottom: -10, 
                  left: 80,
                  child: IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: selectImage, 
                    ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
             TextFieldInput(
              hintText: 'Enter username', 
              textEditingController: _usernameController, 
              textInputType: TextInputType.text
            ),
            const SizedBox(height: 24.0),
            
            //email text field
            TextFieldInput(
              hintText: 'Enter email', 
              textEditingController: _emailController , 
              textInputType: TextInputType.emailAddress
            ),
            const SizedBox(height: 24.0),
            TextFieldInput(
              hintText: 'Enter password', 
              textEditingController: _passwordController, 
              textInputType: TextInputType.text, 
              isPass: true
              ),
            const SizedBox(height: 24.0),
             TextFieldInput(
              hintText: 'Enter bio', 
              textEditingController: _bioController , 
              textInputType: TextInputType.text
            ),
            const SizedBox(height: 24.0),
            InkWell(
              // onTap: () async {
              //   String res = await AuthMethods().signUpUser(
              //   email: _emailController.text, 
              //   password: _passwordController.text,
              //   userName: _usernameController.text,
              //   bio: _bioController.text,
              //   file: _image!
              //   );
              //   print(res);
              // },
              onTap: signUpUser,
              child: Container(
                child: _isLoadig ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  ) : const Text('Sign up'),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: const ShapeDecoration(shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                color: blueColor,
                )
              ),
            ),
            const SizedBox(height: 12.0),
            Flexible(child: Container(), flex : 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    child: const Text("Already have an account? "),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                
                  ),
                ),
                GestureDetector(
                  onTap: (){},
                  child: Container(
                    child: const Text(" Log in" , style: TextStyle(fontWeight: FontWeight.bold),),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ),
              ],
            )
          ],)
        ),
      ),
    );
  }
}