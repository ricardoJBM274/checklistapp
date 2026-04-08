import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/widgets.dart' as pw; 
import 'package:printing/printing.dart';

void main() => runApp(const ManualesApp());

class ManualesApp extends StatelessWidget {
  const ManualesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      home: const MisManualesPantalla(),
    );
  }
}

// --- PANTALLA 1: LISTA DE PROYECTOS/MANUALES ---
class MisManualesPantalla extends StatefulWidget {
  const MisManualesPantalla({super.key});
  @override
  State<MisManualesPantalla> createState() => _MisManualesPantallaState();
}

class _MisManualesPantallaState extends State<MisManualesPantalla> {
  List<dynamic> _manuales = [];

  @override
  void initState() {
    super.initState();
    _cargarManuales(); // Llamamos a la función asíncrona de forma segura
  }

  // CORRECCIÓN: Función asíncrona separada para evitar el error de await
  Future<void> _cargarManuales() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final archivo = File(p.join(dir.path, 'proyectos_v2.json'));
      if (await archivo.exists()) {
        final contenido = await archivo.readAsString();
        setState(() {
          _manuales = jsonDecode(contenido);
        });
      }
    } catch (e) {
      print("Error al cargar manuales: $e");
    }
  }

  Future<void> _guardarTodo() async {
    final dir = await getApplicationDocumentsDirectory();
    final archivo = File(p.join(dir.path, 'proyectos_v2.json'));
    await archivo.writeAsString(jsonEncode(_manuales));
  }

  void _crearManual() {
    TextEditingController nCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Manual Técnico'),
        content: TextField(controller: nCtrl, decoration: const InputDecoration(hintText: 'Nombre del proyecto')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (nCtrl.text.isNotEmpty) {
                setState(() {
                  _manuales.add({'nombre': nCtrl.text, 'pasos': []});
                });
                _guardarTodo();
                Navigator.pop(context);
              }
            },
            child: const Text('Crear'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de Manuales'), centerTitle: true),
      body: _manuales.isEmpty 
        ? const Center(child: Text("No tienes manuales creados aún."))
        : GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemCount: _manuales.length,
            itemBuilder: (context, index) {
              return InkWell(
                onLongPress: () { // Opción para borrar manual
                  setState(() => _manuales.removeAt(index));
                  _guardarTodo();
                },
                onTap: () async {
                  await Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => PasosManualPantalla(manual: _manuales[index]))
                  );
                  _guardarTodo(); // Guarda cambios al regresar
                },
                child: Card(
                  color: Colors.blue[50],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inventory_2, size: 50, color: Colors.blue),
                      const SizedBox(height: 10),
                      Text(_manuales[index]['nombre'], 
                        style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      Text("${_manuales[index]['pasos'].length} pasos registrados", 
                        style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearManual, 
        tooltip: 'Nuevo Manual',
        child: const Icon(Icons.add_business),
      ),
    );
  }
}

// --- PANTALLA 2: LISTA DE PASOS DENTRO DE UN MANUAL ---
class PasosManualPantalla extends StatefulWidget {
  final Map<String, dynamic> manual;
  const PasosManualPantalla({super.key, required this.manual});

  @override
  State<PasosManualPantalla> createState() => _PasosManualPantallaState();
}

class _PasosManualPantallaState extends State<PasosManualPantalla> {

