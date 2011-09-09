//
//  ChecklistController.m
//  CCC2
//
//  Created by Kevin McQuown on 5/15/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "ChecklistController.h"
#import "CrushHelper.h"
//#include <dispatch/dispatch.h>

@implementation ChecklistController
@synthesize theList;
@synthesize lastIndexPath;
@synthesize checkedItem;
@synthesize checkListName;
@synthesize delegate;

-(void) getListAsynchronously
{
    
	[self.tableView setAlpha:0.5];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
 //   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSDictionary *theLists=[CrushHelper fetchList:self.checkListName fromTable:@""];
        
        [theList removeAllObjects];
        
        [theList addObjectsFromArray:[theLists objectForKey:@"list"]];
               
//        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self.tableView setAlpha:1];
            [self.tableView reloadData];
 //       });
//    });
}

-(id)initWithListArray:(NSArray *)list withListName:(NSString *)name withChecked:(NSString *)item
{
	if (self=[super initWithStyle:UITableViewStyleGrouped])
	{
		theList=[[NSMutableArray alloc] initWithArray:list];
		checkedItem=item;
		checkListName=name;
		self.title=name;
	}
	return self;
}	

-(id)initWithListName:(NSString *)listName withChecked:(NSString *)item
{	
	if (self=[super initWithStyle:UITableViewStyleGrouped])
	{
		checkedItem=item;
		checkListName=listName;
		self.title=listName;
		
		theList=[[NSMutableArray alloc] init];
		
		[self getListAsynchronously];
	}
	return self;
}


- (void)viewDidLoad {

	[super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [theList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    	
	cell.textLabel.text=[theList objectAtIndex:indexPath.row];
	nothingChecked=YES;
	if ([[theList objectAtIndex:indexPath.row] isEqualToString:self.checkedItem])
	{
		cell.accessoryType=UITableViewCellAccessoryCheckmark;
		lastIndexPath=indexPath;
		nothingChecked=NO;
	}
	else
		cell.accessoryType=UITableViewCellAccessoryNone;

	if (indexPath.row % 2)
		[cell setBackgroundColor:[UIColor whiteColor]];
	else
		[cell setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:1.0f alpha:1.0f]];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if ((indexPath != lastIndexPath) | nothingChecked)
	{
		UITableViewCell *newCell=[tableView cellForRowAtIndexPath:indexPath];
		newCell.accessoryType=UITableViewCellAccessoryCheckmark;
		UITableViewCell *oldCell=[tableView cellForRowAtIndexPath:lastIndexPath];
		oldCell.accessoryType=UITableViewCellAccessoryNone;
		lastIndexPath=indexPath;
		[self.delegate PositionChecked:self checkedItem:[theList objectAtIndex:indexPath.row]];
	}
//	[tableView deselectRowAtIndexPath:indexPath animated:YES];
//	[self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc {
    [theList release];
//    [lastIndexPath release];
//    [checkedItem release];
//    [checkListName release];
    
    [super dealloc];
}

@end

