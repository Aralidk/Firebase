// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = FirebaseFirestore.instance;
  TextEditingController movieName = TextEditingController();
  TextEditingController movieRating = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference moviesRef = _firestore.collection('movie');
    var babaRef = _firestore.collection('movie').doc('Baba');

    return Scaffold(
      backgroundColor: Color.fromRGBO(100, 100, 100, 1.0),
      appBar: AppBar(
        title: const Text('Firestore İslemleri'),
      ),
      body: Center(
        child: Column(
          children: [
            /*Text(
              '${babaRef.get()}',
              style: const TextStyle(fontSize: 20),
            ),
            ElevatedButton(
            // querysnapshot alma collection ile
              onPressed: () async{
                var response = await moviesRef.get();
                var list = response.docs;
                print(list[1].data());
              },
              child: Text('Querysnapshot'),
              /* Data alma document ile
                onPressed: () async {
                  var response = await babaRef.get();
                  // Document Snapshot = veriyi mapler ve document snapshota kovar ve yollar
                  var map = response.data();
                  print(map!['name']);
                  print(map!['year']);
                },
                child: const Text('Get Data')*/
            ),
            // otomatik veri okuma anlık document için
            StreamBuilder<DocumentSnapshot>(
              //streamden veri aktığında çalıştır , widget çizer ekrana
              builder: (BuildContext context, AsyncSnapshot asyncSnapShot){
                return Text('${asyncSnapShot.data.data()}');
              },
              //dinlediğimiz şeyin bilgisi, hangi stream
              stream: babaRef.snapshots()
            )*/
            //otomatik veri dinleme
            StreamBuilder<QuerySnapshot>(
              stream: moviesRef.snapshots(),
              builder: (BuildContext context, AsyncSnapshot asyncSnapshot){
               // hata olup olmadığını kontrol etmek gerekiyor
               if(asyncSnapshot.hasError){
                 return const Text(
                   'Error of database');}
               else{
                 if(asyncSnapshot.hasData){
                   List<DocumentSnapshot> listOf = asyncSnapshot.data.docs;
                   return Flexible(
                     child: ListView.builder(
                       itemCount: listOf.length,
                       itemBuilder:(context, index) {
                         return ListTile(
                           title: Text('Name : ${listOf[index].get('name')}'),
                           subtitle: Text('Rating : ${listOf[index].get('rating')}'),
                           trailing: IconButton(
                             icon: Icon(Icons.delete),
                             onPressed: () async {
                               //veri silme
                               await listOf[index].reference.delete();
                             },
                           ),
                         );
                       },
                     ),
                   );
                 }
                 else{
                   return Center(
                     child: Container(
                       color: Color.fromRGBO(100,100, 100,1),
                       width: 250,
                       height: 250,
                       child: Text('No Data In Database'),
                     ),
                   );
                 }
               }
              },
            ),
            Padding(padding: EdgeInsets.all(50),
            child: Form(
              child: Column(
                children: [
                TextFormField(
                  controller: movieName,
                  decoration: InputDecoration(hintText: 'Film Adını Giriniz'),
                ),
                TextFormField(
                  controller: movieRating,
                  decoration: InputDecoration(hintText: 'Film Puanını Giriniz'),
                ),
                ]
              ),
            )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        onPressed: () async {
          //text alanlarındaki veriden map oluştur
          Map<String, dynamic> movieData= {'name': movieName.text,'rating': movieRating.text};
          // veriyi yazacağımız referansa ulaştır ve metodu çağır
          await moviesRef.doc(movieName.text).set(movieData);
          //veriyi update etme
          //await moviesRef.doc(movieName.text).update({'rating': '4.6'});
        },
      ),
    );
  }
}
