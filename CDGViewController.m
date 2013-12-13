#import "CDGViewController.h"
#import "NSTask.h"

@implementation CDGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    dataSource = [[ALApplicationTableDataSource alloc] init];
    NSString *sectionDescriptorsPath = [[NSBundle mainBundle] pathForResource:@"com.jack.cdg.settings" ofType:@"plist"];
    dataSource.sectionDescriptors = [NSArray arrayWithContentsOfFile:sectionDescriptorsPath];

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

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Custom Binary" message:[NSString stringWithFormat:@"Enter a Path to a Binary you want to Dump"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Dump",nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av show];
    [av release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {

        UITextField *pathField = [alertView textFieldAtIndex:0];

        [self dumpBinaryAtPath:pathField.text binaryName:[pathField.text lastPathComponent]];
    }

}

@end