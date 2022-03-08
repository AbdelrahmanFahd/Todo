import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets.dart';
import 'task_screen.dart';
import '../database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            color: Colors.grey[200],
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 32.0, top: 32.0),
                    child: const Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                  Expanded(
                      child: FutureBuilder(
                    initialData: [Task()],
                    future: DatabaseHelper().getTaskData(),
                    builder: (ctx, AsyncSnapshot<List<Task>> snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF7349FE),
                                ),
                              )
                            : ScrollConfiguration(
                                behavior: NoGlowBehaviour(),
                                child: ListView.builder(
                                  itemCount: snapShot.data?.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => TaskScreen(
                                                  task: snapShot.data![index],
                                                )),
                                      ).then((value) {
                                        setState(() {});
                                      });
                                    },
                                    child: TaskCard(
                                        title: snapShot.data![index].title,
                                        description: snapShot
                                            .data![index].description
                                            .toString()),
                                  ),
                                ),
                              ),
                  )),
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => const TaskScreen(
                                task: null,
                              )),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ])),
      ),
    );
  }
}
