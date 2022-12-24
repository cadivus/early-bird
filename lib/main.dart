import 'package:cosinuss_lib/cosinuss_sensor.dart';
import 'package:cosinuss_lib/data_model/cosinuss_data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cosinuss Sensor Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Cosinuss° One - Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _connected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<CosinussData>(
            stream: CosinussSensor.instance.stream,
            builder: (
                BuildContext context,
                AsyncSnapshot<CosinussData> snapshot,
                ) {
              if (!snapshot.hasData) {
                return _connected ? const CircularProgressIndicator() : const Text("Disconnected");
              }

              _connected = snapshot.data!.connected;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(children: [
                    const Text(
                      'Status: ',
                    ),
                    Text(CosinussSensor.instance.isConnected ? "Connected" : "Disconnected"),
                  ]),
                  Row(children: [
                    const Text('Heart Rate: '),
                    Text(snapshot.data!.heartRate.toString()),
                  ]),
                  Row(children: [
                    const Text('Body Temperature: '),
                    Text(snapshot.data!.bodyTemperature.toString()),
                  ]),
                  Row(children: [
                    const Text('Accelerometer X: '),
                    Text((snapshot.data!.accelerometer?.x ?? "-").toString()),
                  ]),
                  Row(children: [
                    const Text('Accelerometer Y: '),
                    Text((snapshot.data!.accelerometer?.y ?? "-").toString()),
                  ]),
                  Row(children: [
                    const Text('Accelerometer Z: '),
                    Text((snapshot.data!.accelerometer?.z ?? "-").toString()),
                  ]),
                  Row(children: [
                    const Text('PPG Raw Red: '),
                    Text((snapshot.data!.ppgRaw?.ppgRed ?? "-").toString()),
                  ]),
                  Row(children: [
                    const Text('PPG Raw Green: '),
                    Text((snapshot.data!.ppgRaw?.ppgGreen ?? "-").toString()),
                  ]),
                  Row(children: [
                    const Text('PPG Ambient: '),
                    Text((snapshot.data!.ppgRaw?.ppgAmbient ?? "-").toString()),
                  ]),
                  Row(children: const [
                    Text(
                        '\nNote: You have to insert the earbud in your  \n ear in order to receive heart rate values.')
                  ]),
                  Row(children: const [
                    Text(
                        '\nNote: Accelerometer and PPG have unknown units. \n They were reverse engineered. \n Use with caution!')
                  ]),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: !CosinussSensor.instance.isConnected,
        child: FloatingActionButton(
          onPressed: () {
            CosinussSensor.instance.connect();
          },
          tooltip: 'Connect',
          child: const Icon(Icons.bluetooth_searching_sharp),
        ),
      ),
    );
  }
}
