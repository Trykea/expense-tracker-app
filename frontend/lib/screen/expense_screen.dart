import 'package:flutter/material.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense list'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            elevation: 6,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text('Amt'),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('item1',style: TextStyle(fontSize: 18),),
                        SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text('date'), Text('Category')],
                        ),

                      ],

                    ),
                  ),
                  Column(children: [
                    OutlinedButton.icon(onPressed: () {}, label: Text('Delete'), icon: Icon(Icons.delete),),
                    OutlinedButton.icon(onPressed: () {}, label: Text('Edit'), icon: Icon(Icons.edit),)
                  ],)
                ],

              ),
            ),
          );
        },
      ),
    );
  }
}
