import 'dart:io';

import 'package:avatar_view/avatar_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:it_news/core/utils/utils.dart';
import 'package:it_news/data/repositories/account_repository.dart';
import 'package:http/http.dart' as http;
import 'package:it_news/logic/profile/bloc/profile_bloc.dart';
import 'package:path/path.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(
        accountRepository: AccountRepository(
          httpClient: http.Client(),
        ),
      ),
      child: const ProfileEdit(),
    );
  }
}

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

enum Gender { male, female }

class _ProfileEditState extends State<ProfileEdit> {
  TextEditingController realNameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  Gender? gender = Gender.male;

  File? pickedAvatar;

  @override
  void initState() {
    super.initState();
    realNameController.text = Utils.user.realName;
    birthController.text = Utils.user.birth;
    phoneController.text = Utils.user.phone;
    companyController.text = Utils.user.company;
    if (Utils.user.gender == 0) {
      gender = Gender.male;
    } else {
      gender = Gender.female;
    }
  }

  @override
  void dispose() {
    realNameController.dispose();
    birthController.dispose();
    phoneController.dispose();
    companyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) {
        return current.message.isNotEmpty;
      },
      listener: (context, state) {
        Utils.showMessageDialog(
          context: context,
          title: "Thông báo",
          content: state.message,
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Sửa thông tin"),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            children: [
              _avatar(context),
              const SizedBox(height: 20),
              _realNameInput(),
              const SizedBox(height: 20),
              _birthInput(context),
              const SizedBox(height: 20),
              _genderChoice(),
              const SizedBox(height: 20),
              _phoneInput(),
              const SizedBox(height: 20),
              _companyInput(),
              const SizedBox(height: 20),
              _updateButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _avatar(context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        pickedAvatar != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.file(
                  pickedAvatar!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
            : Utils.user.avatar.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: CachedNetworkImage(
                      imageUrl: Utils.user.avatar,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )
                : SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Container(
                        color: Colors.greenAccent,
                        child: const Icon(Icons.person),
                      ),
                    ),
                  ),
        Padding(
          padding: const EdgeInsets.only(top: 65, left: 75),
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Colors.black12,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                // _getFromGallery(context);
                // _getFromCamera(context);
                showBottomModal(context);
              },
              padding: EdgeInsets.zero,
              splashRadius: 20,
              icon: const Icon(
                Icons.camera_enhance_sharp,
                color: Colors.black45,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Get from gallery
  _getFromGallery(context) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File f = File(pickedImage.path);
      setState(() {
        pickedAvatar = f;
      });
      // BlocProvider.of<ProfileBloc>(context).add(ProfileUpdatedAvatar(f));
    } else {
      print("Chưa chọn ảnh");
    }
  }

  /// Get from gallery
  _getFromCamera(context) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      File f = File(pickedImage.path);
      int sz = f.lengthSync();
      // print("path: " + f.len + " " + basename(f.path));
      // print("picked path: " + pickedImage.path);
      BlocProvider.of<ProfileBloc>(context).add(ProfileUpdatedAvatar(f));
    } else {
      print("Chưa chọn ảnh");
    }
  }

  Widget _updateButton() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
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
          if (state.updateStatus == ProfileUpdateStatus.loading) return;

          if (pickedAvatar != null) {
            print("update info include avatar");

            BlocProvider.of<ProfileBloc>(context).add(
              ProfileUpdatedFull(
                realName: realNameController.text.trim(),
                birth: birthController.text,
                gender: gender == Gender.male ? 0 : 1,
                phone: phoneController.text.trim(),
                company: companyController.text.trim(),
                avatar: pickedAvatar,
              ),
            );
          } else {
            BlocProvider.of<ProfileBloc>(context).add(
              ProfileUpdated(
                realName: realNameController.text.trim(),
                birth: birthController.text,
                gender: gender == Gender.male ? 0 : 1,
                phone: phoneController.text.trim(),
                company: companyController.text.trim(),
              ),
            );
          }
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
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) =>
          previous.updateStatus != current.updateStatus,
      builder: (context, state) {
        return state.updateStatus == ProfileUpdateStatus.loading
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

  Widget _companyInput() {
    return TextFormField(
      controller: companyController,
      decoration: InputDecoration(
        fillColor: Colors.blue[50],
        filled: true,
        prefixIcon: const Icon(Icons.work),
        labelText: 'Cơ quan / trường học',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _phoneInput() {
    return TextFormField(
      controller: phoneController,
      maxLength: 50,
      decoration: InputDecoration(
        fillColor: Colors.blue[50],
        filled: true,
        prefixIcon: const Icon(Icons.phone),
        labelText: 'Điện thoại',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _genderChoice() {
    return Row(
      children: [
        const Text(
          " Giới tính:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Nam'),
            leading: Radio<Gender>(
              value: Gender.male,
              groupValue: gender,
              onChanged: (Gender? value) {
                setState(() {
                  gender = value;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Nữ'),
            leading: Radio<Gender>(
              value: Gender.female,
              groupValue: gender,
              onChanged: (Gender? value) {
                setState(() {
                  gender = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _birthInput(BuildContext context) {
    return TextFormField(
      controller: birthController,
      onTap: () async {
        // Below line stops keyboard from appearing
        FocusScope.of(context).requestFocus(FocusNode());

        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          birthController.text = "${date.day}/${date.month}/${date.year}";
        }
      },
      decoration: InputDecoration(
        fillColor: Colors.blue[50],
        filled: true,
        prefixIcon: const Icon(Icons.date_range),
        labelText: 'Ngày sinh',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _realNameInput() {
    return TextFormField(
      controller: realNameController,
      maxLength: 50,
      decoration: InputDecoration(
        counterText: '',
        fillColor: Colors.blue[50],
        filled: true,
        prefixIcon: const Icon(Icons.person),
        labelText: 'Tên hiển thị',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void showBottomModal(context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return Wrap(
          children: [
            pickedFromCamera(context),
            pickedFromGallery(context),
          ],
        );
      },
    );
  }

  Widget pickedFromCamera(context) {
    return InkWell(
      onTap: () {
        _getFromCamera(context);
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: Icon(Icons.camera_enhance, color: Colors.green),
        title: Text("Chụp ảnh mới"),
      ),
    );
  }

  Widget pickedFromGallery(context) {
    return InkWell(
      onTap: () {
        _getFromGallery(context);
        Navigator.pop(context);
      },
      child: const ListTile(
        leading: Icon(Icons.image, color: Colors.green),
        title: Text("Chọn ảnh từ thư viện"),
      ),
    );
  }
}
