import 'package:chapitec_app/feature/home/blocs/home_bloc.dart';
import 'package:chapitec_app/feature/home/models/character_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String name = "HomePage";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool colorChanged = false;
  final bloc = HomeBLoc();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      bloc.callApiListCharacters();
    });
    super.initState();
  }

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
            StreamBuilder(
                stream: bloc.getStreamCharacterList,
                initialData: StreamsResponse.statuLoading(),
                builder: (context, snapshot) {
                  if (snapshot.data?.status == StreamStatus.error) {
                    return const Center(
                      child: Icon(Icons.warning),
                    );
                  }
                  if (snapshot.data?.status == StreamStatus.loading) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final model = snapshot.data?.data as List<CharactersPeoples>;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: model.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: colorChanged
                                ? Colors.amberAccent.shade200
                                : Colors.white,
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  // Imagen del personaje
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      model[index].image ?? '',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  // Información del personaje
                                  SizedBox(
                                    width: 140,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          model[index].name ?? '',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Status: ${model[index].status}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700]),
                                        ),
                                        Text(
                                          'Species: ${model[index].species}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700]),
                                        ),
                                        Text(
                                          'Origin: ${model[index].origin?.name}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          'Location: ${model[index].location?.name}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.grey[700]),
                                        ),
                                      ],
                                    ),
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
                                    onPressed: () {
                                      if (model[index].id != null) {
                                        bloc.removeItems(model[index].id!);
                                      }
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
