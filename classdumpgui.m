#import <UIKit/UIKit.h>
#import <AppList.h>
#import "CDGViewController.h"
#import "UIProgressHUD.h"
#import "NSTask.h"

@interface CDGAppDelegate : NSObject<UIApplicationDelegate> {
@private

	UIWindow *window;
	UINavigationController *navigationController;
	CDGViewController *viewController;
}

@end

@implementation CDGAppDelegate

- (id)init
{
	if ((self = [super init])) {
		window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
		navigationController = [[UINavigationController alloc] init];
		viewController = [[CDGViewController alloc] initWithStyle:UITableViewStylePlain];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	if ([window respondsToSelector:@selector(setRootViewController:)])
		[window setRootViewController:navigationController];
	else
		[window addSubview:[navigationController view]];
	[navigationController pushViewController:viewController animated:NO];
	[window makeKeyAndVisible];
}

- (void)dealloc
{
	[viewController release];
	[navigationController release];
	[window release];
	[super dealloc];
}

@end

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int result = UIApplicationMain(argc, argv, nil, @"CDGAppDelegate");
    [pool drain];
    return result;
}
