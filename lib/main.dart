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
      home: const MultiScoreboardScreen(),
    );
  }
}

class GameModel {
  String id;
  String title;
  String teamA;
  String teamB;
  int scoreA;
  int scoreB;

  GameModel({
    required this.id,
    required this.title,
    this.teamA = "TIME A",
    this.teamB = "TIME B",
    this.scoreA = 0,
    this.scoreB = 0,
  });
}

class MultiScoreboardScreen extends StatefulWidget {
  const MultiScoreboardScreen({super.key});

  @override
  State<MultiScoreboardScreen> createState() => _MultiScoreboardScreenState();
}

class _MultiScoreboardScreenState extends State<MultiScoreboardScreen> {
  final List<GameModel> _games = [
    GameModel(id: "1", title: "Jogo 1", teamA: "TIME A", teamB: "TIME B"),
  ];
  int _currentIndex = 0;

  void _addGame() {
    final controller = TextEditingController(text: "Jogo ${_games.length + 1}");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Novo Contador / Jogo"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Nome do jogo"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _games.add(GameModel(
                    id: DateTime.now().toString(),
                    title: controller.text,
                  ));
                  _currentIndex = _games.length - 1;
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Criar"),
          ),
        ],
      ),
    );
  }

  void _editGameTitle(int index) {
    final controller = TextEditingController(text: _games[index].title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Renomear Jogo"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Nome do jogo"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _games[index].title = controller.text;
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  void _deleteGame(int index) {
    if (_games.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Você precisa ter pelo menos 1 contador.")),
      );
      return;
    }

    setState(() {
      _games.removeAt(index);
      if (_currentIndex >= _games.length) {
        _currentIndex = _games.length - 1;
      }
    });
  }

  void _editTeamName(bool isTeamA) {
    final currentGame = _games[_currentIndex];
    final controller = TextEditingController(
      text: isTeamA ? currentGame.teamA : currentGame.teamB,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isTeamA ? "Nome do Time / Jogador A" : "Nome do Time / Jogador B"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Digite o nome"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  if (isTeamA) {
                    currentGame.teamA = controller.text.toUpperCase();
                  } else {
                    currentGame.teamB = controller.text.toUpperCase();
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_games.isEmpty) return const Scaffold();

    final currentGame = _games[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          currentGame.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == "rename") {
                _editGameTitle(_currentIndex);
              } else if (value == "delete") {
                _deleteGame(_currentIndex);
              } else if (value == "reset") {
                setState(() {
                  currentGame.scoreA = 0;
                  currentGame.scoreB = 0;
                });
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "rename", child: Text("Renomear Jogo")),
              const PopupMenuItem(value: "reset", child: Text("Zerar Placar")),
              const PopupMenuItem(value: "delete", child: Text("Excluir este Jogo")),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // Lado Esquerdo (Azul)
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
                          GestureDetector(
                            onTap: () => _editTeamName(true),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    currentGame.teamA,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.edit, size: 14, color: Colors.white54),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              currentGame.scoreA.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                heroTag: "decLeft_${currentGame.id}",
                                backgroundColor: Colors.white24,
                                elevation: 0,
                                onPressed: () {
                                  if (currentGame.scoreA > 0) {
                                    setState(() => currentGame.scoreA--);
                                  }
                                },
                                child: const Icon(Icons.remove, color: Colors.white, size: 30),
                              ),
                              FloatingActionButton(
                                heroTag: "incLeft_${currentGame.id}",
                                backgroundColor: Colors.white,
                                elevation: 2,
                                onPressed: () {
                                  setState(() => currentGame.scoreA++);
                                },
                                child: const Icon(Icons.add, color: Color(0xFF1E88E5), size: 30),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  // Lado Direito (Vermelho)
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
                          GestureDetector(
                            onTap: () => _editTeamName(false),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    currentGame.teamB,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.edit, size: 14, color: Colors.white54),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              currentGame.scoreB.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FloatingActionButton(
                                heroTag: "decRight_${currentGame.id}",
                                backgroundColor: Colors.white24,
                                elevation: 0,
                                onPressed: () {
                                  if (currentGame.scoreB > 0) {
                                    setState(() => currentGame.scoreB--);
                                  }
                                },
                                child: const Icon(Icons.remove, color: Colors.white, size: 30),
                              ),
                              FloatingActionButton(
                                heroTag: "incRight_${currentGame.id}",
                                backgroundColor: Colors.white,
                                elevation: 2,
                                onPressed: () {
                                  setState(() => currentGame.scoreB++);
                                },
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

            // Botão Zerar Placar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C2C2C),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  setState(() {
                    currentGame.scoreA = 0;
                    currentGame.scoreB = 0;
                  });
                },
                icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
                label: const Text("ZERAR PLACAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),

            // Barra de Abas dos Jogos (Navegação na Parte Inferior)
            Container(
              height: 55,
              color: const Color(0xFF1E1E1E),
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _games.length,
                      itemBuilder: (context, index) {
                        final isSelected = index == _currentIndex;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue : Colors.white10,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _games[index].title,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blue, size: 30),
                    tooltip: "Novo Jogo",
                    onPressed: _addGame,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
