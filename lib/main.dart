import "package:flutter/material.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Contador",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ScoreboardScreen(),
    );
  }
}

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key});

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  int _scoreLeft = 0;
  int _scoreRight = 0;

  void _incrementLeft() => setState(() => _scoreLeft++);
  void _decrementLeft() => setState(() { if (_scoreLeft > 0) _scoreLeft--; });
  void _incrementRight() => setState(() => _scoreRight++);
  void _decrementRight() => setState(() { if (_scoreRight > 0) _scoreRight--; });
  void _reset() => setState(() { _scoreLeft = 0; _scoreRight = 0; });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Contador", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Zerar Placar",
            onPressed: _reset,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E88E5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("TIME A", style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _scoreLeft.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 100, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                heroTag: "decLeft",
                                backgroundColor: Colors.white24,
                                elevation: 0,
                                onPressed: _decrementLeft,
                                child: const Icon(Icons.remove, color: Colors.white, size: 30),
                              ),
                              FloatingActionButton(
                                heroTag: "incLeft",
                                backgroundColor: Colors.white,
                                elevation: 2,
                                onPressed: _incrementLeft,
                                child: const Icon(Icons.add, color: Color(0xFF1E88E5), size: 30),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("TIME B", style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _scoreRight.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 100, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                heroTag: "decRight",
                                backgroundColor: Colors.white24,
                                elevation: 0,
                                onPressed: _decrementRight,
                                child: const Icon(Icons.remove, color: Colors.white, size: 30),
                              ),
                              FloatingActionButton(
                                heroTag: "incRight",
                                backgroundColor: Colors.white,
                                elevation: 2,
                                onPressed: _incrementRight,
                                child: const Icon(Icons.add, color: Color(0xFFE53935), size: 30),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C2C2C),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: _reset,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text("ZERAR PLACAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
