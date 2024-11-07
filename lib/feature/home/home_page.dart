import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String name = "HomePage";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool colorChanged = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapi Taller'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Card(
              color: colorChanged ? Colors.amberAccent.shade200 : Colors.white,
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    // Imagen del personaje
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Información del personaje
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rick Sanchez',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Status: Alive',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        Text(
                          'Species: Human',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        Text(
                          'Origin: Earth',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        Text(
                          'Location: Earth',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    const Expanded(
                        child: SizedBox(
                      width: 1,
                    )),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          colorChanged = !colorChanged;
                        });
                      },
                      icon: const Icon(Icons.color_lens),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
