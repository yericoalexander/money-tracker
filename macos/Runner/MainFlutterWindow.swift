import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController
    
    // Set mobile phone window size
    let phoneSize = NSSize(width: 414, height: 896)
    self.setContentSize(phoneSize)
    self.minSize = NSSize(width: 360, height: 700)
    self.center()

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
