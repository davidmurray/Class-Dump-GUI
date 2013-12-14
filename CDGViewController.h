#import <UIKit/UIKit.h>
#import "AppList/AppList.h"
#import "UIProgressHUD.h"

@interface CDGViewController : UITableViewController <UIAlertViewDelegate> {
@private
	ALApplicationTableDataSource *dataSource;
	UIProgressHUD *HUD;
	NSString *appDisplayName;
}

-(void)getApp:(NSString *)bundleID;
-(void)dumpBinaryAtPath:(NSString *)path binaryName:(NSString *)binaryName;
-(void)dumpCustomBinary;

@end

