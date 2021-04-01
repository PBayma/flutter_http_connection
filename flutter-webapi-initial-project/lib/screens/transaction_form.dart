import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class TransactionFormState {
  const TransactionFormState();
}

@immutable
class ShowFormState extends TransactionFormState {
  const ShowFormState();
}

@immutable
class SendingState extends TransactionFormState {
  const SendingState();
}

@immutable
class SentState extends TransactionFormState {
  const SentState();
}

@immutable
class FatalErrorTransactionFormState extends TransactionFormState {
  const FatalErrorTransactionFormState();
}

class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit() : super(ShowFormState());
  final TransactionWebClient _webClient = TransactionWebClient();

  save(Transaction transactionCreated, BuildContext context) {
    emit(SendingState());
    _webClient.save(transactionCreated).then((transaction) {
      if (transaction != null) {
        Navigator.pop(context);
      }
    });
    emit(SentState());
  }
}

class TransactionFormContainer extends BlocContainer {
  final Contact _contact;

  TransactionFormContainer(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionFormCubit>(
        create: (BuildContext context) {
          return TransactionFormCubit();
        },
        child: TransactionForm(_contact));
  }
}

class TransactionForm extends StatelessWidget {
  final Contact _contact;

  TransactionForm(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionFormCubit, TransactionFormState>(
        builder: (context, state) {
      if (state is ShowFormState) {
        return _BasicForm(_contact);
      }
      if (state is SendingState) {
        return ProgressView();
      }
      if (state is SentState) {
        Navigator.pop(context);
      }
      if (state is FatalErrorTransactionFormState) {
        return Text('Tela de erro');
      }
      return Text('Erro!!');
    });
  }
}

class _BasicForm extends StatelessWidget {
  final Contact _contact;
  _BasicForm(this._contact);

  final TextEditingController _valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value =
                          double.tryParse(_valueController.text);
                      final transactionCreated = Transaction(value, _contact);
                      BlocProvider.of<TransactionFormCubit>(context)
                          .save(transactionCreated, context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
