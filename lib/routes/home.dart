import 'package:fispawn/classes/recent.dart';
import 'package:fispawn/data/drawer_actions.dart';
import 'package:fispawn/models/category.dart';
import 'package:fispawn/providers/user.dart';
import 'package:fispawn/routes/fis.dart';
import 'package:flutter/material.dart';
import 'package:fispawn/interface/server.dart';
import 'package:provider/provider.dart';
import 'package:fispawn/widgets/list_tile.dart';

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
                  return Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MyFIS(fisid: 'IZei9pUDHuraLueGbwpa'),
                              ),
                            );
                          },
                          child: RecentFispawnContainer()),
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

  void setIsLoading(bool newIsLoading) {
    setState(() {
      isLoading = newIsLoading;
    });
  }

  final Server server = Server();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.controller,
      shrinkWrap: true,
      itemCount: widget.categories.length,
      itemBuilder: ((context, index) {
        final category = widget.categories.elementAt(index);
        return MyListTile(
          text: category.name,
          errorMessage: 'Fail to create game',
          init: () => setIsLoading(true),
          function: isLoading ? null : () => server.createNewFIS(category.name),
          successCallBack: (fisid) {
            setIsLoading(false);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyFIS(fisid: fisid)));
          },
          trailing: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2000),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text('${category.noOfParticipants}'),
                ),
              ),
              const Icon(
                Icons.navigate_next,
                color: Colors.white,
              ),
            ],
          ),
        );
      }),
    );
  }
}
