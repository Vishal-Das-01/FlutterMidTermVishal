import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mid_term_vishal_das/model.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Products> product_list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: product_list.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.all(4),
                    height: 150,
                      decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 218, 250, 235),
                            borderRadius: BorderRadius.circular(20)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            
                            Expanded(
                              child: Image.network('${product_list[index].thumbnail}', width: MediaQuery.of(context).size.width,

                             ),
                            ),
                           Container(
                          
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                      Text('${product_list[index].title}',style: TextStyle(fontWeight: FontWeight.bold),),
                                      
                                   Row(
                                    children: <Widget>[
                                      Text('USD ${product_list[index].price}',style: TextStyle(fontWeight: FontWeight.bold),),
                                      SizedBox(width: 10),
                                      IconButton(
                                        onPressed: () {
                                              showModalBottomSheet(
                                    context: context, 
                                    // isScrollControlled: true,
                                    builder: ((context) => Container(
                                        child: SizedBox(
                                          width:  MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                      ListView(
                                                        scrollDirection: Axis.horizontal,
                                                        children: [
                                                      ...product_list[index].images!.map((e){
                                                        return Container(
                                                          child: Image.network(e),
                                                        );
                                                      })
                                                    ],
                                                      ),]),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text('${product_list[index].title}', style: TextStyle(fontWeight: FontWeight.bold),),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Text('${product_list[index].description}'),
                                                            
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Text('\$ ${product_list[index].price}', style: TextStyle(fontWeight: FontWeight.bold),),
                                                            
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                              Row(
                                                                children: <Widget>[
                                                                  Icon(Icons.star),
                                                                  Text('${product_list[index].rating}'),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <Widget>[
                                                                  Icon(Icons.discount),
                                                                  Text('${product_list[index].discountPercentage}'),
                                                                ],
                                                              )
                                                          ],
                                                        )
                                                      ],
                                                    )

                                                    
                                              ],
                                            ),),

                                        ),
                                    ))
                                    );
                                        }, icon: Icon(Icons.remove_red_eye_sharp))
                                         
                                    ],
                                   )   
                                  
                                        
                                      
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(child: Text('${product_list[index].description}'))
                                  ],
                                )
                              ],
                            ),
                                

                            
                           )


                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error');
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  
Future<List<Products>> getData() async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['products'] as List;
      product_list = data.map((i) => Products.fromJson(i)).toList();
      return product_list;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
