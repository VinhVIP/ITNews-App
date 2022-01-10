import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:it_news/data/store/shared_preferences.dart';
import 'package:it_news/logic/login/bloc/login_bloc.dart';
import 'package:it_news/presentation/router/app_router.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Đăng nhập thất bại!')),
            );
        } else if (state.status.isSubmissionSuccess) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
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
            const SizedBox(height: 50),
            _UsernameInput(),
            const SizedBox(height: 20),
            _PasswordInput(),
            const _ForgotPassword(),
            const SizedBox(height: 10),
            _LoginButton(),
            const SizedBox(height: 20),
            const _GoToSignUp(),
          ],
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: LocalStorage.getAccountName(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String user = snapshot.data!;
          context.read<LoginBloc>().add(LoginUsernameChanged(user));

          return BlocBuilder<LoginBloc, LoginState>(
            buildWhen: (previous, current) =>
                previous.username != current.username,
            builder: (context, state) {
              return TextFormField(
                initialValue: user,
                onChanged: (username) => context
                    .read<LoginBloc>()
                    .add(LoginUsernameChanged(username)),
                decoration: InputDecoration(
                  fillColor: Colors.blue[50],
                  filled: true,
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'Tên đăng nhập',
                  errorText: state.username.invalid
                      ? 'Tên đăng nhập không được bỏ trống!'
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
        return Container();
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: LocalStorage.getPassword(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String pass = snapshot.data!;
          context.read<LoginBloc>().add(LoginPasswordChanged(pass));

          return BlocBuilder<LoginBloc, LoginState>(
            buildWhen: (previous, current) =>
                previous.password != current.password,
            builder: (context, state) {
              return TextFormField(
                initialValue: pass,
                onChanged: (password) => context
                    .read<LoginBloc>()
                    .add(LoginPasswordChanged(password)),
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.blue[50],
                  filled: true,
                  labelText: 'Mật khẩu',
                  errorText: state.password.invalid
                      ? 'Mật khẩu không được bỏ trống!'
                      : null,
                  prefixIcon: const Icon(Icons.lock),
                  labelStyle: const TextStyle(color: Colors.blue),
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
        return Container();
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
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
                    context.read<LoginBloc>().add(LoginSubmitted());
                  }
                : null,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const [
                Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 10,
                ),
                _LoginButtonLoading(),
              ],
            ),
          );
        });
  }
}

class _LoginButtonLoading extends StatelessWidget {
  const _LoginButtonLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
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

class _ForgotPassword extends StatelessWidget {
  const _ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: const Text(
            "Quên mật khẩu?",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _GoToSignUp extends StatelessWidget {
  const _GoToSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Chưa có tài khoản?",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        TextButton(
          child: const Text(
            "Đăng ký ngay!",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 17,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRouter.signup);
          },
        ),
      ],
    );
  }
}
