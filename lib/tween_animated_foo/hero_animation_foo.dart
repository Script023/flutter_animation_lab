import 'package:flutter/material.dart';

class PeopleApp extends StatefulWidget {
  const PeopleApp({super.key});

  @override
  State<PeopleApp> createState() => _PeopleAppState();
}

@immutable
class Person {
  final String name;
  final int age;
  final String emoji;

  const Person({required this.name, required this.age, required this.emoji});
}

const people = [
  Person(name: 'John', age: 30, emoji: '🧔‍♂️'),
  Person(name: 'Kalu', age: 45, emoji: '👨🏼‍🦳'),
  Person(name: 'Joshua', age: 45, emoji: '👨🏾‍🦰'),
];

class _PeopleAppState extends State<PeopleApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'People',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: people.length,
        //take a parameter of index
        itemBuilder: (context, index) {
          final person = people[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(person: person),
                ),
              );
            },
            leading: Hero(
              tag: person.name,
              child: Text(person.emoji, style: TextStyle(fontSize: 40)),
            ),
            title: Text(
              person.name,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            subtitle: Text('${person.age} years old'),
            trailing: Icon(Icons.arrow_forward_ios),
          );
        },
      ),
    );
  }
}

class DetailsPage extends StatefulWidget {
  final Person person;
  const DetailsPage({super.key, required this.person});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Hero(
          tag: widget.person.name,
          flightShuttleBuilder:
              (
                flightContext,
                animation,
                flightDirection,
                fromHeroContext,
                toHeroContext,
              ) {
                switch (flightDirection) {
                  case HeroFlightDirection.push:
                    return Material(
                      color: Colors.transparent,
                      child: fromHeroContext.widget,
                    );
                  case HeroFlightDirection.pop:
                    return Material(
                      color: Colors.transparent,
                      child: ScaleTransition(
                        scale: animation.drive(
                          Tween<double>(begin: 0, end: 1).chain(
                            CurveTween(curve: Curves.fastLinearToSlowEaseIn),
                          ),
                        ),
                        child: toHeroContext.widget,
                      ),
                    );
                }
              },
          child: Text(widget.person.emoji, style: TextStyle(fontSize: 50)),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              widget.person.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),

            Text(
              '${widget.person.age} years old',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
