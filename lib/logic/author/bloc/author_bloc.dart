import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/logic/authors/models/author_element.dart';

part 'author_event.dart';
part 'author_state.dart';

class AuthorBloc extends Bloc<AuthorEvent, AuthorState> {
  final AccountRepository accountRepository;

  AuthorBloc({required this.accountRepository}) : super(const AuthorState()) {
    on<AuthorFetched>(_onAuthorFetched);
  }

  void _onAuthorFetched(AuthorFetched event, Emitter<AuthorState> emit) async {
    emit(state.copyWith(fetchedStatus: AuthorFetchedStatus.loading));

    final author = await accountRepository.getUser(idAccount: event.idAccount);
    print(author);
    emit(state.copyWith(
      authorElement: AuthorElement(author!, AuthorFollowStatus.success),
      fetchedStatus: AuthorFetchedStatus.success,
    ));
  }
}
