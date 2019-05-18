#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    // Provide the GoogleMaps API key.
    NSString* mapsApiKey = [[NSProcessInfo processInfo] environment][@"OST_MAPS_API_KEY"];
    [GMSServices provideAPIKey:mapsApiKey];
  
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
