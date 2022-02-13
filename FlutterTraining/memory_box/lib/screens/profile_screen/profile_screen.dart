import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocks/session/session_bloc.dart';
import 'package:memory_box/models/user_model.dart';
import 'package:memory_box/repositories/auth_service.dart';
import 'package:memory_box/screens/splash_screen.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/deleteAlert.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_box/widgets/undoButton.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = 'ProfileScreen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  final TextEditingController _phoneInputContoller = TextEditingController();
  final TextEditingController _nameInputController = TextEditingController();

  bool _isEditMode = false;

  UserModel? _user;

  String? _userName;
  String? _phoneNumber;
  XFile? _selectedImage, _oldImage;

  late final SessionBloc _sessionBloc;

  @override
  void initState() {
    _sessionBloc = BlocProvider.of<SessionBloc>(context);
    asyncInitState();
    super.initState();
  }

  void asyncInitState() async {
    _user = await AuthService.instance.currentUser();

    _updateUserName(
      userName: _user?.displayName,
    );
    _updatePhoneNumber(
      phoneNumber: _user?.phoneNumber,
    );
  }

  void _updateUserName({String? userName}) {
    _nameInputController.text = userName ?? 'Без имени';
  }

  void _updatePhoneNumber({String? phoneNumber}) {
    _phoneInputContoller.text = PhoneInputFormatter().mask(
      _phoneNumber ?? '',
    );
  }

  Future<void> _pickImage() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _selectedImage = image;
    });
  }

  void saveChanges() async {
    String? uid = _user?.uid;
    String? path = _selectedImage?.path;
    if (uid != null) {
      if (path != null) {
        // await storage.uploadFile(
        //   file: File(path),
        //   fileName: uid,
        //   fileType: FileType.avatar,
        // );
      }

      _sessionBloc.add(
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
    _sessionBloc.add(LogOut());
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      SplashScreen.routeName,
      (route) => false,
    );
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
    if (isDelete == true && _user?.uid != null) {
      _sessionBloc.add(DeleteAccount(
        uid: _user!.uid!,
      ));
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        SplashScreen.routeName,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              ? UndoButton(
                  undoChanges: () {
                    undoChanges();
                  },
                )
              : Container(
                  margin: const EdgeInsets.only(left: 6),
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
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    color: const Color.fromRGBO(0, 0, 0, 0.5),
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
                      SizedBox(
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

                      // String? _errorText;
                      // return StatefulBuilder(
                      //   builder: (BuildContext context, setState) {
                      //     return CircleTextField(
                      //       controller: _phoneInputContoller,
                      //       inputFormatters: [PhoneInputFormatter()],
                      //       errorText: _errorText,
                      //       validator: (value) {
                      //         int length = toNumericString(value).length;
                      //         bool isError = false;
                      //         if (length < 8) {
                      //           _errorText = 'Укажите полный номер телефона';
                      //           isError = true;
                      //         }
                      //         if (value == null || value.isEmpty) {
                      //           _errorText = 'Поле не может быть пустым';
                      //           isError = true;
                      //         }
                      //         if (!isError) {
                      //           _errorText = null;
                      //         }
                      //         setState(() {});
                      //         return _errorText;
                      //       },
                      //     );
                      //   },
                      // );
                      // },
                      // ),
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
                                Shadow(
                                    color: Colors.black, offset: Offset(0, -5))
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
                      if (!_isEditMode) const Text('150/500 мб'),
                      // const Spacer(),
                      if (!_isEditMode)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                logOut();
                              },
                              child: const Text('Выйти из приложения'),
                            ),
                            TextButton(
                              onPressed: () {
                                deleteAccount();
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
              );
            },
          ),
        ),
      ),
    );
  }
}
