#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
@import UIKit;
@import Firebase;


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [FIRApp configure];
  // Override point for customization after application launch.
    FlutterViewController *controller = (FlutterViewController *) self.window.rootViewController;
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"MyChannel" binaryMessenger:controller];
    
    [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        NSString *from = call.arguments[@"from"];
        if([@"myNativeFunction" isEqualToString:call.method]){
            NSString *messageToFlutter = [self myNativeFunction];
            messageToFlutter = [NSString stringWithFormat:@"%@, Back to %@", messageToFlutter, from];
            result(messageToFlutter);
        }
    }];
    
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    
    
    // Override point for customization after application launch.
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

-(NSString *) myNativeFunction{
    return @"Message from iOS";
}

@end
