import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ContadorApp());
}

class ContadorApp extends StatelessWidget {
  const ContadorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contador Online',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF070C12),
        cardColor: const Color(0xFF0F1722),
      ),
      home: const ContadorPage(),
    );
  }
}

enum TipoContador { simples, placar }

class ContadorItem {
  String id;
  String titulo;
  int valorSimples;
  int placarA;
  int placarB;
  TipoContador tipo;

  ContadorItem({
    required this.id,
    required this.titulo,
    this.valorSimples = 0,
    this.placarA = 0,
    this.placarB = 0,
    required this.tipo,
  });
}

class ContadorPage extends StatefulWidget {
  const ContadorPage({super.key});

  @override
  State<ContadorPage> createState() => _ContadorPageState();
}

class _ContadorPageState extends State<ContadorPage> {
  final List<ContadorItem> _contadores = [
    ContadorItem(id: '1', titulo: 'FERY X MINAUR - O 18.5', valorSimples: 12, tipo: TipoContador.simples),
    ContadorItem(id: '2', titulo: 'SHNAIDER X NAVARRO', placarA: 2, placarB: 1, tipo: TipoContador.placar),
    ContadorItem(id: '3', titulo: 'MENSIK VENCER', valorSimples: 0, tipo: TipoContador.simples),
  ];

  void _adicionarContador() {
    final controller = TextEditingController();
    TipoContador tipoSelecionado = TipoContador.simples;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Novo Contador'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'Nome do contador'),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              SegmentedButton<TipoContador>(
                segments: const [
                  ButtonSegment(value: TipoContador.simples, label: Text('Simples')),
                  ButtonSegment(value: TipoContador.placar, label: Text('Placar (X x Y)')),
                ],
                selected: {tipoSelecionado},
                onSelectionChanged: (novaSelecao) {
                  setDialogState(() {
                    tipoSelecionado = novaSelecao.first;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _contadores.add(ContadorItem(
                      id: DateTime.now().toString(),
                      titulo: controller.text.toUpperCase(),
                      tipo: tipoSelecionado,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }

  void _removerContador(String id) {
    setState(() {
      _contadores.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Contador online',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Use este contador online para contar o que quiser.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth > 600 ? 3 : 1;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: _contadores.length,
                      itemBuilder: (context, index) {
                        final item = _contadores[index];
                        return CardContador(
                          item: item,
                          onDelete: () => _removerContador(item.id),
                        );
                      },
                    );
                  },
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _adicionarContador,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar um novo contador'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardContador extends StatefulWidget {
  final ContadorItem item;
  final VoidCallback onDelete;

  const CardContador({super.key, required this.item, required this.onDelete});

  @override
  State<CardContador> createState() => _CardContadorState();
}

class _CardContadorState extends State<CardContador> {
  void _renomearContador() {
    final controller = TextEditingController(text: widget.item.titulo);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renomear Contador'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Novo nome'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  widget.item.titulo = controller.text.toUpperCase();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.item.titulo,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                onSelected: (value) {
                  if (value == 'edit') {
                    _renomearContador();
                  } else if (value == 'reset') {
                    setState(() {
                      widget.item.valorSimples = 0;
                      widget.item.placarA = 0;
                      widget.item.placarB = 0;
                    });
                  } else if (value == 'delete') {
                    widget.onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Renomear')),
                  const PopupMenuItem(value: 'reset', child: Text('Zerar')),
                  const PopupMenuItem(value: 'delete', child: Text('Excluir')),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.white10),
          if (widget.item.tipo == TipoContador.simples) ...[
            Text(
              '',
              style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: () {
                    if (widget.item.valorSimples > 0) {
                      setState(() => widget.item.valorSimples--);
                    }
                  },
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(backgroundColor: Colors.red, iconSize: 24),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  onPressed: () {
                    setState(() => widget.item.valorSimples++);
                  },
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(backgroundColor: Colors.green, iconSize: 24),
                ),
              ],
            )
          ] else ...[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'x',
                        style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (widget.item.placarA > 0) setState(() => widget.item.placarA--);
                          },
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 22),
                        ),
                        IconButton(
                          onPressed: () => setState(() => widget.item.placarA++),
                          icon: const Icon(Icons.add_circle_outline, color: Colors.green, size: 22),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (widget.item.placarB > 0) setState(() => widget.item.placarB--);
                          },
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 22),
                        ),
                        IconButton(
                          onPressed: () => setState(() => widget.item.placarB++),
                          icon: const Icon(Icons.add_circle_outline, color: Colors.green, size: 22),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
