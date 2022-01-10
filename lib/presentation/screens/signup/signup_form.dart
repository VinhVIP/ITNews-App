import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:it_news/logic/signup/bloc/signup_bloc.dart';
import 'package:formz/formz.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (ctx, state) {
        if (state.status == FormzStatus.submissionSuccess ||
            state.status == FormzStatus.submissionFailure) {
          _showMyDialog(context, state.message);
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 30),
            _AccountNameInput(),
            const SizedBox(height: 15),
            _RealNameInput(),
            const SizedBox(height: 15),
            _EmailInput(),
            const SizedBox(height: 15),
            _PasswordInput(),
            const SizedBox(height: 15),
            _ConfirmPasswordInput(),
            const SizedBox(height: 25),
            _SignupButton(),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _AccountNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) =>
          previous.accountName != current.accountName,
      builder: (context, state) {
        return TextField(
          maxLength: 50,
          onChanged: (accountName) => context
              .read<SignupBloc>()
              .add(SignupAccountNameChanged(accountName)),
          decoration: InputDecoration(
            counterText: '',
            fillColor: Colors.blue[50],
            filled: true,
            prefixIcon: const Icon(Icons.text_fields),
            suffixText: state.accountName.value.length.toString() + "/50",
            suffixStyle: const TextStyle(fontSize: 12, color: Colors.black45),
            labelText: 'Tên tài khoản',
            labelStyle: const TextStyle(color: Colors.blue),
            errorText: state.accountName.invalid
                ? 'Tên tài khoản không được bỏ trống!'
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RealNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.realName != current.realName,
      builder: (context, state) {
        return TextField(
          maxLength: 50,
          onChanged: (realName) =>
              context.read<SignupBloc>().add(SignupRealNameChanged(realName)),
          decoration: InputDecoration(
            counterText: '',
            fillColor: Colors.blue[50],
            filled: true,
            prefixIcon: const Icon(Icons.person),
            suffixText: state.realName.value.length.toString() + "/50",
            suffixStyle: const TextStyle(fontSize: 12, color: Colors.black45),
            labelText: 'Họ và tên',
            labelStyle: const TextStyle(color: Colors.blue),
            errorText: state.realName.invalid
                ? 'Họ và tên không được bỏ trống!'
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          maxLength: 50,
          onChanged: (email) =>
              context.read<SignupBloc>().add(SignupEmailChanged(email)),
          decoration: InputDecoration(
            counterText: '',
            fillColor: Colors.blue[50],
            filled: true,
            prefixIcon: const Icon(Icons.email),
            suffixText: state.realName.value.length.toString() + "/50",
            suffixStyle: const TextStyle(fontSize: 12, color: Colors.black45),
            labelText: 'Email',
            labelStyle: const TextStyle(color: Colors.blue),
            errorText:
                state.email.invalid ? 'Định dạng email không hợp lệ!' : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (password) =>
              context.read<SignupBloc>().add(SignupPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            fillColor: Colors.blue[50],
            filled: true,
            labelText: 'Mật khẩu',
            prefixIcon: const Icon(Icons.lock),
            labelStyle: const TextStyle(color: Colors.blue),
            errorText:
                state.password.invalid ? 'Mật khẩu không được bỏ trống!' : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(
                color: Colors.blueAccent,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) =>
          previous.confirmPassword != current.confirmPassword,
      builder: (context, state) {
        return TextField(
          onChanged: (confirmPassword) => context
              .read<SignupBloc>()
              .add(SignupConfirmPasswordChanged(confirmPassword)),
          obscureText: true,
          decoration: InputDecoration(
            fillColor: Colors.blue[50],
            filled: true,
            labelText: 'Xác nhận mật khẩu',
            prefixIcon: const Icon(Icons.lock),
            labelStyle: const TextStyle(color: Colors.blue),
            errorText:
                state.confirmPassword.invalid ? 'Mật khẩu không khớp!' : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(
                color: Colors.blueAccent,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SignupButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.status != current.status,
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
          onPressed: state.status.isValidated
              ? () {
                  context.read<SignupBloc>().add(SignupSubmitted());
                }
              : null,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              Text(
                'Đăng ký',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                width: 10,
              ),
              _SignupButtonLoading(),
            ],
          ),
        );
      },
    );
  }
}

class _SignupButtonLoading extends StatelessWidget {
  const _SignupButtonLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
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
