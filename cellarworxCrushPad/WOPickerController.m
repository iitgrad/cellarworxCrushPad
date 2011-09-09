//
//  WOPickerController.m
//  Crush
//
//  Created by Kevin McQuown on 7/28/10.
//  Copyright (c) 2010 Deck 5 Software. All rights reserved.
//

#import "WOPickerController.h"
#import "CCWTPickerCell.h"
#import "CCWT.h"
#import "CCVineyard.h"

@implementation WOPickerController
@synthesize allWorkOrders;
@synthesize checkedWorkOrders;
@synthesize scp;
@synthesize delegate;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style allWorkOrders:(NSArray *)awo checkedWorkOrders:(NSArray *)cwo forSCP:(CCSCP *)theSCP
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
        self.allWorkOrders=awo;
		checkedWorkOrders=[[NSMutableSet alloc] initWithArray:cwo];
		self.scp=theSCP;
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [allWorkOrders count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CCWTPickerCell";
    
    CCWTPickerCell *cell = (CCWTPickerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"CCWTPickerCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
    }
    
    CCWT *wt=(CCWT *)[allWorkOrders objectAtIndex:indexPath.row];
    cell.tons.text=[NSString stringWithFormat:@"%3.1f tons",([wt totalNetWeight] / 2000.0)];
    cell.number.text=[NSString stringWithFormat:@"WT-%5d",wt.number];
    cell.description.text=[NSString stringWithFormat:@"%@ %@ - %@",wt.vineyard.name,wt.varietal,wt.vineyard.appellation];
	if ([checkedWorkOrders containsObject:[allWorkOrders objectAtIndex:indexPath.row]]) {
		cell.accessoryType=UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType=UITableViewCellAccessoryNone;
	}

//	cell.leftLabel.text=[NSString stringWithFormat:@"%@ %@ - %@",wt.vineyard.name,wt.varietal,wt.vineyard.appellation];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	if ([checkedWorkOrders containsObject:[allWorkOrders objectAtIndex:indexPath.row]])
	{
		[checkedWorkOrders removeObject:[allWorkOrders objectAtIndex:indexPath.row]];
		[(CCWT *)[allWorkOrders objectAtIndex:indexPath.row] setCreatedFromSCP:nil];
		[self.delegate removeWeighTag:[allWorkOrders objectAtIndex:indexPath.row]];
	}
	else
	{
		[checkedWorkOrders addObject:[allWorkOrders objectAtIndex:indexPath.row]];
		[(CCWT *)[allWorkOrders objectAtIndex:indexPath.row] setCreatedFromSCP:scp];
		[self.delegate addWeighTag:[allWorkOrders objectAtIndex:indexPath.row]];
	}

//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[(CCWT *)[allWorkOrders objectAtIndex:indexPath.row] save];
//		dispatch_async(dispatch_get_main_queue(), ^{
			[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//		});
//	});
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [allWorkOrders release];
	[checkedWorkOrders release];
	[scp release];
    [super dealloc];
}


@end

