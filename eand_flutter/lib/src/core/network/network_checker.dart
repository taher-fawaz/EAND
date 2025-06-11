import 'package:eand_flutter/src/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

typedef EitherNetwork<T> = Future<Either<Failure, T>> Function();

class NetworkInfo {
  final InternetConnectionChecker _connectionChecker;
  NetworkInfo(this._connectionChecker);

  bool _isConnected = true;

  Future<Either<Failure, T>> check<T>({
    required Future<Either<Failure, T>> Function() onConnected,
    required Future<Either<Failure, T>> Function() onNotConnected,
  }) async {
    final isConnected = await checkIsConnected;
    if (isConnected) {
      return onConnected.call();
    } else {
      return onNotConnected.call();
    }
  }

  Future<bool> get checkIsConnected async =>
      await _connectionChecker.hasConnection;

  set setIsConnected(bool val) => _isConnected = val;

  bool get getIsConnected => _isConnected;
}
