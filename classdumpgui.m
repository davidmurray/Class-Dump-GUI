#import <UIKit/UIKit.h>
#import <AppList.h>
#import "UIProgressHUD.h"
#import "NSTask.h"

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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@implementation CDGViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    BOOL isDir = FALSE;
    
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/ClassDump" isDirectory:&isDir];
    
    if (!isDir && !exists) {
        
        
        [[NSFileManager defaultManager] createDirectoryAtPath:@"/var/mobile/ClassDump/" withIntermediateDirectories:NO attributes:nil error:NULL];
        
    }
    
    UIBarButtonItem *customBinaryButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(dumpCustomBinary)];
    
    self.title = @"Class Dump GUI";
	self.tableView.dataSource = dataSource;
	dataSource.tableView = self.tableView;

    self.navigationItem.rightBarButtonItem = customBinaryButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        dataSource = [[ALApplicationTableDataSource alloc] init];
        NSString *sectionDescriptorsPath = [[NSBundle mainBundle] pathForResource:@"com.jack.cdg.settings" ofType:@"plist"];
		dataSource.sectionDescriptors = [NSArray arrayWithContentsOfFile:sectionDescriptorsPath];
	}
	return self;
}

- (void)dealloc
{
	dataSource.tableView = nil;
	[dataSource release];
	[super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	NSString *displayIdentifier = [dataSource displayIdentifierForIndexPath:indexPath];
	al = [ALApplicationList sharedApplicationList];
    
    [self getApp:displayIdentifier];

}

-(void)getApp:(NSString *)bundleID {
    
    NSString *binaryToDump = [al valueForKeyPath:@"bundle.executablePath" forDisplayIdentifier:bundleID];
    
    NSString *binaryName = [binaryToDump lastPathComponent];
    
    [self dumpBinaryAtPath:binaryToDump binaryName:binaryName];
}

-(void)dumpBinaryAtPath:(NSString *)path binaryName:(NSString *)binaryName {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:path]) {
        
        NSTask *task = [NSTask new];
        [task setLaunchPath:[[NSBundle mainBundle] pathForResource:@"class-dump-z" ofType:@"" inDirectory:@""]];
        [task setArguments:[NSArray arrayWithObjects:@"-H", [NSString stringWithFormat:@"%@",path], @"-o", [NSString stringWithFormat:@"/var/mobile/ClassDump/%@",binaryName], nil]];
        [task launch];
        [task release];
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat:@"Your Dumped Headers have been placed at: /var/mobile/ClassDump/%@",binaryName] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [av show];
        [av release];
        
    } else {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Failed to Dump" message:[NSString stringWithFormat:@"Failed to Dump: File not Found"] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [av show];
        [av release];
    }
    
}

-(void)dumpCustomBinary {
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Custom Binary" message:[NSString stringWithFormat:@"Enter a Path to a Binary you want to Dump"] delegate:self cancelButtonTitle:@"Dump" otherButtonTitles:@"Cancel",nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av show];
    [av release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Dump"]) {
        
        UITextField *pathField = [alertView textFieldAtIndex:0];
        
        [self dumpBinaryAtPath:pathField.text binaryName:[pathField.text lastPathComponent]];
    }
    
}

@end

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
