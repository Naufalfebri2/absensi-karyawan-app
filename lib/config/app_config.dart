import 'env/env_dev.dart';
import 'env/env_prod.dart';
import 'env/env_staging.dart';

enum AppEnvironment { dev, staging, prod }

class AppConfig {
  static AppEnvironment env = AppEnvironment.dev;

  static String get baseUrl {
    switch (env) {
      case AppEnvironment.dev:
        return EnvDev.baseUrl;
      case AppEnvironment.staging:
        return EnvStaging.baseUrl;
      case AppEnvironment.prod:
        return EnvProd.baseUrl;
    }
  }

  static bool get loggingEnabled {
    switch (env) {
      case AppEnvironment.dev:
        return EnvDev.enableLogging;
      case AppEnvironment.staging:
        return EnvStaging.enableLogging;
      case AppEnvironment.prod:
        return EnvProd.enableLogging;
    }
  }
}
