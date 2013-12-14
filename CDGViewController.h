#import <UIKit/UIKit.h>
#import "AppList/AppList.h"
#import "UIProgressHUD.h"

@interface CDGViewController : UITableViewController <UIAlertViewDelegate> {
	ALApplicationTableDataSource *_dataSource;
}

-(void)_dumpBinaryAtPath:(NSString *)path;
-(void)_customBinaryButtonWasTapped;

@end

