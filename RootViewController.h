#import <Applist/AppList.h>
#import "NSTask.h"
#import "UIProgressHUD.h"
#import <QuartzCore/QuartzCore.h>

@interface RootViewController: UITableViewController {
    ALApplicationTableDataSource *dataSource;
    NSString *omgPath;
    NSString *omgName;
    UIAlertView *progressAlert;
}
- (NSString *)pathForBundleIdentifier:(NSString *)bundleID;
- (void)classDumpExecutable;
@end
