import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'utils/routes.dart';

void main() {
  runApp(const TruckTrailerApp());
}

class TruckTrailerApp extends StatelessWidget {
  const TruckTrailerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
      ],
      child: MaterialApp.router(
        title: 'Truck & Trailer Repair App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
    );
  }
}
