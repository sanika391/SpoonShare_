import "package:flutter/material.dart";

void showSuccessSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    ),
    backgroundColor: Colors.green,
    elevation: 6.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
    duration: const Duration(seconds: 2), // Set the duration here
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showErrorSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    ),
    backgroundColor: Colors.red,
    elevation: 6.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
    duration: const Duration(seconds: 2), // Set the duration here
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
