#import "CDGAppDelegate.h"
#import "CDGViewController.h"

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