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

  /// This `R.color` struct is generated, and contains static references to 8 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")
    /// Color `ButtonBlueColor`.
    static let buttonBlueColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "ButtonBlueColor")
    /// Color `MainBlueColorDark`.
    static let mainBlueColorDark = Rswift.ColorResource(bundle: R.hostingBundle, name: "MainBlueColorDark")
    /// Color `MainBlueColorLight`.
    static let mainBlueColorLight = Rswift.ColorResource(bundle: R.hostingBundle, name: "MainBlueColorLight")
    /// Color `RegisterGreenColor`.
    static let registerGreenColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "RegisterGreenColor")
    /// Color `TextFieldBorderColor`.
    static let textFieldBorderColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "TextFieldBorderColor")
    /// Color `TextFieldTextColor`.
    static let textFieldTextColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "TextFieldTextColor")
    /// Color `WhiteAlpha0,75`.
    static let whiteAlpha075 = Rswift.ColorResource(bundle: R.hostingBundle, name: "WhiteAlpha0,75")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func accentColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "ButtonBlueColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func buttonBlueColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.buttonBlueColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "MainBlueColorDark", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mainBlueColorDark(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mainBlueColorDark, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "MainBlueColorLight", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func mainBlueColorLight(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.mainBlueColorLight, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "RegisterGreenColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func registerGreenColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.registerGreenColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "TextFieldBorderColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func textFieldBorderColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.textFieldBorderColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "TextFieldTextColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func textFieldTextColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.textFieldTextColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "WhiteAlpha0,75", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func whiteAlpha075(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.whiteAlpha075, compatibleWith: traitCollection)
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
    /// `UIColor(named: "ButtonBlueColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func buttonBlueColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.buttonBlueColor.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "MainBlueColorDark", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func mainBlueColorDark(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.mainBlueColorDark.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "MainBlueColorLight", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func mainBlueColorLight(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.mainBlueColorLight.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "RegisterGreenColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func registerGreenColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.registerGreenColor.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "TextFieldBorderColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func textFieldBorderColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.textFieldBorderColor.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "TextFieldTextColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func textFieldTextColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.textFieldTextColor.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "WhiteAlpha0,75", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func whiteAlpha075(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.whiteAlpha075.name)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.font` struct is generated, and contains static references to 18 fonts.
  struct font: Rswift.Validatable {
    /// Font `Kanit-BlackItalic`.
    static let kanitBlackItalic = Rswift.FontResource(fontName: "Kanit-BlackItalic")
    /// Font `Kanit-Black`.
    static let kanitBlack = Rswift.FontResource(fontName: "Kanit-Black")
    /// Font `Kanit-BoldItalic`.
    static let kanitBoldItalic = Rswift.FontResource(fontName: "Kanit-BoldItalic")
    /// Font `Kanit-Bold`.
    static let kanitBold = Rswift.FontResource(fontName: "Kanit-Bold")
    /// Font `Kanit-ExtraBoldItalic`.
    static let kanitExtraBoldItalic = Rswift.FontResource(fontName: "Kanit-ExtraBoldItalic")
    /// Font `Kanit-ExtraBold`.
    static let kanitExtraBold = Rswift.FontResource(fontName: "Kanit-ExtraBold")
    /// Font `Kanit-ExtraLightItalic`.
    static let kanitExtraLightItalic = Rswift.FontResource(fontName: "Kanit-ExtraLightItalic")
    /// Font `Kanit-ExtraLight`.
    static let kanitExtraLight = Rswift.FontResource(fontName: "Kanit-ExtraLight")
    /// Font `Kanit-Italic`.
    static let kanitItalic = Rswift.FontResource(fontName: "Kanit-Italic")
    /// Font `Kanit-LightItalic`.
    static let kanitLightItalic = Rswift.FontResource(fontName: "Kanit-LightItalic")
    /// Font `Kanit-Light`.
    static let kanitLight = Rswift.FontResource(fontName: "Kanit-Light")
    /// Font `Kanit-MediumItalic`.
    static let kanitMediumItalic = Rswift.FontResource(fontName: "Kanit-MediumItalic")
    /// Font `Kanit-Medium`.
    static let kanitMedium = Rswift.FontResource(fontName: "Kanit-Medium")
    /// Font `Kanit-Regular`.
    static let kanitRegular = Rswift.FontResource(fontName: "Kanit-Regular")
    /// Font `Kanit-SemiBoldItalic`.
    static let kanitSemiBoldItalic = Rswift.FontResource(fontName: "Kanit-SemiBoldItalic")
    /// Font `Kanit-SemiBold`.
    static let kanitSemiBold = Rswift.FontResource(fontName: "Kanit-SemiBold")
    /// Font `Kanit-ThinItalic`.
    static let kanitThinItalic = Rswift.FontResource(fontName: "Kanit-ThinItalic")
    /// Font `Kanit-Thin`.
    static let kanitThin = Rswift.FontResource(fontName: "Kanit-Thin")

    /// `UIFont(name: "Kanit-Black", size: ...)`
    static func kanitBlack(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitBlack, size: size)
    }

    /// `UIFont(name: "Kanit-BlackItalic", size: ...)`
    static func kanitBlackItalic(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitBlackItalic, size: size)
    }

    /// `UIFont(name: "Kanit-Bold", size: ...)`
    static func kanitBold(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitBold, size: size)
    }

    /// `UIFont(name: "Kanit-BoldItalic", size: ...)`
    static func kanitBoldItalic(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitBoldItalic, size: size)
    }

    /// `UIFont(name: "Kanit-ExtraBold", size: ...)`
    static func kanitExtraBold(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitExtraBold, size: size)
    }

    /// `UIFont(name: "Kanit-ExtraBoldItalic", size: ...)`
    static func kanitExtraBoldItalic(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitExtraBoldItalic, size: size)
    }

    /// `UIFont(name: "Kanit-ExtraLight", size: ...)`
    static func kanitExtraLight(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitExtraLight, size: size)
    }

    /// `UIFont(name: "Kanit-ExtraLightItalic", size: ...)`
    static func kanitExtraLightItalic(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitExtraLightItalic, size: size)
    }

    /// `UIFont(name: "Kanit-Italic", size: ...)`
    static func kanitItalic(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitItalic, size: size)
    }

    /// `UIFont(name: "Kanit-Light", size: ...)`
    static func kanitLight(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitLight, size: size)
    }

    /// `UIFont(name: "Kanit-LightItalic", size: ...)`
    static func kanitLightItalic(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitLightItalic, size: size)
    }

    /// `UIFont(name: "Kanit-Medium", size: ...)`
    static func kanitMedium(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitMedium, size: size)
    }

    /// `UIFont(name: "Kanit-MediumItalic", size: ...)`
    static func kanitMediumItalic(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitMediumItalic, size: size)
    }

    /// `UIFont(name: "Kanit-Regular", size: ...)`
    static func kanitRegular(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitRegular, size: size)
    }

    /// `UIFont(name: "Kanit-SemiBold", size: ...)`
    static func kanitSemiBold(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitSemiBold, size: size)
    }

    /// `UIFont(name: "Kanit-SemiBoldItalic", size: ...)`
    static func kanitSemiBoldItalic(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitSemiBoldItalic, size: size)
    }

    /// `UIFont(name: "Kanit-Thin", size: ...)`
    static func kanitThin(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitThin, size: size)
    }

    /// `UIFont(name: "Kanit-ThinItalic", size: ...)`
    static func kanitThinItalic(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: kanitThinItalic, size: size)
    }

    static func validate() throws {
      if R.font.kanitBlack(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-Black' could not be loaded, is 'Kanit-Black.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitBlackItalic(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-BlackItalic' could not be loaded, is 'Kanit-BlackItalic.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitBold(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-Bold' could not be loaded, is 'Kanit-Bold.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitBoldItalic(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-BoldItalic' could not be loaded, is 'Kanit-BoldItalic.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitExtraBold(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-ExtraBold' could not be loaded, is 'Kanit-ExtraBold.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitExtraBoldItalic(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-ExtraBoldItalic' could not be loaded, is 'Kanit-ExtraBoldItalic.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitExtraLight(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-ExtraLight' could not be loaded, is 'Kanit-ExtraLight.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitExtraLightItalic(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-ExtraLightItalic' could not be loaded, is 'Kanit-ExtraLightItalic.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitItalic(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-Italic' could not be loaded, is 'Kanit-Italic.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitLight(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-Light' could not be loaded, is 'Kanit-Light.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitLightItalic(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-LightItalic' could not be loaded, is 'Kanit-LightItalic.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitMedium(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-Medium' could not be loaded, is 'Kanit-Medium.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitMediumItalic(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-MediumItalic' could not be loaded, is 'Kanit-MediumItalic.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitRegular(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-Regular' could not be loaded, is 'Kanit-Regular.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitSemiBold(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-SemiBold' could not be loaded, is 'Kanit-SemiBold.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitSemiBoldItalic(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-SemiBoldItalic' could not be loaded, is 'Kanit-SemiBoldItalic.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitThin(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-Thin' could not be loaded, is 'Kanit-Thin.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.kanitThinItalic(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Kanit-ThinItalic' could not be loaded, is 'Kanit-ThinItalic.ttf' added to the UIAppFonts array in this targets Info.plist?") }
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 5 images.
  struct image {
    /// Image `Logo`.
    static let logo = Rswift.ImageResource(bundle: R.hostingBundle, name: "Logo")
    /// Image `emailIcon`.
    static let emailIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "emailIcon")
    /// Image `hideIcon`.
    static let hideIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "hideIcon")
    /// Image `passwordIcon`.
    static let passwordIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "passwordIcon")
    /// Image `showIcon`.
    static let showIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "showIcon")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "Logo", bundle: ..., traitCollection: ...)`
    static func logo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.logo, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "emailIcon", bundle: ..., traitCollection: ...)`
    static func emailIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.emailIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "hideIcon", bundle: ..., traitCollection: ...)`
    static func hideIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.hideIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "passwordIcon", bundle: ..., traitCollection: ...)`
    static func passwordIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.passwordIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "showIcon", bundle: ..., traitCollection: ...)`
    static func showIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.showIcon, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      // There are no resources to validate
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R {
  fileprivate init() {}
}
