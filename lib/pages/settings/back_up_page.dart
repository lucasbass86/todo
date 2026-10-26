import 'package:flutter/material.dart';
import 'package:todo/dialogs/dialogs.dart';
import 'package:todo/hive/boxes.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/preferences/preferences.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/services/backup_service.dart';
import 'package:todo/themes/themes.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/utils/utils.dart';

class BackUpPage extends StatefulWidget {
  static const String routeName = 'BackUpPage';
  const BackUpPage({super.key});

  @override
  State<BackUpPage> createState() => _BackUpPageState();
}

class _BackUpPageState extends State<BackUpPage> {
  late TaskProvider taskProvider;
  TextEditingController emailController = TextEditingController(text: Preferences.email);
  @override
  Widget build(BuildContext context) {
    taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text('Copias de seguridad'),
        ),
        centerTitle: false,
      ),
      body: Column(children: [_backUp(context)]),
    );
  }

  Widget _backUp(BuildContext context) {
    _checkPassword(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email para las copias', style: TextStyle(color: AppTheme.primary, fontSize: 17)),
          20.h,
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  child: TextField(
                    controller: emailController,
                    enabled: Preferences.email.isEmpty,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'email', counterText: ''),
                  ),
                ),
              ),
              if (Preferences.email.isEmpty)
                IconButton(
                  onPressed: () async {
                    if (emailController.text.isEmpty) {
                      _showSnackBar('Introduce el email', isGood: false);
                    } else {
                      String pass = '';
                      if (Preferences.passBackUp.isEmpty) {
                        pass = await _askPassword(context);
                        if (pass.isEmpty) {
                          return;
                        } else {
                          Preferences.passBackUp = pass;
                        }
                      }
                      _showSnackBar('Email guardado');
                      Preferences.email = emailController.text;
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {});
                    }
                  },
                  icon: Icon(Icons.save),
                ),
              if (Preferences.email.isNotEmpty)
                IconButton(
                  onPressed: () async {
                    final resp = await showMessage(
                      context: context,
                      title: '¿Quitar el email?',
                      showCancel: true,
                    );
                    if (resp && context.mounted) {
                      final confirm = await showSlideToUnlock(
                        context,
                        backColor: AppTheme.onSurface,
                        slideColor: AppTheme.surface,
                      );
                      if (confirm) {
                        Preferences.email = '';
                        emailController.text = '';
                        Preferences.backUp = '';
                        Preferences.passBackUp = '';
                        setState(() {});
                      }
                    }
                  },
                  icon: Icon(Icons.emergency_rounded, semanticLabel: 'Eliminar el email'),
                ),
            ],
          ),
          if (Preferences.email.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _uploadDataToInternet(context),
                    _downloadFromInternet(context),
                    IconButton(
                      onPressed: () async {
                        await showMessage(
                          context: context,
                          title: '¿Borrar todos los datos de la copia?',
                          showCancel: true,
                        ).then((value) {
                          if (value && context.mounted) {
                            showSlideToUnlock(
                              context,
                              backColor: AppTheme.onSurface,
                              slideColor: AppTheme.surface,
                            ).then((unlock) {
                              if (unlock) {
                                BackupService.deleteBackUp(emailController.text).then((_) {
                                  Preferences.email = '';
                                  Preferences.backUp = '';
                                  Preferences.passBackUp = '';
                                  setState(() {});
                                  _showSnackBar('Datos borrados');
                                });
                              }
                            });
                          }
                        });
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Text(
                  'Última copia: ${Preferences.backUp.isEmpty ? '--/--/----' : Utils.dateEnglishToSpanish(DateTime.parse(Preferences.backUp))}',
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Aviso días copia'),
                    Container(
                      height: 50,
                      width: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: DropdownButton(
                        value: Preferences.backupDays,
                        borderRadius: BorderRadius.circular(20),
                        underline: Container(),
                        isExpanded: true,
                        iconEnabledColor: AppTheme.onSurface,
                        items: [10, 20, 30, 40, 50, 60]
                            .map((d) => DropdownMenuItem(value: d, child: Text(d.toString())))
                            .toList(),
                        onChanged: (value) => setState(() => Preferences.backupDays = value!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _checkPassword(BuildContext context) async {
    Future.delayed(const Duration(milliseconds: 400), () async {
      if (Preferences.passBackUp.isEmpty && context.mounted && Preferences.email.isNotEmpty) {
        Preferences.passBackUp = await _askPassword(context);
      }
    });
  }

  Future<String> _askPassword(BuildContext context) async {
    final pass = await password(
      context,
      subtitle: 'Para poder reestablecer las copias de seguridad.',
    );
    if (!pass[0] || pass == null) return '';
    if (!context.mounted) return '';
    final pass2 = await password(context, title: 'Repite password');
    if (!context.mounted || pass == null || pass.isEmpty || !pass[0]) {
      return '';
    }
    if (pass[1] != pass2[1]) {
      _showSnackBar('Las contraseñas no coinciden', isGood: false);
      return '';
    }
    return pass[1];
  }

  Widget _uploadDataToInternet(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final res = await showSlideToUnlock(
          context,
          backColor: AppTheme.onSurface,
          slideColor: AppTheme.surface,
        );
        if (res) {
          User user = User(
            email: emailController.text,
            password: Preferences.passBackUp,
            categories: taskProvider.categories,
            tasks: taskProvider.tasks,
          );
          await BackupService.addBackUp(user);
          _showSnackBar('Copia subida', isGood: true);
          Preferences.backUp = DateTime.now().toString();
          setState(() {});
        }
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [Text('Subir datos'), const SizedBox(height: 5), Icon(Icons.backup_sharp)],
        ),
      ),
    );
  }

  Widget _downloadFromInternet(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (emailController.text.isNotEmpty) {
          User? user = await BackupService.getBackUp(emailController.text);
          if (!context.mounted) return;
          final passResult = await password(context);
          if (passResult[1] != Preferences.passBackUp && passResult[1] != user!.password) {
            _showSnackBar('Contraseña incorrecta', isGood: false);
            return;
          }

          if (context.mounted) {
            final confirmed = await showMessage(
              context: context,
              title: 'Si hay datos, estos se sustituirán. ¿Sustituir?',
              showCancel: true,
            );
            if (confirmed && context.mounted) {
              final unlock = await showSlideToUnlock(
                context,
                backColor: AppTheme.onSurface,
                slideColor: AppTheme.surface,
              );
              if (unlock && context.mounted) {
                _setData(context, user!);
              }
            } else {
              _showSnackBar('Proceso omitido');
            }
          } else {
            _showSnackBar('Email no encontrado', isGood: false);
          }
        } else {
          _showSnackBar('Introduce el correo', isGood: false);
        }
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [Text('Cargar datos'), const SizedBox(height: 5), Icon(Icons.restore)],
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool isGood = true}) {
    if (!mounted) return;
    (Utils.snackBar(context, message, isBad: !isGood));
  }

  void _setData(BuildContext context, User user) async {
    taskProvider.categories = user.categories;
    taskProvider.tasks = user.tasks;

    await Boxes.categories.deleteAll(Boxes.categories.keys);
    await Boxes.tasks.deleteAll(Boxes.tasks.keys);

    for (TaskCategory c in user.categories) {
      await Boxes.categories.put(c.id, c.toJson());
    }
    for (Task t in user.tasks) {
      await Boxes.tasks.put(t.id, t.toJson());
    }
    _showSnackBar('Datos cargados', isGood: true);
    taskProvider.notify();
  }
}

Future<dynamic> password(
  BuildContext context, {
  String title = 'Introduce el password',
  String? subtitle,
}) {
  final TextEditingController edPassword = TextEditingController();
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            if (subtitle != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(subtitle, style: TextStyle(fontSize: 17)),
                ],
              ),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return TextField(
              onChanged: (value) {},
              controller: edPassword,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Password'),
            );
          },
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop([false]),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop([true, edPassword.text]),
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}
