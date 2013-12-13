#import <UIKit/UIKit.h>
#import <AppList.h>
#import "UIProgressHUD.h"

@interface CDGViewController : UITableViewController <UIAlertViewDelegate> {
@private
	ALApplicationTableDataSource *dataSource;
    ALApplicationList *al;
    UIProgressHUD *HUD;
    NSString *appDisplayName;
}

-(void)getApp:(NSString *)bundleID;
-(void)dumpBinaryAtPath:(NSString *)path binaryName:(NSString *)binaryName;
-(void)dumpCustomBinary;

@end

