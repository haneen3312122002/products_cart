import 'package:connectivity_plus/connectivity_plus.dart';

// abstraction over connectivity checking so repositories can decide
// whether to hit the remote data source or fall back to local/cache
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  NetworkInfoImpl({required this.connectivity});
  @override
  Future<bool> get isConnected async {
    // WARNING edited: connectivity_plus v7 returns List<ConnectivityResult>,
    // not a single value, so comparing it to ConnectivityResult.none always
    // evaluated true and offline detection never worked.
    final results = await connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}
