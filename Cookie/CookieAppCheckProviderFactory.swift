//
//  AppCheckProviderFactory.swift
//  Cookie
//
//  Created by 이상현 on 2022/08/08.
//

import FirebaseAppCheck
import FirebaseCore

class CookieAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    #if targetEnvironment(simulator)
      // App Attest is not available on simulators.
      // Use a debug provider.
      let provider = AppCheckDebugProvider(app: app)
//      print("Firebase App Check debug token: \(provider?.localDebugToken() ?? "" )")
      return provider
    #else
      // Use App Attest provider on real devices.
      return AppAttestProvider(app: app)
    #endif
  }
}
