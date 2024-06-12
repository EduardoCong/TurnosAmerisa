import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingScreen extends StatefulWidget {
  RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  double rating = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.pushNamed(context, '/timer');
            },
            child: Icon(Icons.auto_stories)
          )
        ],
      ),
      body: centerRating()
    );
  }

  Widget buttonRating(){
    return ElevatedButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Gracias por tu calificación de $rating estrellas!')),
        );
        Navigator.pushNamed(context, '/home');
      },
      child: Text('Enviar'),
    );
  }

  Widget ratingBar(){
    return RatingBar.builder(
      itemCount: 5,
      initialRating: rating,
      itemSize: 40,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return Icon(Icons.sentiment_very_dissatisfied, color: Colors.red);
          case 1:
            return Icon(Icons.sentiment_dissatisfied, color: Colors.redAccent);
          case 2:
            return Icon(Icons.sentiment_neutral, color: Colors.amber);
          case 3:
            return Icon(Icons.sentiment_satisfied, color: Colors.greenAccent);
          case 4:
            return Icon(Icons.sentiment_very_satisfied, color: Colors.green);
          default:
            return Icon(Icons.sentiment_neutral, color: Colors.grey);
        }
      },
      onRatingUpdate: (value) {
        setState(() {
          rating = value;
        });
      },
    );
  }

  Widget textRating(){
    return Text(
      'Califica tu experiencia',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget columRating(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        textRating(),
        SizedBox(height: 20),
        ratingBar(),
        SizedBox(height: 20),
        buttonRating()
      ],
    );
  }

  Widget centerRating(){
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: columRating(),
      ),
    );
  }
}