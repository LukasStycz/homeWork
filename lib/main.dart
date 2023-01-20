import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constObjects.dart';
import 'home_page.dart';
import 'home_work_cubit/homework_cubit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ConstObjects.title,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('pl', ''),
      ],
      localeListResolutionCallback: (
        locale,
        supportedLocales,
      ) {
        if (supportedLocales.any((locale) => false)) {
          return supportedLocales.first;
        } else {
          return basicLocaleListResolution(locale, supportedLocales);
        }
      },
      home: BlocProvider(
        create: (context) => HomeworkCubit(),
        child: const HomePage(),
      ),
    );
  }
}
