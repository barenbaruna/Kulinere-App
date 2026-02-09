Buka berkas pubspec.yaml dalam direktori utama project. Tambahkan package workmanager di dalamnya. Package ini akan membantu aplikasi untuk menjalankan tugas di balik layar.
...
 
dependencies:
 ...
 workmanager:
   git:
     url: https://github.com/fluttercommunity/flutter_workmanager.git
     path: workmanager
     ref: main
 
...

Catatan:
Pada latihan ini, kita memanfaatkan sumber spesifik dari project GitHub flutter_workmanager yang dikelola Flutter Community melalui path workmanager. Pada referensi ini, Workmanager berjalan sesuai dengan tugasnya. Apabila menggunakan versi terbaru, ada konfigurasi yang konflik sehingga menyebabkan aplikasi tidak bisa berjalan. Issue selengkapnya dapat Anda lihat pada beberapa tautan berikut.
•	Android: Unresolved References After Flutter 3.29.0 Update.
•	iOS: Type 'WorkmanagerPlugin' has no member 'registerBGProcessingTask' and 'registerPeriodicTask'.

Menambahkan Fitur Workmanager
1.	Lanjut ke tahapan berikutnya, yaitu menambahkan fitur Workmanager. Langkah awal yang perlu kita lakukan adalah membuat konstanta untuk menyimpan uniqueName dan taskName. Anda bisa mendeklarasikannya melalui membuat berkas baru bernama my_workmanager.dart dalam direktori lib → static. Isi berkas tersebut dengan enum MyWorkmanager.
enum MyWorkmanager {
 oneOff("task-identifier", "task-identifier"),
 periodic("com.dicoding.notificationApp",
     "com.dicoding.notificationApp");
 
 final String uniqueName;
 final String taskName;
 
 const MyWorkmanager(this.uniqueName, this.taskName);
}

Kemudian, buatlah berkas baru bernama workmanager_service.dart dalam direktori lib → services. Isi berkas tersebut dengan kelas WorkmanagerService seperti berikut.
class WorkmanagerService {
 final Workmanager _workmanager;
 
 WorkmanagerService([Workmanager? workmanager])
     : _workmanager = workmanager ??= Workmanager();
 
}

Catatan:
Operator ??= adalah salah satu assignment operator pada Dart yang digunakan untuk menetapkan nilai variabel hanya jika ia masih bernilai null. Dalam kasus ini, ketika variabel workmanager bernilai null, ia akan diberi nilai objek Workmanager(). Namun, ketika variabel sudah diinisialisasi, proses assignment tidak dilakukan.
Langkah berikutnya adalah membuat fungsi init untuk menginisialisasi Workmanager. Biasanya, fungsi ini akan dijalankan di awal sebelum tampilan aplikasi muncul.
@pragma('vm:entry-point')
void callbackDispatcher() {
 Workmanager().executeTask((task, inputData) async {
   
   return Future.value(true);
 });
}
 
class WorkmanagerService {
 final Workmanager _workmanager;
 
 WorkmanagerService([Workmanager? workmanager])
     : _workmanager = workmanager ??= Workmanager();
 
 Future<void> init() async {
   await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);
 }
 
}

Berikutnya adalah menambahkan trigger untuk menjalankan one off task. Buatlah fungsi runOneOffTaskseperti berikut.
...
 
class WorkmanagerService {
 ...
 
 Future<void> runOneOffTask() async {
   await _workmanager.registerOneOffTask(
     MyWorkmanager.oneOff.uniqueName,
     MyWorkmanager.oneOff.taskName,
     constraints: Constraints(
       networkType: NetworkType.connected,
     ),
     initialDelay: const Duration(seconds: 5),
     inputData: {
       "data": "This is a valid payload from oneoff task workmanager",
     },
   );
 }
 
}

Dengan cara yang sama, kita bisa membuat fungsi untuk menjalankan periodic task
...
 
