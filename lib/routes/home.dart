import 'package:fispawn/classes/recent.dart';
import 'package:fispawn/data/drawer_actions.dart';
import 'package:fispawn/models/category.dart';
import 'package:fispawn/providers/user.dart';
import 'package:fispawn/routes/fis.dart';
import 'package:flutter/material.dart';
import 'package:fispawn/interface/server.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final List<RecentFispawn> recents = [
    RecentFispawn(),
    RecentFispawn(),
    RecentFispawn(),
    RecentFispawn(),
    RecentFispawn(),
    RecentFispawn(),
    RecentFispawn(),
    RecentFispawn(),
  ];

  final _xController = ScrollController();
  final _yController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              color: Colors.blue,
              height: 200,
              width: double.infinity,
            ),
            TextButton(
                onPressed: () {
                  Provider.of<GoogleSignInProvider>(context, listen: false)
                      .signOut();
                },
                child: Text('Sign out')),
            Column(
              children: drawerActions
                  .map(
                    (drawerAction) => ListTile(
                      leading: Icon(drawerAction.icon),
                      title: Text(drawerAction.title),
                      onTap: () => drawerAction.action,
                    ),
                  )
                  .toList(),
            ),
            Container(
              height: 40,
              width: double.infinity,
              color: Colors.blue,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Fispawn'),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: ListView(
          controller: _yController,
          children: [
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                controller: _xController,
                itemBuilder: (context, index) {
                  return const Row(
                    children: [
                      RecentFispawnContainer(),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'Choose a category to play in, whether you play solo or with your friends, you are sure to enjoy.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [],
            ),
            Categories(
              controller: _yController,
            )
          ],
        ),
      ),
    );
  }
}

class RecentFispawnContainer extends StatelessWidget {
  const RecentFispawnContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        border: Border.all(
          color: Colors.grey.shade800,
          width: 1,
        ),
      ),
      child: const Column(
        children: [
          Expanded(
            child: Text(
              'With Ayetigbo Samuel and 10 others and this is suppose to overflow',
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InfoTile(
            imageUrl: 'imageUrl',
            title: 'Agriculture',
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.imageUrl, required this.title});
  final String imageUrl;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image.network(
        //   imageUrl,
        //   height: 10,
        //   width: 10,
        // ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 10),
            overflow: TextOverflow.fade,
          ),
        ),
      ],
    );
  }
}

class Categories extends StatefulWidget {
  const Categories({super.key, required this.controller});
  final ScrollController controller;

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final Server server = Server();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: server.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('An Error occured'),
            );
          } else {
            final categories = snapshot.data!;
            return CategoriesList(
              categories: categories,
              controller: widget.controller,
            );
          }
        });
  }
}

class CategoriesList extends StatefulWidget {
  const CategoriesList(
      {super.key, required this.categories, required this.controller});
  final List<Category> categories;
  final ScrollController controller;
  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  int? workingIndex;
  bool isLoading = false;

  void setWorkingIndex(int? newWorkingIndex) {
    setState(() {
      workingIndex = newWorkingIndex;
    });
  }

  void setIsLoading(bool newIsLoading) {
    setState(() {
      isLoading = newIsLoading;
    });
  }

  void setWorkingStatus(int? newWorkingIndex, bool newIsLoading) {
    setState(() {
      workingIndex = newWorkingIndex;
      isLoading = newIsLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.controller,
      shrinkWrap: true,
      itemCount: widget.categories.length,
      itemBuilder: ((context, index) {
        final category = widget.categories.elementAt(index);
        return CategoryContainer(
          name: category.name,
          imgURL: category.imgURL,
          noOfParticipants: category.noOfParticipants,
          workingIndex: workingIndex,
          setWorkingIndex: setWorkingIndex,
          setIsLoading: setIsLoading,
          setWorkingStatus: setWorkingStatus,
          index: index,
          isLoading: isLoading,
        );
      }),
    );
  }
}

typedef MyFunctionInt = void Function(int?);
typedef MyFunctionBool = void Function(bool);
typedef MyFunction = void Function(int?, bool);

class CategoryContainer extends StatelessWidget {
  CategoryContainer({
    super.key,
    required this.name,
    required this.imgURL,
    required this.noOfParticipants,
    required this.setWorkingIndex,
    required this.setIsLoading,
    required this.setWorkingStatus,
    required this.workingIndex,
    required this.index,
    required this.isLoading,
  });
  final String name;
  final String imgURL;
  final int noOfParticipants;
  final MyFunctionInt setWorkingIndex;
  final MyFunctionBool setIsLoading;
  final MyFunction setWorkingStatus;
  final int? workingIndex;
  final int index;
  final bool isLoading;
  final Server server = Server();
  @override
  Widget build(BuildContext context) {
    final isActive = workingIndex == index && isLoading;
    return InkWell(
      onTap: () {
        if (isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please wait.'),
            ),
          );
        } else {
          setWorkingStatus(index, true);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          border: Border.all(
            color: Colors.grey.shade800,
            width: 1,
          ),
        ),
        child: isActive
            ? Row(
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: server.createNewFIS(name),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Working on it, please wait',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              CircularProgressIndicator(),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          Future.delayed(Duration(seconds: 1), () {
                            setIsLoading(false);
                          });
                          return const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Something went wrong',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Icon(Icons.error),
                            ],
                          );
                        } else {
                          Future.delayed(Duration(seconds: 1), () {
                            setWorkingStatus(null, false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyFIS(),
                              ),
                            );
                          });
                          return const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Done',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Icon(Icons.done),
                            ],
                          );
                        }
                      }),
                    ),
                  ),
                  Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  )
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2000),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text('$noOfParticipants'),
                    ),
                  ),
                  Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                ],
              ),
      ),
    );
  }
}
