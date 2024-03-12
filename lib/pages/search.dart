import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devspectrum/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  TextEditingController searchcotroller = TextEditingController();
  bool showUser = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: TextFormField(
            onFieldSubmitted: (String _) {
              setState(() {
                showUser = true;
              });
            },
            controller: searchcotroller,
            decoration: const InputDecoration(
              labelText: 'Search user',
            ),
          ),
        ),
        body: showUser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .where('username',
                        isGreaterThanOrEqualTo: searchcotroller.text)
                    .get(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                          
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(uid: (snapshot.data! as dynamic).docs[index]
                                ['uid'],)));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['photoUrl']),
                            ),
                            title: Text((snapshot.data! as dynamic).docs[index]
                                ['username']),
                          ),
                        );
                      });
                }),
              )
            :  FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('Post')
                  .orderBy('datePublished')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return MasonryGridView.count(
                  crossAxisCount: 2,

                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Image.network(
                    (snapshot.data! as dynamic).docs[index]['postUrl'],
                    fit: BoxFit.cover,
                  ),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
    );
  }
}
