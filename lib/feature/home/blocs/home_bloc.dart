import 'dart:async';

import 'package:chapitec_app/core/utils/api_client.dart';
import 'package:chapitec_app/feature/home/models/character_model.dart';

class HomeBLoc {
  APIClient apiClient = APIClient(url: "https://rickandmortyapi.com/api");

  var listCharacters = <CharactersPeoples>[];

  final _listCharacterController =
      StreamController<StreamsResponse>.broadcast();

  Stream<StreamsResponse> get getStreamCharacterList =>
      _listCharacterController.stream;

  Future<void> callApiListCharacters() async {
    try {
      final request = await apiClient.get('/character');
      if (request?.statusCode != 200) {
        _listCharacterController.sink.add(StreamsResponse.statusError());
        return;
      }
      var listItems = request?.data['results'] as List;
      var newlistCharacters = listItems.map((v) {
        return CharactersPeoples.fromJson(v);
      }).toList();
      listCharacters = newlistCharacters;
      _listCharacterController.sink.add(StreamsResponse.statusCorrect(
        data: listCharacters,
      ));
    } catch (e) {
      _listCharacterController.sink.add(StreamsResponse.statusError());
    }
  }
}

class StreamsResponse {
  var status = StreamStatus.none;
  String message = "";
  dynamic data;

  StreamsResponse();

  StreamsResponse.statusCorrect({String? message, this.data}) {
    status = StreamStatus.correct;
    this.message = message ?? "";
  }

  StreamsResponse.statusError({String? message}) {
    this.message = message ?? '';
    status = StreamStatus.error;
  }
  StreamsResponse.statuLoading() {
    status = StreamStatus.loading;
  }
}

enum StreamStatus { loading, correct, error, none }
