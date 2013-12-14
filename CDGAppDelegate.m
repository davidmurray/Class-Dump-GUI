#import "CDGAppDelegate.h"
#import "CDGViewController.h"

@implementation CDGAppDelegate

- (id)init
{
	self = [super init];
	if (self) {
		_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		_navigationController = [[UINavigationController alloc] init];
		_viewController = [[CDGViewController alloc] initWithStyle:UITableViewStylePlain];
	}

	return self;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	if ([_window respondsToSelector:@selector(setRootViewController:)])
		[_window setRootViewController:_navigationController];
	else
		[_window addSubview:[_navigationController view]];
	[_navigationController pushViewController:_viewController animated:NO];
	[_window makeKeyAndVisible];
}

- (void)dealloc
{
	[_viewController release];
	[_navigationController release];
	[_window release];

	[super dealloc];
}

@end