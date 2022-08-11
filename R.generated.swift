//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try font.validate()
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 2 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")
    /// Color `Red`.
    static let red = Rswift.ColorResource(bundle: R.hostingBundle, name: "Red")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func accentColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Red", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.red, compatibleWith: traitCollection)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func accentColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.accentColor.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Red", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func red(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.red.name)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.entitlements` struct is generated, and contains static references to 1 properties.
  struct entitlements {
    static let comAppleDeveloperDevicecheckAppattestEnvironment = infoPlistString(path: [], key: "com.apple.developer.devicecheck.appattest-environment") ?? "production"

    fileprivate init() {}
  }

  /// This `R.file` struct is generated, and contains static references to 6 files.
  struct file {
    /// Resource file `EatingCookie.json`.
    static let eatingCookieJson = Rswift.FileResource(bundle: R.hostingBundle, name: "EatingCookie", pathExtension: "json")
    /// Resource file `GoogleService-Info.plist`.
    static let googleServiceInfoPlist = Rswift.FileResource(bundle: R.hostingBundle, name: "GoogleService-Info", pathExtension: "plist")
    /// Resource file `Jalnan.ttf`.
    static let jalnanTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "Jalnan", pathExtension: "ttf")
    /// Resource file `NotoSansKR-Bold.otf`.
    static let notoSansKRBoldOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "NotoSansKR-Bold", pathExtension: "otf")
    /// Resource file `NotoSansKR-Medium.otf`.
    static let notoSansKRMediumOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "NotoSansKR-Medium", pathExtension: "otf")
    /// Resource file `NotoSansKR-Regular.otf`.
    static let notoSansKRRegularOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "NotoSansKR-Regular", pathExtension: "otf")

    /// `bundle.url(forResource: "EatingCookie", withExtension: "json")`
    static func eatingCookieJson(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.eatingCookieJson
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "GoogleService-Info", withExtension: "plist")`
    static func googleServiceInfoPlist(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.googleServiceInfoPlist
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "Jalnan", withExtension: "ttf")`
    static func jalnanTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.jalnanTtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "NotoSansKR-Bold", withExtension: "otf")`
    static func notoSansKRBoldOtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.notoSansKRBoldOtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "NotoSansKR-Medium", withExtension: "otf")`
    static func notoSansKRMediumOtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.notoSansKRMediumOtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "NotoSansKR-Regular", withExtension: "otf")`
    static func notoSansKRRegularOtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.notoSansKRRegularOtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.font` struct is generated, and contains static references to 4 fonts.
  struct font: Rswift.Validatable {
    /// Font `Jalnan`.
    static let jalnan = Rswift.FontResource(fontName: "Jalnan")
    /// Font `NotoSansKR-Bold`.
    static let notoSansKRBold = Rswift.FontResource(fontName: "NotoSansKR-Bold")
    /// Font `NotoSansKR-Medium`.
    static let notoSansKRMedium = Rswift.FontResource(fontName: "NotoSansKR-Medium")
    /// Font `NotoSansKR-Regular`.
    static let notoSansKRRegular = Rswift.FontResource(fontName: "NotoSansKR-Regular")

    /// `UIFont(name: "Jalnan", size: ...)`
    static func jalnan(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: jalnan, size: size)
    }

    /// `UIFont(name: "NotoSansKR-Bold", size: ...)`
    static func notoSansKRBold(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: notoSansKRBold, size: size)
    }

    /// `UIFont(name: "NotoSansKR-Medium", size: ...)`
    static func notoSansKRMedium(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: notoSansKRMedium, size: size)
    }

    /// `UIFont(name: "NotoSansKR-Regular", size: ...)`
    static func notoSansKRRegular(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: notoSansKRRegular, size: size)
    }

    static func validate() throws {
      if R.font.jalnan(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Jalnan' could not be loaded, is 'Jalnan.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.notoSansKRBold(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'NotoSansKR-Bold' could not be loaded, is 'NotoSansKR-Bold.otf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.notoSansKRMedium(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'NotoSansKR-Medium' could not be loaded, is 'NotoSansKR-Medium.otf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.notoSansKRRegular(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'NotoSansKR-Regular' could not be loaded, is 'NotoSansKR-Regular.otf' added to the UIAppFonts array in this targets Info.plist?") }
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 8 images.
  struct image {
    /// Image `cookie`.
    static let cookie = Rswift.ImageResource(bundle: R.hostingBundle, name: "cookie")
    /// Image `dish`.
    static let dish = Rswift.ImageResource(bundle: R.hostingBundle, name: "dish")
    /// Image `logoCookie`.
    static let logoCookie = Rswift.ImageResource(bundle: R.hostingBundle, name: "logoCookie")
    /// Image `noClue`.
    static let noClue = Rswift.ImageResource(bundle: R.hostingBundle, name: "noClue")
    /// Image `oneCookie`.
    static let oneCookie = Rswift.ImageResource(bundle: R.hostingBundle, name: "oneCookie")
    /// Image `search`.
    static let search = Rswift.ImageResource(bundle: R.hostingBundle, name: "search")
    /// Image `soloCookie`.
    static let soloCookie = Rswift.ImageResource(bundle: R.hostingBundle, name: "soloCookie")
    /// Image `twoCookie`.
    static let twoCookie = Rswift.ImageResource(bundle: R.hostingBundle, name: "twoCookie")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "cookie", bundle: ..., traitCollection: ...)`
    static func cookie(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.cookie, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "dish", bundle: ..., traitCollection: ...)`
    static func dish(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.dish, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "logoCookie", bundle: ..., traitCollection: ...)`
    static func logoCookie(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.logoCookie, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "noClue", bundle: ..., traitCollection: ...)`
    static func noClue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.noClue, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "oneCookie", bundle: ..., traitCollection: ...)`
    static func oneCookie(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.oneCookie, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "search", bundle: ..., traitCollection: ...)`
    static func search(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.search, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "soloCookie", bundle: ..., traitCollection: ...)`
    static func soloCookie(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.soloCookie, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "twoCookie", bundle: ..., traitCollection: ...)`
    static func twoCookie(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.twoCookie, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.info` struct is generated, and contains static references to 1 properties.
  struct info {
    struct uiApplicationSceneManifest {
      static let _key = "UIApplicationSceneManifest"
      static let uiApplicationSupportsMultipleScenes = false

      struct uiSceneConfigurations {
        static let _key = "UISceneConfigurations"

        struct uiWindowSceneSessionRoleApplication {
          struct defaultConfiguration {
            static let _key = "Default Configuration"
            static let uiSceneConfigurationName = infoPlistString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication", "Default Configuration"], key: "UISceneConfigurationName") ?? "Default Configuration"
            static let uiSceneDelegateClassName = infoPlistString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication", "Default Configuration"], key: "UISceneDelegateClassName") ?? "$(PRODUCT_MODULE_NAME).SceneDelegate"

            fileprivate init() {}
          }

          fileprivate init() {}
        }

        fileprivate init() {}
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}
