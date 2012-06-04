//
//  RootViewController.m
//  
//
//  Created by David Murray on 12-06-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        dataSource = [[ALApplicationTableDataSource alloc] init];
		dataSource.sectionDescriptors = [ALApplicationTableDataSource standardSectionDescriptors];
        

        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = dataSource;
	dataSource.tableView = self.tableView;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    dataSource.tableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    dataSource.tableView = nil;
	[dataSource release];
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    progressAlert = [[UIAlertView alloc] initWithTitle: @""
                                               message: @"Please wait..."
                                              delegate: self
                                     cancelButtonTitle: nil
                                     otherButtonTitles: nil];

    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(139.0f-18.0f, 50, 37.0f, 37.0f);
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    [activityView release];
    
    [progressAlert show];
    [progressAlert release];

    
	NSString *displayIdentifier = [dataSource displayIdentifierForIndexPath:indexPath];
    NSString *appPath = [self pathForBundleIdentifier:displayIdentifier];
	NSString *appName = [[[ALApplicationList sharedApplicationList] applications] objectForKey:displayIdentifier];
    omgPath = appPath;
    omgName = appName;
                       
    if ([appPath isEqualToString:@"Error - userApps contents of dir."] || [appPath isEqualToString:@"Error - userContents"] ||  [appPath isEqualToString:@"Error - SystemApps"]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Please report this error to the developer: \n %@",appPath] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [av show];
        [av release];
        return;
    }
    
       
        
    [self classDumpExecutable];


}

- (NSString *)pathForBundleIdentifier:(NSString *)bundleID {
    //Thanks @0_Maximus_0. Follow this guy on twitter. Seriously.
    //Nevermind, don't.
    NSError *fError = nil;
    
	NSArray *userApps = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/User/Applications/" error:&fError];
    if (fError) { 
        return @"Error - userApps contents of dir.";
    }
	NSMutableDictionary *allApps = [[NSMutableDictionary alloc] init];
    
	for (NSString *_shit in userApps) {
        
		NSError *rError = nil;
		NSArray *userContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSString stringWithFormat:@"/User/Applications/%@/", _shit] error:&rError];
        if (rError)  {
            return @"Error - userContents";
        }
		for (NSString *_item in userContents) {
			if ([_item hasSuffix:@"app"]) {
				NSDictionary *bd = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/User/Applications/%@/%@/Info.plist", _shit, _item]];
                [allApps setObject:[NSString stringWithFormat:@"/User/Applications/%@/%@/%@", _shit, _item, [bd objectForKey:@"CFBundleExecutable"]] forKey:[bd objectForKey:@"CFBundleIdentifier"]];
				[bd release];
			}
		}
	}
	NSArray *systemApps = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Applications/" error:&fError];
    if (fError) { 
        return @"Error - SystemApps";
    }
	for (NSString *_app in systemApps) {
		if ([_app hasSuffix:@"app"]) {
			NSDictionary *abd = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/Applications/%@/Info.plist", _app]];
			if (!abd) continue;
			if ([abd objectForKey:@"CFBundleIdentifier"])
                [allApps setObject:[NSString stringWithFormat:@"/Applications/%@/%@", _app, [abd objectForKey:@"CFBundleExecutable"]] forKey:[abd objectForKey:@"CFBundleIdentifier"]];
		}
	}
    //hax to release 'allApps'.
    //:p
    NSString *temp = [allApps objectForKey:bundleID];
    [allApps release];
    return temp;
}
- (void)classDumpExecutable {
    //There's a lot of hardcoding in here :(
    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/ClassDump.app/class-dump_output/" isDirectory:NULL]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:@"/Applications/ClassDump.app/class-dump_output" withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
    NSTask *task = [NSTask new]; 
    [task setLaunchPath:[[NSBundle mainBundle] pathForResource:@"class-dump-z" ofType:@"" inDirectory:@""]];
    [task setArguments:[NSArray arrayWithObjects:@"-H", [NSString stringWithFormat:@"%@",omgPath], @"-o", [NSString stringWithFormat:@"/Applications/ClassDump.app/class-dump_output/%@",omgName], nil]];
    [task launch];
    [task release];

    [progressAlert dismissWithClickedButtonIndex:0 animated:YES];

    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/Applications/ClassDump.app/class-dump_output/%@/",omgName]]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success!" message:[NSString stringWithFormat:@"The files are availiple at /Applications/ClassDump.app/class-dump_output/%@",omgName] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [av show];
        [av release];
    }
    else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"A problem happened. Please try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [av show];
        [av release];
    }
}
@end