class WorkmanagerService {
 ...
 
 Future<void> runPeriodicTask() async {
   await _workmanager.registerPeriodicTask(
     MyWorkmanager.periodic.uniqueName,
     MyWorkmanager.periodic.taskName,
     frequency: const Duration(minutes: 16),
     initialDelay: Duration.zero,
     inputData: {
       "data": "This is a valid payload from periodic task workmanager",
     },
   );
 }
 
}
Selanjutnya, kita bisa membuat fungsi untuk membatalkan (cancel) seluruh background service yang sedang dan akan berjalan.

...
 
class WorkmanagerService {
 ...
 
 Future<void> cancelAllTask() async {
   await _workmanager.cancelAll();
 }
 
}

Langkah selanjutnya adalah memberikan control flowif-else untuk memeriksa uniqueName atau taskName yang sedang berjalan.

@pragma('vm:entry-point')
void callbackDispatcher() {
 Workmanager().executeTask((task, inputData) async {
   if (task == MyWorkmanager.oneOff.taskName ||
       task == MyWorkmanager.oneOff.uniqueName ||
       task == Workmanager.iOSBackgroundTask) {
     print("inputData: $inputData");
   } else if (task == MyWorkmanager.periodic.taskName) {
     int randomNumber = Random().nextInt(100);
     final httpService = HttpService();
     final result = await httpService.getDataFromUrl(
         "https://jsonplaceholder.typicode.com/posts/$randomNumber");
     print("result: $result");
   }
 
   return Future.value(true);
 });
}
 
class WorkmanagerService {
 final Workmanager _workmanager;
 
 WorkmanagerService([Workmanager? workmanager])
     : _workmanager = workmanager ??= Workmanager();
 
 Future<void> init() async {
   await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);
 }
 
 Future<void> runOneOffTask() async {
   await _workmanager.registerOneOffTask(
     MyWorkmanager.oneOff.uniqueName,
     MyWorkmanager.oneOff.taskName,
     constraints: Constraints(
       networkType: NetworkType.connected,
     ),
     initialDelay: const Duration(seconds: 5),
     inputData: {
       "data": "This is a valid payload from oneoff task workmanager",
     },
   );
 }
 
 Future<void> runPeriodicTask() async {
   await _workmanager.registerPeriodicTask(
     MyWorkmanager.periodic.uniqueName,
     MyWorkmanager.periodic.taskName,
     frequency: const Duration(minutes: 16),
     initialDelay: Duration.zero,
     inputData: {
       "data": "This is a valid payload from periodic task workmanager",
     },
   );
 }
 
 Future<void> cancelAllTask() async {
   await _workmanager.cancelAll();
 }
}

Seluruh fungsi sudah selesai kita buat. Saatnya kita daftarkan kelas WorkmanagerService pada MultiProvider. Silakan buka berkas main.dart dan tambahkan kode berikut.
void main() async {
 ...
 
 runApp(
   MultiProvider(
     providers: [
       ...
       Provider(
         create: (context) => WorkmanagerService()..init(),
       ),
     ],
     child: App(
       initialRoute: route,
     ),
   ),
 );
}
 
...

Menjalankan Aksi Workmanager
Tahapan terakhir adalah menjalankannya melalui interaksi pengguna. Silakan buka berkas home_screen.dartdan fokus pada fungsi-fungsi yang belum memiliki aksi. Tambahkan aksi-aksi berikut untuk mengeksekusi fitur Workmanager melalui objek WorkmanagerService.
class _HomeScreenState extends State<HomeScreen> {
 ...
 
 void _runBackgroundOneOffTask() async {
   context.read<WorkmanagerService>().runOneOffTask();
 }
 
 void _runBackgroundPeriodicTask() async {
   context.read<WorkmanagerService>().runPeriodicTask();
 }
 
 void _cancelAllTaskInBackground() async {
   context.read<WorkmanagerService>().cancelAllTask();
 }
}
