import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nstagram/utils/color.dart';

class CommentCard extends StatelessWidget {

  final snap;
  const CommentCard({super.key,required this.snap });

  @override
  Widget build(BuildContext context) {
    return Container(
 //color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(

              snap['profilePic']
             
            )
// "https://images.unsplash.com/photo-1729027399111-e301fa0e14fa?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"

           , radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          //text: "name",// snap.data()['name'],
                            text: snap.data()["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black )
                        ),
                        TextSpan(
                          text:  ' ${snap.data()['text']}',
                            style: const TextStyle(fontWeight: FontWeight.normal ,color: Colors.black )
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                     // "12/7"
                     DateFormat.yMMMd().format(
                        snap.data()['datePublished'].toDate(),),
                  
                
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400,),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.favorite,
              size: 16,
            ),
          )
        ],
      ),


    );
  }
}