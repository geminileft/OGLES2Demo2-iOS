#import "AppDelegate.h"
#import "DemoViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [mWindow release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    mWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    DemoViewController* glvc = [[DemoViewController alloc] init];
    mWindow.rootViewController = glvc;
    [mWindow makeKeyAndVisible];
    [glvc release];
    return YES;
}

@end
