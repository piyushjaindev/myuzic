import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/init_cubit/init_cubit.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_outlined,
              size: MediaQuery.of(context).size.width * 0.30,
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Something went wrong!!!',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 0.4,
              child: OutlinedButton(
                onPressed: () {
                  BlocProvider.of<InitCubit>(context).init();
                },
                child: Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
