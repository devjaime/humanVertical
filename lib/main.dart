import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
// Para animaciones con Lottie, podrías agregar:
// import 'package:lottie/lottie.dart';

void main() => runApp(HydroponicsApp());

class HydroponicsApp extends StatelessWidget {
  const HydroponicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HumanVertical',
      theme: ThemeData(primarySwatch: Colors.green),
      home: AdvancedDashboard(),
    );
  }
}

class AdvancedDashboard extends StatefulWidget {
  const AdvancedDashboard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdvancedDashboardState createState() => _AdvancedDashboardState();
}

class _AdvancedDashboardState extends State<AdvancedDashboard>
    with SingleTickerProviderStateMixin {
  // Variables simuladas para sensores
  double humidity = 0.0;
  double temperature = 0.0;
  double lightLevel = 0.0;

  // Fechas de riego
  DateTime lastWatering = DateTime.now().subtract(Duration(hours: 2));
  DateTime nextWatering = DateTime.now().add(Duration(hours: 4));

  // Calidad de la planta (0-100%)
  double plantQuality = 0.0;

  // Datos para gráfico simulado de cosecha (ej. producción)
  List<FlSpot> harvestData = [];

  // Variable para simular respuesta de IA en comandos de voz
  String aiResponse = "Hola, ¿cómo puedo ayudarte con tu huerto?";

  Timer? _timer;
  Timer? _chartTimer;

  @override
  void initState() {
    super.initState();
    // Simulación de actualización de datos cada 3 segundos
    _timer = Timer.periodic(Duration(seconds: 3), (_) {
      setState(() {
        humidity = 20 + Random().nextDouble() * 60;
        temperature = 15 + Random().nextDouble() * 15;
        lightLevel = 200 + Random().nextDouble() * 800;
        plantQuality = 50 + Random().nextDouble() * 50; // Entre 50 y 100%
        // Simula cambios en los tiempos de riego
        lastWatering = DateTime.now().subtract(Duration(hours: Random().nextInt(5)));
        nextWatering = DateTime.now().add(Duration(hours: 3 + Random().nextInt(3)));
      });
    });

    // Simulación de datos para gráfico (actualización cada 5 segundos)
    harvestData = List.generate(10, (index) => FlSpot(index.toDouble(), Random().nextDouble() * 10));
    _chartTimer = Timer.periodic(Duration(seconds: 5), (_) {
      setState(() {
        double newX = (harvestData.last.x + 1);
        double newY = Random().nextDouble() * 10;
        harvestData.add(FlSpot(newX, newY));
        if (harvestData.length > 10) {
          harvestData.removeAt(0);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _chartTimer?.cancel();
    super.dispose();
  }

  // Widget para animar tarjetas de información
  Widget buildAnimatedCard({required Widget child}) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: Card(
        key: ValueKey(child.hashCode),
        elevation: 4,
        margin: EdgeInsets.all(8),
        child: Padding(padding: EdgeInsets.all(16), child: child),
      ),
    );
  }

  // Widget para mostrar el slogan de la aplicación
  Widget buildSloganWidget() {
    return Container(
      width: double.infinity,
      color: Colors.green[100],
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Column(
        children: [
          Text(
            "HumanVertical",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green[800]),
          ),
          SizedBox(height: 8),
          Text(
            "Cultivando el futuro en espacios urbanos",
            style: TextStyle(fontSize: 18, color: Colors.green[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Dashboard de sensores (humedad, temperatura, luz)
  Widget buildSensorDashboard() {
    return Column(
      children: [
        buildAnimatedCard(
          child: ListTile(
            leading: Icon(Icons.water_drop, color: Colors.blue, size: 40),
            title: Text("Humedad", style: TextStyle(fontSize: 20)),
            subtitle: Text('${humidity.toStringAsFixed(1)} %', style: TextStyle(fontSize: 18)),
          ),
        ),
        buildAnimatedCard(
          child: ListTile(
            leading: Icon(Icons.thermostat, color: Colors.redAccent, size: 40),
            title: Text("Temperatura", style: TextStyle(fontSize: 20)),
            subtitle: Text('${temperature.toStringAsFixed(1)} °C', style: TextStyle(fontSize: 18)),
          ),
        ),
        buildAnimatedCard(
          child: ListTile(
            leading: Icon(Icons.wb_sunny, color: Colors.orange, size: 40),
            title: Text("Luz", style: TextStyle(fontSize: 20)),
            subtitle: Text('${lightLevel.toStringAsFixed(0)} lux', style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }

  // Widget para mostrar información de riego
  Widget buildWateringInfoWidget() {
    return buildAnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Información de Riego",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Último riego automático: ${formatTime(lastWatering)}",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 4),
          Text(
            "Próximo riego programado: ${formatTime(nextWatering)}",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  String formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  // Widget para indicar la calidad de la planta con animación (por ejemplo, un CircularProgressIndicator)
  Widget buildPlantQualityWidget() {
    return buildAnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Calidad de la Planta",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    value: plantQuality / 100,
                    strokeWidth: 10,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      plantQuality > 75
                          ? Colors.green
                          : (plantQuality > 50 ? Colors.amber : Colors.red),
                    ),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                Text(
                  "${plantQuality.toStringAsFixed(0)}%",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Calidad evaluada automáticamente.",
            style: TextStyle(fontSize: 16),
          ),
          // Aquí podrías integrar una animación Lottie, por ejemplo:
          // Lottie.asset('assets/plant_animation.json', height: 100),
        ],
      ),
    );
  }

  // Widget para simular el gráfico animado de cosecha
  Widget buildChartWidget() {
    return buildAnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Histórico de Cosecha",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: harvestData,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [Colors.orangeAccent, Colors.deepOrange],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para simular comandos de voz y la interacción con la IA integrada
  Widget buildVoiceCommandWidget() {
    return buildAnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Comando de Voz",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.mic, color: Colors.purple, size: 40),
              SizedBox(width: 16),
              Expanded(child: Text(aiResponse, style: TextStyle(fontSize: 18))),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Toca para simular un nuevo comando.",
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("codeia.cl")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildSloganWidget(), // Agregado el slogan al inicio
            buildSensorDashboard(),
            buildWateringInfoWidget(),
            buildPlantQualityWidget(),
            buildChartWidget(),
            buildVoiceCommandWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Simula la ejecución de un comando de voz:
          setState(() {
            aiResponse = "Iniciando riego automático... ¡Listo! Tu huerto se ha regado.";
            // Actualiza tiempos de riego
            lastWatering = DateTime.now();
            nextWatering = DateTime.now().add(Duration(hours: 4));
          });
        },
        child: Icon(Icons.mic_none),
      ),
    );
  }
}
