import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PilarDoSaberApp());
}

class PilarDoSaberApp extends StatelessWidget {
  const PilarDoSaberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.yellow[700],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.yellow,
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ---------------- HOME ----------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PILAR DO SABER")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // LOGO DA APP
          Image.asset(
            'assets/logo.png',
            height: 140,
          ),
          const SizedBox(height: 30),

          _botaoMenu(
            context,
            "AGENDAR AULA",
            Icons.calendar_today,
            const TelaAgendamento(),
          ),
          _botaoMenu(
            context,
            "PAGAMENTO",
            Icons.account_balance_wallet,
            const TelaPagamento(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.lock, color: Colors.yellow),
        onPressed: () => _loginAdm(context),
      ),
    );
  }

  Widget _botaoMenu(
      BuildContext context, String texto, IconData icone, Widget destino) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow[700],
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50),
        ),
        icon: Icon(icone),
        label: Text(texto),
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => destino)),
      ),
    );
  }

  void _loginAdm(BuildContext context) {
    final c = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Código do Professor"),
        content: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (c.text == "2402") {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TelaProfessor()),
                );
              }
            },
            child: const Text("ENTRAR"),
          )
        ],
      ),
    );
  }
}

// ---------------- AGENDAMENTO ----------------
class TelaAgendamento extends StatefulWidget {
  const TelaAgendamento({super.key});

  @override
  State<TelaAgendamento> createState() => _TelaAgendamentoState();
}

class _TelaAgendamentoState extends State<TelaAgendamento> {
  String? disciplina;
  String? horario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agendar")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration:
                  const InputDecoration(labelText: "Escolha a Disciplina"),
              items: const [
                "Matemática",
                "Português",
                "Informática",
                "Inglês"
              ]
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => disciplina = v,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration:
                  const InputDecoration(labelText: "Escolha o Horário"),
              items: const [
                "08:00 - 10:00",
                "10:00 - 12:00",
                "14:00 - 16:00"
              ]
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => horario = v,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.yellow,
              ),
              onPressed: () {
                if (disciplina != null && horario != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            "Aula agendada! Prossiga para o pagamento.")),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("CONFIRMAR AGENDAMENTO"),
            )
          ],
        ),
      ),
    );
  }
}

// ---------------- PAGAMENTO ----------------
class TelaPagamento extends StatelessWidget {
  const TelaPagamento({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pagamento")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _cardInfo("Express (Telefone)", "923 000 000"),
          _cardInfo("IBAN", "AO06 0000 0000 0000 0000 0"),
          const SizedBox(height: 20),
          const Text(
            "Envie o comprovativo para validar sua vaga.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _cardInfo(String titulo, String dado) {
    return Card(
      child: ListTile(
        title: Text(titulo,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(dado),
        trailing: IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () =>
              Clipboard.setData(ClipboardData(text: dado)),
        ),
      ),
    );
  }
}

// ---------------- PROFESSOR ----------------
class TelaProfessor extends StatelessWidget {
  const TelaProfessor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Painel ADM")),
      body: const Center(
        child: Text(
          "Painel do Professor\n(Pronto para Firebase)",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
