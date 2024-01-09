import 'package:flutter/material.dart';
import 'package:keychain_bg/api.dart';
import 'package:keychain_bg/globals.dart' as globals;

void main() {
  runApp(const MyApp());
}

class SingleActionPopup extends StatelessWidget {
  final Widget content;
  final String title;

  const SingleActionPopup(this.content, this.title);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))),
      title: Text(title),
      content: SingleChildScrollView(child: content),
      actions: [
        ElevatedButton(
            onPressed: () => {Navigator.of(context).pop()}, child: Text('OK')),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Schlüsselverzeichnis Blau-Gold Braunschweig'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    void validateLoginCredentials(String username, String password) async{
      BGApiClient client = BGApiClient();
      client.tryLogin(username, password).then(
        (bool v){
          if(v){
            globals.username = username;
            Navigator.of(context).push(MaterialPageRoute(builder: (ct)=>KeyOverviewPage()));
          }else{
            Navigator.of(context).push(MaterialPageRoute(builder: (ct) => SingleActionPopup(
              Text('Der eingegebene Nutzername oder das eingegebene Passwort ist falsch. Versuchen Sie es erneut.'), 'Ungültiger Login')));
          }
        }
      );
     
    }

    String username = '';
    String password = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Nutzername'
                ),
                onChanged: (v){username = v;},
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Passwort'
                ),
                onChanged: (v){password = v;},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: () => validateLoginCredentials(username, password), child: Text('Login')),
                  ElevatedButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserCreationPage()));}, child: Text('Nutzer erstellen')),
                ],
              )
          ],),
        ),
      )
    );
  }
}

class UserCreationPage extends StatefulWidget{
  @override
  State<UserCreationPage> createState() => _UserCreationPageState();
}

class _UserCreationPageState extends State<UserCreationPage> {


  @override
  Widget build(BuildContext context) {
    String username = '';
    String password = '';
    String email = '';

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Nutzername'
                ),
                onChanged: (v){username = v;},
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Passwort'
                ),
                onChanged: (v){password = v;},
              ),
              TextField(
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Email'
                ),
                onChanged: (v){email = v;},
              ),
              ElevatedButton(onPressed: (){
                BGApiClient client = BGApiClient();
                client.createAccount(username, password, email);
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SingleActionPopup(Text('Account erstellt. Sie können sich nun einloggen.'), 'Account erstellt')));
              }, child: Text('Nutzer erstellen')),
          ],),
        ),
      )
    );
  }
}


Widget getKeyEntryWidget(String name){
  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
    Text(name),
    ElevatedButton(onPressed: (){}, child: Text('Schlüssel übergeben / anfragen'))
  ],);
}

class KeyOverviewPage extends StatefulWidget{
  @override
  State<KeyOverviewPage> createState() => _KeyOverviewPageState();
}

class _KeyOverviewPageState extends State<KeyOverviewPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Card(
          child: SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nutzer'),
                  Text('Aktionen')
                ],),
                SizedBox(height: 25,),
                getKeyEntryWidget('Lena')
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
