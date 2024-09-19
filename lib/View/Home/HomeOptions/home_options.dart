import 'dart:developer';
import 'dart:isolate';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeOptions extends StatelessWidget {
  const HomeOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Options'),

        
      ),

      body: Column(children: [


       


       
        
        
      ],),
    );
  }


  double heavyIntenseJob(){
    int i =0;
    for(int j = 0; j<1000000000; j++){
      i = i+1;
    }

    log("i is $i");
    return i.toDouble();
  }
}


 isolateHeaveyIntenseJOb(SendPort snedpost){
  int i =0;
  for(int j = 0; j<1000000000; j++){
    i = i+1;
  }

  log("i is $i");

  snedpost.send(i.toDouble());
  
}