  Future<void> _exportarPDF() async {
    final pdf = pw.Document();
    
    for (var paso in widget.manual['pasos']) {
      final imagen = pw.MemoryImage(File(paso['ruta_foto']).readAsBytesSync());
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(level: 0, child: pw.Text("Manual: ${widget.manual['nombre']}")),
            pw.SizedBox(height: 20),
            pw.Text("PASO: ${paso['titulo']}", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Center(child: pw.Image(imagen, height: 350)),
            pw.SizedBox(height: 20),
            pw.Text("DESCRIPCIÓN:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(paso['descripcion']),
            pw.Footer(trailing: pw.Text("Página generada por ManualesApp"))
          ],
        );
      }));
    }
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  void _abrirEditor({Map<String, dynamic>? pasoExistente, int? index}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditorPasoPantalla(paso: pasoExistente)),
    );

    if (resultado != null) {
      setState(() {
        if (index != null) {
          widget.manual['pasos'][index] = resultado;
        } else {
          widget.manual['pasos'].add(resultado);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.manual['nombre']),
        actions: [
          if (widget.manual['pasos'].isNotEmpty)
            IconButton(icon: const Icon(Icons.picture_as_pdf), onPressed: _exportarPDF),
        ],
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: widget.manual['pasos'].length,
        onReorder: (oldIdx, newIdx) {
          setState(() {
            if (newIdx > oldIdx) newIdx -= 1;
            final item = widget.manual['pasos'].removeAt(oldIdx);
            widget.manual['pasos'].insert(newIdx, item);
          });
        },
        itemBuilder: (context, index) {
          final paso = widget.manual['pasos'][index];
          return Card(
            key: ValueKey(paso['id']),
            child: ListTile(
              leading: Image.file(File(paso['ruta_foto']), width: 50, height: 50, fit: BoxFit.cover),
              title: Text(paso['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(paso['descripcion'], maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() => widget.manual['pasos'].removeAt(index)),
              ),
              onTap: () => _abrirEditor(pasoExistente: paso, index: index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirEditor(),
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

// --- PANTALLA 3: EDITOR DE PASO (DISEÑO ANTERIOR RECUPERADO) ---
class EditorPasoPantalla extends StatefulWidget {
  final Map<String, dynamic>? paso;
  const EditorPasoPantalla({super.key, this.paso});
  @override
  State<EditorPasoPantalla> createState() => _EditorPasoPantallaState();
}

class _EditorPasoPantallaState extends State<EditorPasoPantalla> {
  late TextEditingController _tCtrl;
  late TextEditingController _dCtrl;
  File? _img;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tCtrl = TextEditingController(text: widget.paso?['titulo'] ?? '');
    _dCtrl = TextEditingController(text: widget.paso?['descripcion'] ?? '');
    if (widget.paso != null) _img = File(widget.paso!['ruta_foto']);
  }

  Future<void> _pick(ImageSource s) async {
    final f = await _picker.pickImage(source: s, imageQuality: 80);
    if (f != null) {
      final dir = await getApplicationDocumentsDirectory();
      final path = p.join(dir.path, "img_${DateTime.now().millisecondsSinceEpoch}${p.extension(f.path)}");
      final saved = await File(f.path).copy(path);
      setState(() => _img = saved);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editor de Paso')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _showMenu(),
              child: Container(
                height: 200, width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
                child: _img != null 
                  ? ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.file(_img!, fit: BoxFit.cover)) 
                  : const Icon(Icons.add_a_photo, size: 50),
              ),
            ),
            const SizedBox(height: 20),
            TextField(controller: _tCtrl, decoration: const InputDecoration(labelText: 'Título del Paso', border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _dCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Descripción detallada', border: OutlineInputBorder())),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () {
                if (_tCtrl.text.isEmpty || _img == null) return;
                Navigator.pop(context, {
                  'id': widget.paso?['id'] ?? DateTime.now().toIso8601String(),
                  'titulo': _tCtrl.text,
                  'descripcion': _dCtrl.text,
                  'ruta_foto': _img!.path,
                });
              },
              icon: const Icon(Icons.check),
              label: const Text('Guardar Paso'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            )
          ],
        ),
      ),
    );
  }

  void _showMenu() {
    showModalBottomSheet(context: context, builder: (_) => SafeArea(child: Wrap(children: [
      ListTile(leading: const Icon(Icons.camera), title: const Text('Cámara'), onTap: () { Navigator.pop(context); _pick(ImageSource.camera); }),
      ListTile(leading: const Icon(Icons.image), title: const Text('Galería'), onTap: () { Navigator.pop(context); _pick(ImageSource.gallery); }),
    ])));
  }
}