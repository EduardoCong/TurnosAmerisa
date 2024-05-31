import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

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
            child: const Icon(Icons.auto_stories)
          )
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Califica tu experiencia',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              RatingBar.builder(
                itemCount: 5,
                initialRating: rating,
                itemSize: 40,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return const Icon(Icons.sentiment_very_dissatisfied, color: Colors.red);
                    case 1:
                      return const Icon(Icons.sentiment_dissatisfied, color: Colors.redAccent);
                    case 2:
                      return const Icon(Icons.sentiment_neutral, color: Colors.amber);
                    case 3:
                      return const Icon(Icons.sentiment_satisfied, color: Colors.greenAccent);
                    case 4:
                      return const Icon(Icons.sentiment_very_satisfied, color: Colors.green);
                    default:
                      return const Icon(Icons.sentiment_neutral, color: Colors.grey);
                  }
                },
                onRatingUpdate: (value) {
                  setState(() {
                    rating = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('¡Gracias por tu calificación de $rating estrellas!')),
                  );
                  Navigator.pushNamed(context, '/home');
                },
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}