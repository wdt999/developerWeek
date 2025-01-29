import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

// image_picker: ^1.0.4 pubspec.yaml에 추가했음

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GalleryPage(),
    );
  }
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final List<Map<String, dynamic>> _images = []; // 이미지와 제목, 내용을 저장
  final ImagePicker _picker = ImagePicker();

  // 📌 이미지 선택 후 제목과 내용 입력받는 함수
  Future<void> _pickImageAndComment() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes(); // 파일을 Uint8List로 변환

      // 제목과 내용 입력받기
      final Map<String, String>? result = await showDialog<Map<String, String>>(
        context: context,
        builder: (context) {
          TextEditingController titleController = TextEditingController();
          TextEditingController contentController = TextEditingController();
          return AlertDialog(
            title: Text("제목과 내용 입력"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: "제목을 입력하세요"),
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(hintText: "내용을 입력하세요"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop({
                    "title": titleController.text,
                    "content": contentController.text
                  });
                },
                child: Text("확인"),
              ),
            ],
          );
        },
      );

      if (result != null) {
        setState(() {
          _images.add({
            "image": bytes,
            "title": result["title"]!,
            "content": result["content"]!
          }); // 이미지와 제목, 내용을 저장
        });
      }
    }
  }

  // 📌 이미지 클릭 시 내용 표시
  void _showImageContent(Map<String, dynamic> imageData) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width:
                MediaQuery.of(context).size.width * 0.8, // Dialog가 화면의 80% 차지
            height:
                MediaQuery.of(context).size.height * 0.8, // Dialog가 화면의 80% 차지
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                // 이미지는 창의 왼쪽에 위치
                SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.3, // 이미지의 크기를 30%로 설정
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Image.memory(
                    imageData["image"],
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16.0), // 이미지와 내용 사이의 간격
                // 제목은 이미지 아래에, 내용은 오른쪽에 위치
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Text(
                        imageData["title"],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Text(imageData["content"]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("나의 보관함"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: _pickImageAndComment, // 이미지와 제목/내용 업로드
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _images.length,
          itemBuilder: (context, index) {
            final imageData = _images[index];
            return GestureDetector(
              onTap: () => _showImageContent(imageData), // 이미지 클릭 시 내용 보기
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.memory(
                      imageData["image"],
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 8.0,
                      left: 8.0,
                      right: 8.0,
                      child: Container(
                        color: Colors.black.withOpacity(0.6),
                        child: Text(
                          imageData["title"],
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
