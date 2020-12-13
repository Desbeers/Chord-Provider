import SwiftUI

func GetAccentColor() -> String {
    return NSColor.controlAccentColor.hexString
}

func GetHighlightColor() -> String {
    return NSColor.controlAccentColor.hexString + "33"
}

func GetTextColor() -> String {
    return NSColor.labelColor.hexString
}

func GetSystemBackground() -> String {
    return NSColor.textBackgroundColor.hexString
}

extension NSColor {
    var hexString: String{
        let rgbColor = usingColorSpace(.extendedSRGB) ?? NSColor(red: 1, green: 1, blue: 1, alpha: 1)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        rgbColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb:Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return String(format: "#%06x", rgb)
    }
}


struct FancyBackground: NSViewRepresentable {
  func makeNSView(context: Context) -> NSVisualEffectView {
    return NSVisualEffectView()
  }
  
  func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    // Nothing to do.
  }
}

// SelectSongsFolder(MySongs)
// --------------------------
// Gets the @stateObject mySongs
// Saves the selected folder in plain text and as sanbox-bookmark
// Refreshes the list of songs
// Returns nothing

func SelectSongsFolder(_ mySongs: MySongs) {
    let base = UserDefaults.standard.object(forKey: "pathSongsString") as? String ?? GetDocumentsDirectory()
    let dialog = NSOpenPanel();
    dialog.showsResizeIndicator = true;
    dialog.showsHiddenFiles = false;
    dialog.canChooseFiles = false;
    dialog.canChooseDirectories = true;
    dialog.directoryURL = URL(fileURLWithPath: base)
    dialog.message = "Select the folder with your songs"
    dialog.prompt = "Select"
    dialog.beginSheetModal(for: NSApp.keyWindow!) { (result) in
        if result == NSApplication.ModalResponse.OK {
            let result = dialog.url
            UserDefaults.standard.set(result!.path, forKey: "pathSongsString")
            /// Create a persistent bookmark for the folder the user just selected
            _ = SetPersistentFileURL(result!)
            
            /// Refresh the list of books
            mySongs.songList = GetSongs()
        }
    }
}

// Get and Set sandbox bookmarks
// -----------------------------
// Many thanks to https://www.appcoda.com/mac-apps-user-intent/

func SetPersistentFileURL(_ selectedURL: URL) -> Bool {
    do {
        let bookmarkData = try selectedURL.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
        UserDefaults.standard.set(bookmarkData, forKey: "pathSongs")
        return true
    } catch let error {
        print("Could not create a bookmark because: ", error)
        return false
    }
}

func GetPersistentFileURL() -> URL? {
    if let bookmarkData = UserDefaults.standard.data(forKey: "pathSongs") {
         do {
            var bookmarkDataIsStale = false
            let urlForBookmark = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &bookmarkDataIsStale)
            if bookmarkDataIsStale {
                print("The bookmark is outdated and needs to be regenerated.")
                _ = SetPersistentFileURL(urlForBookmark)
                return nil
 
            } else {
                return urlForBookmark
            }
        } catch {
            print("Error resolving bookmark:", error)
            return nil
        }
    } else {
        print("Error retrieving persistent bookmark data.")
        return nil
 
    }
}


// GetDocumentsDirectory()
// -----------------------
// Returns the users Documents directory.
// Used when no folders are selected by the user.

func GetDocumentsDirectory() -> String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
}
