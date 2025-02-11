import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination/offers_cubit.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => OfferCubit(const OfferParams()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Builder(builder: (context) {
          final offers = context.watch<OfferCubit>();

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: offers.state.items
                .map((item) => item.item.items)
                .expand((element) => element)
                .map((e) => Text(e.title))
                .toList(),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'fetch more',
        onPressed: () async {
          await context.read<OfferCubit>().fetchNextPage();
        },
        child: const Icon(Icons.arrow_downward_outlined),
      ),
    );
  }
}
