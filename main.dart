import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FFHelperProApp());
}

class FFHelperProApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FF Helper Pro',
      theme: ThemeData(
        primaryColor: Color(0xFF5E35B1),
        appBarTheme: AppBarTheme(backgroundColor: Color(0xFF5E35B1)),
      ),
      home: HeadshotGuideScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HeadshotGuideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Headshot Sensitivity Guide'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('sensitivity').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var phones = snapshot.data!.docs;

          return ListView.builder(
            itemCount: phones.length,
            itemBuilder: (context, index) {
              var phone = phones[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(phone['brand']),
                  subtitle: Text('DPI: ${phone['dpi']} | General: ${phone['general']}'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('\${phone['brand']} Sensitivity'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('General: \${phone['general']}'),
                            Text('Red Dot: \${phone['redDot']}'),
                            Text('2x Scope: \${phone['scope2x']}'),
                            Text('4x Scope: \${phone['scope4x']}'),
                            Text('DPI: \${phone['dpi']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}