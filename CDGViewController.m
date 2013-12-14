#import "CDGViewController.h"
#import "NSTask.h"

@implementation CDGViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	_dataSource = [[ALApplicationTableDataSource alloc] init];
	[_dataSource setSectionDescriptors:[ALApplicationTableDataSource standardSectionDescriptors]];

	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/ClassDump/"]) {
		NSError *error;
    	[[NSFileManager defaultManager] createDirectoryAtPath:@"/var/mobile/ClassDump/" withIntermediateDirectories:NO attributes:nil error:&error];

    	if (error) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Couldn't create directory" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];

			[alertView show];
			[alertView release];
    	}
    }

	UIBarButtonItem *customBinaryButton = [[UIBarButtonItem alloc] initWithTitle:@"Custom Binary" style:UIBarButtonItemStylePlain target:self action:@selector(_customBinaryButtonWasTapped)];

	[self setTitle:@"Class Dump GUI"];
	[[self tableView] setDataSource:_dataSource];
	[_dataSource setTableView:[self tableView]];

	[[self navigationItem] setRightBarButtonItem:customBinaryButton];
	[customBinaryButton release];
}

- (void)dealloc
{
	[_dataSource setTableView:nil];
	[_dataSource release];
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	NSString *displayIdentifier = [_dataSource displayIdentifierForIndexPath:indexPath];
	NSString *binaryPath = [[ALApplicationList sharedApplicationList] valueForKeyPath:@"bundle.executablePath" forDisplayIdentifier:displayIdentifier];

	[self _dumpBinaryAtPath:binaryPath];
}

- (void)_dumpBinaryAtPath:(NSString *)path
{
	NSString *binaryName = [path lastPathComponent];

	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSTask *task = [[NSTask alloc] init];
		[task setLaunchPath:[[NSBundle mainBundle] pathForResource:@"class-dump-z" ofType:nil inDirectory:nil]];
		[task setArguments:[NSArray arrayWithObjects:@"-H", [NSString stringWithFormat:@"%@", path], @"-o", [NSString stringWithFormat:@"/var/mobile/ClassDump/%@", binaryName], nil]];
		[task launch];
		[task release];

		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:[NSString stringWithFormat:@"Your dumped headers have been placed at: /var/mobile/ClassDump/%@", binaryName] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];

		[alertView show];
		[alertView release];
	} else {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed to Dump" message:@"Failed to Dump: file not Found" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}

}

- (void)_customBinaryButtonWasTapped
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

		[self _dumpBinaryAtPath:[textField text]];
	}

}

@end