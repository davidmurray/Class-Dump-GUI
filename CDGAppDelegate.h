#import <UIKit/UIKit.h>

@class CDGViewController;

@interface CDGAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *_window;
	UINavigationController *_navigationController;
	CDGViewController *_viewController;
}

@end