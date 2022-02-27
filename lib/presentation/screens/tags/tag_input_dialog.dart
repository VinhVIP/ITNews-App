import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:it_news/data/models/tag.dart';
import 'package:it_news/logic/tags/bloc/tags_bloc.dart';

class TagInputDialog extends StatefulWidget {
  const TagInputDialog(
      {Key? key, this.tag, required this.ctx, required this.isCreateNew})
      : super(key: key);
  final Tag? tag;
  final BuildContext ctx;
  final bool isCreateNew;

  @override
  State<TagInputDialog> createState() => _TagInputDialogState();
}

class _TagInputDialogState extends State<TagInputDialog> {
  late final TextEditingController _tagNameController;
  File? _pickedLogo;
  String? errTagName;
  String? errLogo;

  @override
  void initState() {
    super.initState();
    _tagNameController = TextEditingController();
    if (widget.tag != null) {
      _tagNameController.text = widget.tag!.name;
    } else {
      errLogo = "Logo không được bỏ trống";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            const SizedBox(height: 15),
            _buildInputTagName(context),
            const SizedBox(height: 10),
            _buildLogo(context),
            const SizedBox(height: 10),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.isCreateNew ? "Thêm Thẻ" : "Chỉnh sửa Thẻ",
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildInputTagName(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const Align(alignment: Alignment.topLeft, child: Text("Tên thẻ: ")),
        const SizedBox(height: 10),
        TextField(
          controller: _tagNameController,
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                errTagName = "Tên thẻ không được bỏ trống";
              } else {
                errTagName = null;
              }
            });
          },
          decoration: InputDecoration(
            hintText: "Nhập tên thẻ",
            errorText: errTagName,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Logo:"),
        _pickedLogo != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: Image.file(
                  _pickedLogo!,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              )
            : widget.tag != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.tag!.logo,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Icon(Icons.tag),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.tag),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: const Icon(Icons.tag),
                  ),
        IconButton(
          onPressed: () {
            _getFromGallery(context);
          },
          padding: EdgeInsets.zero,
          splashRadius: 20,
          icon: const Icon(
            Icons.image,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ElevatedButton(
        onPressed: errTagName == null && errLogo == null
            ? () {
                if (widget.isCreateNew) {
                  BlocProvider.of<TagsBloc>(widget.ctx).add(
                    TagAdded(
                      name: _tagNameController.text.trim(),
                      logo: _pickedLogo!,
                    ),
                  );
                } else {
                  BlocProvider.of<TagsBloc>(widget.ctx).add(
                    TagUpdated(
                      idTag: widget.tag!.idTag,
                      name: _tagNameController.text.trim(),
                      logo: _pickedLogo,
                    ),
                  );
                }

                Navigator.pop(context);
              }
            : null,
        child: Text(widget.isCreateNew ? "Thêm" : "Cập nhật"));
  }

  /// Get from gallery
  _getFromGallery(context) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File f = File(pickedImage.path);
      setState(() {
        _pickedLogo = f;
        if (widget.isCreateNew) {
          errLogo = null;
        }
      });
    } else {
      print("Chưa chọn ảnh");
    }
  }
}
