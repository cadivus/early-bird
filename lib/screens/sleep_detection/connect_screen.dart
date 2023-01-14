import 'package:cosinuss_lib/cosinuss_sensor.dart';
import 'package:cosinuss_lib/data_model/cosinuss_connecting_result.dart';
import 'package:early_bird/layout/app_layout.dart';
import 'package:flutter/material.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({
    required this.cosinussSensor,
    Key? key,
  }) : super(key: key);

  final CosinussSensor cosinussSensor;

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  bool waitingForConnect = false;

  String getErrorMessage(CosinussConnectingResult connectingResult) {
    switch(connectingResult) {
      case CosinussConnectingResult.bluetoothNotAvailable:
        return "Bluetooth isn't available";
      case CosinussConnectingResult.bluetoothOff:
        return "Bluetooth is turned";
      case CosinussConnectingResult.sensorNotFound:
        return "Cosinuss sensor not found";
      default:
        return "Unknown error";
    }
  }

  Future<void> showErrorDialog(CosinussConnectingResult connectingResult) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Failure"),
            content: Text(getErrorMessage(connectingResult)),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (waitingForConnect) {
      return const _LoadingIndicator();
    }

    return AppLayout(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("You need to connect to a Cosinuss sensor."),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    waitingForConnect = true;
                  });
                  CosinussConnectingResult result =
                      await widget.cosinussSensor.connect();
                  if (result == CosinussConnectingResult.success) {
                    return;
                  }

                  await showErrorDialog(result);
                  setState(() {
                    waitingForConnect = false;
                  });
                },
                child: const Text("Connect"),
              ),
            ],
          ),
        ),
      ),
      title: 'Connect to Cosinuss',
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text("Connecting..."),
            ],
          ),
        ),
      ),
    );
  }
}
