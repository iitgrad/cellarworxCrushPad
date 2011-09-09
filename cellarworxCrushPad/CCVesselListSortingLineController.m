//
//  CCVesselListSortingLineController.m
//  Crush
//
//  Created by Kevin McQuown on 7/30/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCVesselListSortingLineController.h"
#import "CCVesselDetailSortingLineCell.h"
#import "CCAssetReservation.h"
#import "CrushHelper.h"
#import "CCSCP.h"
#import "WOSummaryCell.h"
#import "CCSCPController.h"
#import "CCTankLoadingController.h"
#import "cellarworxAppDelegate.h"
#import "CCPinController.h"

@implementation CCVesselListSortingLineController
@synthesize scp;
@synthesize theTableView;
@synthesize theToolBar;
@synthesize disableStaffMode;
@synthesize ap;
@synthesize pinPopOver;

#pragma mark -
#pragma mark Initialization


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withVesselList:(CCSCP *)theSCP; {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		self.scp=theSCP;
		ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)staffTimeOut
{
    [ap setStaff:NO];
	disableStaffMode.title=@"Enter Staff Mode";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"staffStatusChanged" object:nil];
}

-(void)secretPicked
{
	[pinPopOver dismissPopoverAnimated:YES];
}

-(void)testStaff
{
	CCPinController *controller=[[CCPinController alloc] initWithNibName:@"CCPinController" bundle:nil];
	controller.delegate=self;
	[controller setContentSizeForViewInPopover:CGSizeMake(320, 400)];
	UIPopoverController *pop=[[UIPopoverController alloc] initWithContentViewController:controller];
	[controller release];
	self.pinPopOver=pop;
	[pop presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	pop.delegate=self;
	[pop release];
}
- (void)startStaffTimer
{
	ap.staffTimer=[NSTimer scheduledTimerWithTimeInterval:kPinDelayTimeInSeconds 
												   target:self 
												 selector:@selector(staffTimeOut)
												 userInfo:nil 
												  repeats:NO];    
}
-(void)updateEditButton
{
 	if ([ap staff])
	{
		UIBarButtonItem *edit=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonClicked:)];
		self.navigationItem.rightBarButtonItem=edit;
		[edit release];	
        [self startStaffTimer];
	}
    else
    {
        UIBarButtonItem *enableStaff=[[UIBarButtonItem alloc] initWithTitle:@"Enable Staff Mode" style:UIBarButtonItemStyleBordered target:self action:@selector(testStaff)];
		self.navigationItem.rightBarButtonItem=enableStaff;
		[enableStaff release];		
    }    
}
- (void)staffStatusChanged
{
    [self performSelectorOnMainThread:@selector(updateEditButton) withObject:nil waitUntilDone:NO];
}

-(void)refreshButtonClicked:(id)sender
{
	[self.theTableView reloadData];
}
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];


	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshButtonClicked:) name:@"sortingTableWasUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(staffStatusChanged) name:@"staffStatusChanged" object:nil];
    
    [self updateEditButton];
//    UIBarButtonItem *refresh=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonClicked:)];
//    self.navigationItem.leftBarButtonItem=refresh;
//	[refresh release];
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.theTableView reloadData];
}

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

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

-(void) editButtonClicked:(id)source
{
	[self.theTableView setEditing:![self.theTableView isEditing]];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (section) {
		case 0:
			return [scp.assetReservations count];
			break;
		default:
			break;
	}
    return 1;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section==0)
		return YES;
	return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	return proposedDestinationIndexPath;
}
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case 0:
			return 90;
			break;
		case 1:
			return 60;
			break;

		default:
			break;
	}
	return 120;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	switch (indexPath.section) {
		case 0:
		{
			static NSString *CellIdentifier = @"CCVesselDetailSortingLineCell";
			
			CCVesselDetailSortingLineCell *cell = (CCVesselDetailSortingLineCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				NSArray *nib=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
				cell = [nib objectAtIndex:0];
			}
			
			// Configure the cell...
			float so2ML=[CrushHelper calcSO2MLWithPPM:scp.sulphurPPM 
											  andTons:([(CCAssetReservation *)[scp.assetReservations objectAtIndex:indexPath.row] binCount]*[scp averageBinWeight])/2000
									 andGallonsPerTon:155];
			cell.so2Label.text=[[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[NSNumber numberWithFloat:so2ML]];
			cell.binCountLabel.text=[[CrushHelper numberFormatQtyNoDecimals] 
									 stringFromNumber:[NSNumber numberWithInt:[(CCAssetReservation *)[scp.assetReservations objectAtIndex:indexPath.row] binCount]]];
			cell.vesselNameLabel.text=[[(CCAssetReservation *)[scp.assetReservations objectAtIndex:indexPath.row] asset] name];
			return cell;
			
		}
			break;
			
		case 1:
		{
			static NSString *cellFormatName=@"WOSummaryCell";
			WOSummaryCell *cell = (WOSummaryCell *)[tableView dequeueReusableCellWithIdentifier:cellFormatName];
			if (cell == nil)
			{
				NSArray *nib=[[NSBundle mainBundle] loadNibNamed:cellFormatName owner:self options:nil];
				cell = [nib objectAtIndex:0];
			}
			
			cell.woStartDate.text=[[CrushHelper dateFormatShortStyle] stringFromDate:[scp date]];
			cell.gallons.text=[NSString stringWithFormat:@"%3.1f tons",[scp.estTons floatValue]];
			cell.woDescription.text=[NSString stringWithFormat:@"%@ %@ - %@",scp.vineyard.name,scp.varietal,scp.vineyard.appellation];
			cell.woType.text=@"SCP";	
			return cell;
			
		}
			break;

		default:
			break;
	}
	return nil;
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
#pragma mark TankPickerControllerDelegate
-(void)setBinsInVessel:(NSUInteger)binCount forReservation:(CCAssetReservation *)reservation
{
	[self dismissModalViewControllerAnimated:YES];
	[reservation setBinCount:binCount];
	[self.theTableView reloadData];
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[reservation save];
//	});
	
}
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	[self.theTableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.section) {
		case 0:
		{
			if ([ap staff]) {
				NSUInteger binsAllocated=0;
				for (int i=0; i<[[scp assetReservations] count]; i++) {
					if (i!=indexPath.row) {
						binsAllocated+=[[[scp assetReservations] objectAtIndex:i] binCount];
					}
				}
				CCTankLoadingController *controller=[[CCTankLoadingController alloc] 
													 initWithNibName:@"CCTankLoadingController"
													 bundle:nil
													 forSCP:scp 
													 andReservation:[scp.assetReservations objectAtIndex:indexPath.row]
													 binsAlreadyAllocated:binsAllocated];
				controller.delegate=self;
				//[controller setModalTransitionStyle:UIModalTransitionStylePartialCurl];
                [controller setModalPresentationStyle:UIModalPresentationFormSheet];
				[self presentModalViewController:controller animated:YES];
				[controller release];
			}
		}
			break;
		case 1:
		{
			CCSCPController *controller=[[CCSCPController alloc] initWithSCP:scp];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];			
		}
			break;

		default:
			break;
	}
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
	[pinPopOver release];
	[disableStaffMode release];
	[theTableView release];
	[theToolBar release];
//	[scp release];
    [super dealloc];
}


@end

