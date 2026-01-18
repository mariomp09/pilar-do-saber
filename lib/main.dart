import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const PilarDoSaberApp());

class PilarDoSaberApp extends StatelessWidget {
  const PilarDoSaberApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.yellow[700],
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black, foregroundColor: Colors.yellow),
      ),
      home: const HomePage(),
    );
  }
}

// VARIÁVEIS GLOBAIS (Simulando Banco de Dados)
String ibanGlobal = "AO06 0000 0000 0000 0000 0";
String expressGlobal = "923 000 000";
List<String> agendamentos = []; // Lista para o seu irmão ver

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PILAR DO SABER")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.school, size: 100, color: Colors.black),
          const SizedBox(height: 30),
          _botaoMenu(context, "AGENDAR AULA", Icons.calendar_today, const TelaAgendamento()),
          _botaoMenu(context, "PAGAMENTO", Icons.account_balance_wallet, const TelaPagamento()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.lock, color: Colors.yellow),
        onPressed: () => _loginAdm(context),
      ),
    );
  }

  Widget _botaoMenu(context, texto, icone, destino) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow[700], foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 50),
        ),
        icon: Icon(icone), label: Text(texto),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destino)),
      ),
    );
  }

  void _loginAdm(context) {
    TextEditingController _c = TextEditingController();
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Código do Professor"),
      content: TextField(controller: _c, keyboardType: TextInputType.number, obscureText: true),
      actions: [TextButton(onPressed: () {
        if (_c.text == "2402") {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const TelaProfessor()));
        }
      }, child: const Text("ENTRAR"))],
    ));
  }
}

// --- TELA DE AGENDAMENTO ---
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
              decoration: const InputDecoration(labelText: "Escolha a Disciplina"),
              items: ["Matemática", "Português", "Informática", "Inglês"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => disciplina = v,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Escolha o Horário"),
              items: ["08:00 - 10:00", "10:00 - 12:00", "14:00 - 16:00"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => horario = v,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.yellow),
              onPressed: () {
                if (disciplina != null && horario != null) {
                  agendamentos.add("$disciplina às $horario");
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Aula Agendada! Prossiga para o Pagamento.")));
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

// --- TELA DE PAGAMENTO (COMO VOCÊ PEDIU) ---
class TelaPagamento extends StatelessWidget {
  const TelaPagamento({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pagamento")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _cardInfo("Express (Telefone)", expressGlobal),
          _cardInfo("IBAN", ibanGlobal),
          const SizedBox(height: 20),
          const Text("Envie o comprovativo para validar sua vaga.", textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _cardInfo(titulo, dado) {
    return Card(
      color: Colors.yellow[50],
      child: ListTile(
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(dado),
        trailing: IconButton(icon: const Icon(Icons.copy), onPressed: () => Clipboard.setData(ClipboardData(text: dado))),
      ),
    );
  }
}

// --- TELA DO PROFESSOR (ALTERAR DADOS + VER AULAS) ---
class TelaProfessor extends StatefulWidget {
  const TelaProfessor({super.key});
  @override
  State<TelaProfessor> createState() => _TelaProfessorState();
}

class _TelaProfessorState extends State<TelaProfessor> {
  final _cIBAN = TextEditingController(text: ibanGlobal);
  final _cExp = TextEditingController(text: expressGlobal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Painel ADM")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("ALTERAR DADOS DE PAGAMENTO", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(controller: _cExp, decoration: const InputDecoration(labelText: "Novo Telefone Express")),
          TextField(controller: _cIBAN, decoration: const InputDecoration(labelText: "Novo IBAN")),
          ElevatedButton(onPressed: () {
            ibanGlobal = _cIBAN.text;
            expressGlobal = _cExp.text;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Dados Salvos!")));
          }, child: const Text("SALVAR")),
          const Divider(height: 50),
          const Text("PRÓXIMAS AULAS AGENDADAS:", style: TextStyle(fontWeight: FontWeight.bold)),
          ...agendamentos.map((e) => ListTile(leading: const Icon(Icons.person), title: Text(e))).toList(),
        ],
      ),
    );
  }
}
