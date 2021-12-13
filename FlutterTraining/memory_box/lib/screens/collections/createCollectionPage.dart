import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_box/widgets/backgoundPattern.dart';
import 'package:memory_box/widgets/undoButton.dart';

class CreateCollectionPage extends StatefulWidget {
  const CreateCollectionPage({Key? key}) : super(key: key);

  @override
  _CreateCollectionPageState createState() => _CreateCollectionPageState();
}

class _CreateCollectionPageState extends State<CreateCollectionPage> {
  XFile? _selectedImage, _oldImage;

  Future<void> _pickImage() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundPattern(
      patternColor: Color.fromRGBO(113, 165, 159, 1),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          primary: true,
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: Container(
              child: UndoButton(
            undoChanges: () {},
          )),
          title: Container(
            margin: const EdgeInsets.only(top: 10),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Создание',
                style: TextStyle(
                  fontFamily: 'TTNorms',
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(
                top: 20,
                right: 15,
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Готово',
                  style: TextStyle(
                    fontFamily: 'TTNorms',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
          elevation: 0,
        ),
        body: Container(
          margin: EdgeInsets.only(
            top: 25,
            left: 15,
            right: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Название',
                style: TextStyle(
                  fontFamily: 'TTNorms',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Container(
                    height: 240,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(246, 246, 246, 0.9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 20,
                          // spreadRadius: 1,
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/ChosePhoto.svg',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              TextField(
                style: TextStyle(fontSize: 22),
                decoration: InputDecoration(
                  hintText: 'Введите описание...',
                ),
                maxLines: 10,
                minLines: 5,
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Готово',
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Добавить аудиофайл',
                    style: TextStyle(
                      fontFamily: 'TTNorms',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.transparent,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.black,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
