import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/authentication/authentication_bloc.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:memory_box/repositories/authService.dart';
import 'package:memory_box/repositories/databaseService.dart';
import 'package:memory_box/repositories/storageService.dart';
import 'package:memory_box/screens/root.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/circleTextField.dart';
import 'package:memory_box/widgets/deleteAlert.dart';
import 'package:memory_box/widgets/navigationMenu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/single_child_widget.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = 'ProfilePage';

  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  final _phoneInputContoller = TextEditingController();
  final _nameInputController = TextEditingController();

  bool _isEditMode = false;

  UserModel? user;

  String? _userName;
  String? _phoneNumber;

  XFile? _selectedImage, _oldImage;

  @override
  void initState() {
    asyncInitState();
    super.initState();
  }

  void asyncInitState() async {
    user = await AuthService.instance.currentUser();

    updatePhoneField(user?.phoneNumber);
  }

  void updatePhoneField(String? phoneNumber) {
    _phoneInputContoller.text = PhoneInputFormatter().mask(
      _phoneNumber ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final storage = StorageService.instance;
    final database = DatabaseService.instance;

    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    Future<void> _pickImage() async {
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      setState(() {
        _selectedImage = image;
      });
    }

    void saveChanges() async {
      String? uid = user?.uid;
      String? path = _selectedImage?.path;
      if (uid != null) {
        if (path != null) {
          await storage.uploadFile(
            file: File(path),
            fileName: uid,
            fileType: FileType.avatar,
          );
        }

        authenticationBloc.add(
          UpdateAccount(
            uid: uid,
            displayName: _nameInputController.text,
            phoneNumber: toNumericString(_phoneInputContoller.text),
          ),
        );
      }
      setState(() {
        _userName = _nameInputController.text;
        _phoneNumber = _phoneInputContoller.text;
      });
    }

    void undoChanges() {
      setState(() {
        _nameInputController.text = _userName ?? '';
        _phoneInputContoller.text = _phoneNumber ?? '';
        _selectedImage = _oldImage;
        _isEditMode = false;
      });
    }

    void _toogleMode() {
      setState(() {
        _isEditMode = !_isEditMode;
        if (_isEditMode) {
          _userName = _nameInputController.text;
          _phoneNumber = _phoneInputContoller.text;
          _oldImage = _selectedImage;
        } else {
          saveChanges();
        }
      });
    }

    void logOut() {
      authenticationBloc.add(LogOut());
    }

    void deleteAccount() async {
      bool? isDelete = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return const DeleteAlert(
            title: 'Точно удалить аккаунт?',
            content:
                'Все аудиофайлы исчезнут и восстановить аккаунт будет невозможно',
          );
        },
      );
      if (isDelete == true && user?.uid != null) {
        authenticationBloc.add(DeleteAccount(user!.uid!));
      }
    }

    return BackgroundPattern(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          primary: true,
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: _isEditMode
              ? Container(
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
                      undoChanges();
                    },
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(left: 6),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/Burger.svg',
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
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
                        if (_isEditMode)
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
                    controller: _nameInputController,
                    textAlign: TextAlign.center,
                    enabled: _isEditMode ? true : false,
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
                  editable: _isEditMode ? true : false,
                ),
                const SizedBox(
                  height: 0,
                ),
                TextButton(
                  onPressed: () {
                    _toogleMode();
                  },
                  child: Text(
                    _isEditMode ? 'Сохранить' : 'Редактировать',
                    style: const TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (!_isEditMode)
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
                if (!_isEditMode)
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
                if (!_isEditMode) Text('150/500 мб'),
                Spacer(),
                if (!_isEditMode)
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
