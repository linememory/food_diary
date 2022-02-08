import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            "January",
            style: Theme.of(context).textTheme.headline3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade900),
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.red,
                ),
                child: const Center(child: Text("Mon")),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade900),
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.red,
                ),
                child: const Center(child: Text("Tue")),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade900),
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.red,
                ),
                child: const Center(child: Text("Wed")),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade900),
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.red,
                ),
                child: const Center(child: Text("Thu")),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade900),
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.red,
                ),
                child: const Center(child: Text("Fri")),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade900),
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.red,
                ),
                child: const Center(child: Text("Sat")),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade900),
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.red,
                ),
                child: const Center(child: Text("un")),
              ),
            ],
          ),
          Expanded(
            child: GridView.count(
              //childAspectRatio: 0.75,
              crossAxisCount: 7,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              children: List.generate(
                42,
                (i) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade500, width: 3),
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.red.shade300,
                  ),
                  child: Center(child: Text(i.toString())),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
