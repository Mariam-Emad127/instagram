import 'package:flutter/material.dart';
import 'package:nstagram/utils/color.dart';
import 'package:nstagram/utils/utils.dart';

class PostCard extends StatelessWidget {
  final snap;
  const PostCard({super.key, this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        // HEADER SECTION OF THE POST
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 16,
          ).copyWith(right: 0),
          child: Row(children: [
            CircleAvatar(radius: 16, backgroundImage: NetworkImage(
                //   "https://images.unsplash.com/photo-1729027399111-e301fa0e14fa?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                snap["profImage"])),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
              ),
              child: Column(children: [
                Text(
                  snap['username'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            )),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shrinkWrap: true,
                            children: [
                              InkWell(
                                  onTap: () {},
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text('Delete'))),
                            ]),
                      );
                    });
              },
              icon: const Icon(Icons.more_vert),
            )
          ]),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          child: Image.network(
            snap["postUrl"],
            // "https://images.unsplash.com/photo-1729027399111-e301fa0e14fa?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            fit: BoxFit.cover,
          ),
        ),
        Row(children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.comment_outlined,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.send,
            ),
            onPressed: () {},
          ),
          Expanded(
              child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
                icon: const Icon(Icons.bookmark_border), onPressed: () {}),
          )),
        ]),

        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${snap['likes'].length} like",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: snap["userName"] //.toString()
                          ,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text: snap["description"] //"key description"
                          ,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ])),
                  ),
                  InkWell(
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "view all comment",
                          style: const TextStyle(
                            color: secondaryColor,
                          ),
                        )),
                  )
                ]))
      ]),
    );
  }
}
