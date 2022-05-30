import UIKit
import Flutter
import Network

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,FlutterStreamHandler {
    
    private var eventSink : FlutterEventSink?
    private let networkQueue = DispatchQueue.global()
    private let networkMonitor : NWPathMonitor = NWPathMonitor()
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let flutterPlatformServices = FlutterMethodChannel(name: "os_method",binaryMessenger: controller.binaryMessenger)
      flutterPlatformServices.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method{
          case "getOsVersion": self.getOsVersion(result: result)
          default : result(FlutterMethodNotImplemented)
          }
      })
      
      let flutterPlatformEvent = FlutterEventChannel(name: "os_event", binaryMessenger: controller.binaryMessenger)
      flutterPlatformEvent.setStreamHandler(self)
      GeneratedPluginRegistrant.register(withRegistry: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func getOsVersion(result: FlutterResult){
        let version : String = UIDevice.current.systemVersion
        result(version)
    }
    private func getConnectionType(){
        networkMonitor.start(queue: networkQueue)
        networkMonitor.pathUpdateHandler = {
            path in
            if (path.status != .satisfied){
                self.eventSink?("Disconnect")
            }else if (path.usesInterfaceType(.wifi)){
                self.eventSink?("Wifi")
            }else if (path.usesInterfaceType(.cellular)){
                self.eventSink?("Mobile")
            }else if (path.usesInterfaceType(.wiredEthernet)){
                self.eventSink?("Ethernet")
            }else if (path.usesInterfaceType(.loopback)){
                self.eventSink?("Loopback")
            }else if (path.usesInterfaceType(.other)) {
                self.eventSink?("Other")
            }else {
                self.eventSink?("Disconnect")
            }
        }
    }
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        getConnectionType()
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        networkMonitor.cancel()
        return nil
    }

}
