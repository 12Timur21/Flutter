import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/authentication/authentication_bloc.dart';
import 'package:memory_box/screens/root.dart';
import 'package:memory_box/services/authService.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/circleTextField.dart';
import 'package:memory_box/widgets/navigationMenu.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = 'ProfilePage';

  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

enum Mode {
  viewMode,
  editMode,
}

class _ProfileState extends State<ProfilePage> {
  TextEditingController _phoneInputContoller = TextEditingController();
  TextEditingController _nameFieldController = TextEditingController();
  Mode _currentMode = Mode.viewMode;

  String? _userName;
  String? _updatedUserName;

  String _phoneNumber = '380969596645';
  String? _updatedPhoneNumber;

  XFile? _selectedImage, _updatedImage;

  Future _pickImage() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _selectedImage = image;
    });
  }

  void changeViewMode() {
    setState(() {
      if (_currentMode == Mode.viewMode)
        _currentMode = Mode.editMode;
      else
        _currentMode = Mode.viewMode;
    });
  }

  // void saveChanges() {
  //   _userName = _updatedUserName;
  //   _selectedImage = _updatedImage;
  //   if()
  //   _phoneNumber = _updatedPhoneNumber;
  // }

  @override
  void initState() {
    _nameFieldController.text = _userName ?? '';
    _phoneInputContoller.text = PhoneInputFormatter().mask(_phoneNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    void logOut() {
      _authenticationBloc.add(LoggedOut());
    }

    void deleteAccount() {
      _authenticationBloc.add(DeleteAccount());
    }

    return BackgroundPattern(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          primary: true,
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: _currentMode == Mode.viewMode
              ? Container(
                  margin: EdgeInsets.only(left: 6),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/Burger.svg',
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(top: 20, left: 10),
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        15,
                      ),
                    ),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/ArrowLeftCircle.svg',
                    ),
                    onPressed: () {
                      changeViewMode();
                    },
                  ),
                ),
          title: Container(
            margin: const EdgeInsets.only(top: 15),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Профиль',
                style: TextStyle(
                  fontFamily: 'TTNorms',
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  letterSpacing: 0.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '\n Твоя частичка',
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          elevation: 0,
        ),
        drawer: const NavigationBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    height: 228,
                    width: 228,
                    color: Colors.grey,
                    child: Stack(
                      children: [
                        _selectedImage == null
                            ? Image.asset(
                                'assets/images/nophoto.png',
                                color: Colors.white,
                              )
                            : Image.file(
                                File(_selectedImage!.path),
                                height: 228,
                                fit: BoxFit.fill,
                              ),
                        if (_currentMode == Mode.editMode)
                          GestureDetector(
                            onTap: () {
                              _pickImage();
                            },
                            child: Container(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              height: 228,
                              width: 228,
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icons/ChosePhoto.svg',
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 180,
                  child: TextField(
                    controller: _nameFieldController,
                    textAlign: TextAlign.center,
                    enabled: _currentMode == Mode.viewMode ? false : true,
                    style: const TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                CircleTextField(
                  controller: _phoneInputContoller,
                  inputFormatters: [PhoneInputFormatter()],
                  editable: _currentMode == Mode.viewMode ? false : true,
                ),
                const SizedBox(
                  height: 0,
                ),
                TextButton(
                  onPressed: () {
                    // changeViewMode();
                  },
                  child: Text(
                    _currentMode == Mode.viewMode
                        ? 'Редактировать'
                        : 'Сохранить',
                    style: const TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (_currentMode == Mode.viewMode)
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Подписка",
                      style: TextStyle(
                        fontFamily: 'TTNorms',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        shadows: [
                          Shadow(color: Colors.black, offset: Offset(0, -5))
                        ],
                        color: Colors.transparent,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        decorationThickness: 1.1,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
                  ),
                if (_currentMode == Mode.viewMode)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: const LinearProgressIndicator(
                        value: 0.3,
                        minHeight: 24,
                        color: Color.fromRGBO(241, 180, 136, 1),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 5,
                ),
                if (_currentMode == Mode.viewMode) Text('150/500 мб'),
                Spacer(),
                if (_currentMode == Mode.viewMode)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          logOut();
                          // AuthService.instance.signOut();
                          // Navigator.pushReplacementNamed(
                          //   context,
                          //   Root.routeName,
                          // );
                        },
                        child: Text('Выйти из приложения'),
                      ),
                      TextButton(
                        onPressed: () {
                          deleteAccount();
                          // AuthService.instance.deleteAccount();
                          // Navigator.pushReplacementNamed(
                          //   context,
                          //   Root.routeName,
                          // );
                        },
                        child: const Text(
                          'Удалить аккаунт',
                          style: TextStyle(
                            color: Color.fromRGBO(226, 119, 119, 1),
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
