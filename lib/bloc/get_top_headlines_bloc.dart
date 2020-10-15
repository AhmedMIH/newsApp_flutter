import 'package:newsapp/model/article_response.dart';
import 'package:newsapp/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetTopHeadlinesBloc {
  final NewsRepository _repository = NewsRepository();
  final PublishSubject<ArticleResponse> _subject =
  PublishSubject<ArticleResponse>();


  getHeadlines() async {
    ArticleResponse response = await _repository.getHeadlines();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  PublishSubject<ArticleResponse> get subject => _subject;

}
final getTopHeadlinesBloc = GetTopHeadlinesBloc();