import 'package:fluent_ui/fluent_ui.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      content: Center(
        child: ProgressRing(),
      ),
    );
  }
}
