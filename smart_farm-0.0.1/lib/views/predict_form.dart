import 'package:flutter/material.dart';
import 'package:smart_farm/services/predict.dart';

class PredictForm extends StatefulWidget {
  const PredictForm({Key? key}) : super(key: key);

  @override
  _PredictFormState createState() => _PredictFormState();
}

class _PredictFormState extends State<PredictForm> {
  String? _month;
  double? _ph;
  String? _soil;

  String? _results;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _temp = TextEditingController();
  final TextEditingController _rain = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField(
            value: _month,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Month',
            ),
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            onChanged: (String? newValue) {
              setState(() {
                _month = newValue!;
              });
            },
            items: <String>[
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sept',
              'Oct',
              'Nov',
              'Dec',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
          DropdownButtonFormField(
            value: _ph,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'ph Scale',
            ),
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            onChanged: (double? newValue) {
              setState(() {
                _ph = newValue!;
              });
            },
            items: <double>[
              4,
              4.5,
              5,
              5.5,
              6,
              6.5,
              7,
              7.5,
              8,
              8.5,
              9,
            ].map<DropdownMenuItem<double>>((double value) {
              return DropdownMenuItem<double>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
          DropdownButtonFormField(
            value: _soil,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Soil type',
            ),
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            onChanged: (String? newValue) {
              setState(() {
                _soil = newValue!;
              });
            },
            items: <String>[
              'loamy soil',
              'clay soil',
              'red soil',
              'black cotton soil',
              'deltaic soil',
              'well drained deep soil',
              'sandy soil',
              'laterite soil'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
          TextFormField(
            controller: _temp,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Average temperature',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter temperature.';
              }
              return null;
            },
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
          TextFormField(
            controller: _rain,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Average rainfall (mm)',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter avg. rainfall.';
              }
              return null;
            },
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
          Container(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Future<String> response = Predict()
                      .predict(_temp.text, _rain.text, _ph!, _soil!, _month!);

                  response.then((value) {
                    setState(() {
                      _results = value;
                    });
                  });
                }
              },
              child: Text(
                'Predict',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 12.0)),
              ),
            ),
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 16.0)),
          if (_results != null)
            Text(
              'Optimal crop to plant is ' + _results!,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
        ],
      ),
    );
  }
}
