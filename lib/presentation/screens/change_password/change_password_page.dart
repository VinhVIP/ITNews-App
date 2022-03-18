import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:it_news/logic/change_password/bloc/change_password_bloc.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordBloc(
        accountRepository: AccountRepository(
          httpClient: http.Client(),
        ),
      ),
      child: const ChangePassword(),
    );
  }
}

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();

  bool _isOldPassObscure = true;
  bool _isNewPassObscure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    oldPassController.dispose();
    newPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Đổi mật khẩu"),
        backgroundColor: Colors.green,
      ),
      body: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listenWhen: (previous, current) {
          return current.message.isNotEmpty;
        },
        listener: (context, state) {
          Utils.showMessageDialog(
            context: context,
            title: 'Thông báo',
            content: state.message,
          );
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            children: [
              const Text(
                "Mật khẩu sau khi thay đổi thành công sẽ tự động được cập nhật tại màn hình đăng nhập!",
                style: TextStyle(
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _oldPassInput(),
              const SizedBox(height: 20),
              _newPassInput(),
              const SizedBox(height: 20),
              _updateButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _oldPassInput() {
    return TextFormField(
      controller: oldPassController,
      obscureText: _isOldPassObscure,
      decoration: InputDecoration(
        fillColor: Colors.blue[50],
        filled: true,
        prefixIcon: const Icon(Icons.person),
        suffixIcon: IconButton(
          icon: Icon(
            _isOldPassObscure ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isOldPassObscure = !_isOldPassObscure;
            });
          },
        ),
        labelText: 'Mật khẩu cũ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _newPassInput() {
    return TextFormField(
      controller: newPassController,
      obscureText: _isNewPassObscure,
      decoration: InputDecoration(
        fillColor: Colors.blue[50],
        filled: true,
        prefixIcon: const Icon(Icons.person),
        suffixIcon: IconButton(
          icon: Icon(
            _isNewPassObscure ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isNewPassObscure = !_isNewPassObscure;
            });
          },
        ),
        labelText: 'Mật khẩu mới',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _updateButton() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (context, state) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          shadowColor: Colors.red,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          minimumSize: const Size(200, 50),
        ),
        onPressed: () {
          if (state.status == ChangePasswordStatus.loading) return;

          BlocProvider.of<ChangePasswordBloc>(context).add(
            ChangePasswordEvent(
              oldPass: oldPassController.text,
              newPass: newPassController.text,
            ),
          );
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Cập nhật',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 10,
            ),
            _updateLoading(),
          ],
        ),
      );
    });
  }

  Widget _updateLoading() {
    return BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == ChangePasswordStatus.loading
            ? const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3.0,
                ),
              )
            : const SizedBox(
                width: 30,
                height: 30,
                child: Icon(Icons.arrow_forward_rounded),
              );
      },
    );
  }
}
