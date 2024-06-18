import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final artistController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    songNameController.dispose();
    artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        homeViewModelProvider.select((value) => value?.isLoading == true));
    return Scaffold(
        appBar: AppBar(
          title: const Text('Upload Song'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (formKey.currentState!.validate() &&
                            selectedImage != null &&
                            selectedAudio != null) {
                          await ref
                              .read(homeViewModelProvider.notifier)
                              .uploadSong(
                                  thumbnail: selectedImage!,
                                  song: selectedAudio!,
                                  songName: songNameController.text.trim(),
                                  artist: artistController.text.trim(),
                                  color: selectedColor);
                        } else {
                          showSnackBar(context, 'Missing Fields');
                        }
                      },
                icon: const Icon(Icons.check))
          ],
          bottom: isLoading
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(10),
                  child: LinearProgressIndicator(),
                )
              : null,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: selectImage,
                    child: selectedImage != null
                        ? SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ))
                        : DottedBorder(
                            color: Pallete.borderColor,
                            borderType: BorderType.RRect,
                            strokeCap: StrokeCap.round,
                            radius: const Radius.circular(10),
                            dashPattern: const [10, 4],
                            child: const SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.folder_open,
                                    size: 40,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Select the thumbnail for your song',
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 40),
                  selectedAudio != null
                      ? AudioWaveWidget(path: selectedAudio!.path)
                      : CustomField(
                          hintText: 'Pick Song',
                          controller: null,
                          isReadOnly: true,
                          onTap: selectAudio,
                        ),
                  const SizedBox(height: 20),
                  CustomField(
                    hintText: 'Artist',
                    controller: artistController,
                  ),
                  const SizedBox(height: 20),
                  CustomField(
                    hintText: 'Song Name',
                    controller: songNameController,
                  ),
                  const SizedBox(height: 20),
                  ColorPicker(
                    pickersEnabled: const {
                      ColorPickerType.wheel: true,
                    },
                    onColorChanged: (c) {
                      selectedColor = c;
                    },
                    color: selectedColor,
                    heading: const Text('Select color'),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
