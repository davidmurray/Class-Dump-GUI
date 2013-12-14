#import "CDGViewController.h"
#import "NSTask.h"

@implementation CDGViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	dataSource = [[ALApplicationTableDataSource alloc] init];
	dataSource.sectionDescriptors = [ALApplicationTableDataSource standardSectionDescriptors];

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
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

	[self getApp:displayIdentifier];

}

-(void)getApp:(NSString *)bundleID {

	NSString *binaryToDump = [[ALApplicationList sharedApplicationList] valueForKeyPath:@"bundle.executablePath" forDisplayIdentifier:bundleID];

	NSString *binaryName = [binaryToDump lastPathComponent];

	[self dumpBinaryAtPath:binaryToDump binaryName:binaryName];
}

- (void)dumpBinaryAtPath:(NSString *)path binaryName:(NSString *)binaryName
{
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSTask *task = [[NSTask alloc] init];
		[task setLaunchPath:[[NSBundle mainBundle] pathForResource:@"class-dump-z" ofType:nil inDirectory:nil]];
		[task setArguments:[NSArray arrayWithObjects:@"-H", [NSString stringWithFormat:@"%@", path], @"-o", [NSString stringWithFormat:@"/var/mobile/ClassDump/%@", binaryName], nil]];
		[task launch];
		[task release];

		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat:@"Your Dumped Headers have been placed at: /var/mobile/ClassDump/%@", binaryName] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];

		[alertView show];
		[alertView release];
	} else {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed to Dump" message:@"Failed to Dump: File not Found" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}

}

- (void)dumpCustomBinary
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Custom Binary" message:@"Enter a path to a binary you want to dump" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Dump",nil];
	[alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
	[alertView show];
	[alertView release];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		UITextField *textField = [alertView textFieldAtIndex:0];

		[self dumpBinaryAtPath:[textField text] binaryName:[[textField text] lastPathComponent]];
	}

}

@end