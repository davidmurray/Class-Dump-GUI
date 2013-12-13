#import <UIKit/UIKit.h>

@class CDGViewController;

@interface CDGAppDelegate : NSObject<UIApplicationDelegate> {
@private

	UIWindow *window;
	UINavigationController *navigationController;
	CDGViewController *viewController;
}

@end