//
//  CCSortingTableScheduleController.m
//  Crush
//
//  Created by Kevin McQuown on 7/19/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCSortingTableScheduleController.h"
#import "CCSortingTable.h"
#import "CCSortingTableActivity.h"
#import "cellarworxAppDelegate.h"
#import "CCSortingActivityCellController.h"
#import "CCSCP.h"
#import "CCAsset.h"
#import "CrushHelper.h"
#import "CCVesselListSortingLineController.h"
#import "CCPinController.h"
#import "CCTankCapacityGraphController.h"
#import "CCSCPForecastView.h"
#import "CCTankCapacityView.h"
#import "QuartzCore/QuartzCore.h"

//#include <dispatch/dispatch.h>
#define maxNumberOfReports 2

@implementation CCSortingTableScheduleController
@synthesize timer;
@synthesize pinPopOver;
@synthesize statusLabel;
@synthesize theTableView;
@synthesize theToolBar;
@synthesize disableStaffMode;
@synthesize vesselList;
@synthesize chosenSCP;
@synthesize dataViewController;
@synthesize dataViewTimer;
@synthesize currentView;
@synthesize nextView;
@synthesize tempView;

#pragma mark -
#pragma mark Initialization

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	reportNumber=0;
	return self;
}

#pragma mark -
#pragma mark SortingCell delegate
-(void) buttonClicked:(id)sender
{
	if ([ap staff])
	{
		if (![[[[ap sortingTable] activities] objectAtIndex:0] onTable])
		{
			[[ap sortingTable] startedTopMostActivity];
			[self.theTableView reloadData];
		}
		else 
		{
			//		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			[[ap sortingTable] completeTopMostActivity];
			//			dispatch_async(dispatch_get_main_queue(), ^{
			[self.theTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
			//			});
			//		});		
		}		
	}
}

#pragma mark -
#pragma mark Timer functions

- (void)staffTimeOut
{
    [ap setStaff:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"staffStatusChanged" object:nil];
}

- (void)startStaffTimer
{
	ap.staffTimer=[NSTimer scheduledTimerWithTimeInterval:kPinDelayTimeInSeconds 
                                                        target:self 
                                                        selector:@selector(staffTimeOut)
                                                        userInfo:nil 
                                                         repeats:NO];    
}

-(void) secondPassed:(id)sender
{
	if (![self.theTableView isEditing])
	{
		if ([[[ap sortingTable] activities] count] > 0)
		{
			[[ap sortingTable] calculateTableSchedule];
			[self.theTableView reloadData];
		}
	}
}

#pragma mark -
#pragma mark network traffic

-(void)refreshTable:(id)sender
{
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[[ap sortingTable] initFromServerWithRefresh:YES];
//		dispatch_async(dispatch_get_main_queue(), ^{
//			[[[[ap mapTagsToControllers] objectForKey:[NSNumber numberWithInt:ksorting]] tabBarItem] setBadgeValue:nil];
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			[self.theTableView reloadData];
			if (vesselList!=nil)
			{
				[self.navigationController popViewControllerAnimated:NO];
				[vesselList release];
				vesselList=[[CCVesselListSortingLineController alloc] initWithNibName:@"CCVesselListSortingLineController" bundle:nil withVesselList:[(CCSortingTableActivity *)[[[ap sortingTable] activities] objectAtIndex:chosenSCP.row] scp]];
				[self.navigationController pushViewController:vesselList animated:NO];
			}
//			[[NSNotificationCenter defaultCenter] postNotificationName:@"sortingTableWasUpdated" object:nil];
//		});
//	});	
//	[timer invalidate];
//	[timer release];
//	timer=nil;
//	[self startTimer];	
}
-(void)refreshButtonClicked:(id)sender
{
	if ([self.theTableView isEditing]) {
		[self.theTableView setEditing:NO];
	}
	[self refreshTable:self];
}

#pragma mark -
#pragma mark View lifecycle

-(void) clientVintageChanged
{
    [ap setClientVintageChanged:YES];
	[self viewWillAppear:YES];
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

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshButtonClicked:) name:@"sortingTableNeedsUpdating" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(staffStatusChanged) name:@"staffStatusChanged" object:nil];
    
    [self updateEditButton];
    UIBarButtonItem *refresh=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonClicked:)];
    self.navigationItem.leftBarButtonItem=refresh;
	[refresh release];
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[[ap sortingTable] initFromServerWithRefresh:NO];
		dispatch_async(dispatch_get_main_queue(), ^{
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			[self.theTableView reloadData];
		});
		
	});	
}
- (NSInteger) dayNumberForDate:(NSDate *)date
{
	NSDateComponents *currentDateComponents=[[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
	
	NSDate *theDate=[[NSCalendar currentCalendar] dateFromComponents:currentDateComponents];
	NSDate *startDate=[[CrushHelper dateFormatSQL] dateFromString:@"2010-09-01"];
	
	return (int)[theDate timeIntervalSinceDate:startDate]/86400.0;
}

//- (void) closeTankGraph
//{
//	[UIView animateWithDuration:.5 animations:^{
//		[dataViewController.view setFrame:CGRectZero];
//		[dataViewController.view setAlpha:0];
//	}
//	completion:^(BOOL finished) {
//		[dataViewController.view removeFromSuperview];
//		[dataViewController release];
//		dataViewController=nil;
//	}];
//}

-(void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state==UIGestureRecognizerStateRecognized) {
		NSLog(@"retain: %d",[currentView retainCount]);
		[currentView removeFromSuperview];
		NSLog(@"retain after remove from superview: %d",[currentView retainCount]);
		currentView=nil;
		[self.view setAlpha:1.0];
	}	
}

-(void) viewReadyForDisplay:(UIView *)theView
{
	nextView=theView;
	UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	[tapGesture setNumberOfTapsRequired:1];
	tapGesture.delegate=self;
	[currentView setGestureRecognizers:[NSArray arrayWithObject:tapGesture]];
	[tapGesture release];
}

- (void) generateReport
{
	NSLog(@"generating report");
	switch (reportNumber) {
		case 0:
		{
//			tempView=[[CCSCPForecastView alloc] initWithFrame:self.view.frame];
			tempView=[[CCTankCapacityView alloc] initWithFrame:self.view.frame];
		}
			break;
		case 1:
		{
			tempView=[[CCTankCapacityView alloc] initWithFrame:self.view.frame];
		}
			break;

		default:
			break;
	}
//	[tempView setHidden:YES];
	[(CCTankCapacityView *)tempView setDelegate:self];
}
-(void) showNextReport
{
	if (nextView==nil) {
		return;
	}
	[currentView removeFromSuperview];
	currentView=nextView;
	[self.view insertSubview:currentView belowSubview:self.view];
	[nextView release];
	nextView=nil;
	reportNumber++;
	if (reportNumber>maxNumberOfReports-1) {
		reportNumber=0;
	}
	[self generateReport];
}
- (void)startTimers
{
	self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(secondPassed:) userInfo:nil repeats:YES];
	self.dataViewTimer=[NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(showNextReport) userInfo:nil repeats:YES];
	[self generateReport];
}
//-(void) changeDataView
//{
//	if (dataViewController!=nil) {
//		[self closeTankGraph];
//	}
//	[self showTankGraph];
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (vesselList!=nil) {
		[vesselList release];
		vesselList=nil;
	}
	[self startTimers];
	[self.theTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	if (timer)
	{
		[timer invalidate];
		self.timer=nil;		
	}
    [super viewWillDisappear:animated];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self.view layoutSubviews];
}
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([ap staff])
	{
		if (editingStyle==UITableViewCellEditingStyleDelete) {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[[ap sortingTable] removeActivity:[[[ap sortingTable] activities] objectAtIndex:indexPath.row]];
				dispatch_async(dispatch_get_main_queue(), ^{
					[self.theTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
				});
			});
		}		
	}
}

- (void)moveRowsMainProcess
{
	[self.theTableView reloadData];
}
- (void)moveRowsBackgroundProcess:(id)object
{
	NSIndexPath *sourceIndexPath=[object objectForKey:@"sourceIndexPath"];
	NSIndexPath *destinationIndexPath=[object objectForKey:@"destinationIndexPath"];
	[[ap sortingTable] moveRow:sourceIndexPath.row toRow:destinationIndexPath.row];
	[[ap sortingTable] calculateTableSchedule];
	[self.theTableView setEditing:NO];
	[self performSelectorOnMainThread:@selector(moveRowsMainProcess) withObject:nil waitUntilDone:NO];
	//		dispatch_async(dispatch_get_main_queue(), ^{
	//			[self.theTableView reloadData];
	//		});
	
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
	NSDictionary *args=[[NSDictionary alloc] initWithObjectsAndKeys:sourceIndexPath,@"sourceIndexPath",destinationIndexPath,@"destinationIndexPath",nil];
	NSInvocationOperation *myOp=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(moveRowsBackgroundProcess:) object:args];
	[[ap queue] addOperation:myOp];		

//	[self performSelectorInBackground:@selector(moveRowsBackgroundProcess:) withObject:args];
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//		[[ap sortingTable] moveRow:sourceIndexPath.row toRow:destinationIndexPath.row];
//		[[ap sortingTable] calculateTableSchedule];
//		[self.theTableView setEditing:NO];
//		dispatch_async(dispatch_get_main_queue(), ^{
//			[self.theTableView reloadData];
//		});
//	});
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([[[[ap sortingTable]activities]objectAtIndex:indexPath.row] onTable])
		return NO;
	
	return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	if (proposedDestinationIndexPath.row==0 & [[[[ap sortingTable] activities] objectAtIndex:proposedDestinationIndexPath.row] onTable]) {
		return [NSIndexPath indexPathForRow:1 inSection:0];
	}
	else {
		return proposedDestinationIndexPath;
	}

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[ap sortingTable] activities] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ActivityCell";
    
    CCSortingActivityCellController *cell = (CCSortingActivityCellController *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"CCSortingActivityCellController" owner:self options:nil];
		cell = [nib objectAtIndex:0];
    }
    
	cell.delegate=self;
	CCSortingTableActivity *activity=[[[ap sortingTable] activities] objectAtIndex:indexPath.row];
	[cell.clientCode setText:[[activity scp] clientcode]];
	cell.color1.backgroundColor=[[activity scp] color1];
	if ([[activity scp] color2]==nil)
		cell.color2.backgroundColor=[[activity scp] color1];
	else 
		cell.color2.backgroundColor=[[activity scp] color2];
	
	NSMutableString *tankList=[[NSMutableString alloc] init];
	for (CCAssetReservation *reservation in [[activity scp] assetReservations]) {
		[tankList appendFormat:@"%@ ",[[reservation asset] name]];
	}
    cell.tankList.text=tankList;
	[tankList release];
	
	cell.estimatedStartTime.text=[[CrushHelper timeOfDayFormat] stringFromDate:[activity estimatedTimeOnTable]];
	cell.tons.text=[NSString stringWithFormat:@"Tons: %@",[[CrushHelper numberFormatQtyWithDecimals:1] stringFromNumber:[NSNumber numberWithFloat:[[activity scp] actualTons]]]];
	cell.sulphur.text=[NSString stringWithFormat:@"SO2: %@ ppm",[[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[NSNumber numberWithInt:[[activity scp] sulphurPPM]]]];
	if (indexPath.row==0)
		{
            if ([ap staff])
            {
                [cell.actionButton setHidden:NO];
                [cell.statusLabel setHidden:YES];
                if ([[[[ap sortingTable] activities] objectAtIndex:indexPath.row] onTable])
                    [cell.actionButton setTitle:@"Complete" forState:UIControlStateNormal];
                else
                    [cell.actionButton setTitle:@"Start" forState:UIControlStateNormal];                
            }
            else
            {
                [cell.actionButton setHidden:YES];
                [cell.statusLabel setHidden:NO];
                if ([[[[ap sortingTable] activities] objectAtIndex:indexPath.row] onTable])
                    cell.statusLabel.text=@"IN PROGRESS";
                else
                    cell.statusLabel.text=@"AWAITING START";                
            }
		}
	else 
    {
		[cell.actionButton setHidden:YES];
        [cell.statusLabel setHidden:YES];
    }
	
	cell.lotDescription.text=[NSString stringWithFormat:@"%@: %@",activity.scp.lotNumberString,activity.scp.lotDescriptionString];
	cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
	cell.showsReorderControl=YES;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	if ([ap staff]) {
		return YES;
	}
    return NO;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[self.theTableView deselectRowAtIndexPath:indexPath animated:YES];
	chosenSCP=indexPath;
	vesselList=[[CCVesselListSortingLineController alloc] initWithNibName:@"CCVesselListSortingLineController" bundle:nil withVesselList:[(CCSortingTableActivity *)[[[ap sortingTable] activities] objectAtIndex:chosenSCP.row] scp]];
	[self.navigationController pushViewController:vesselList animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"sortingTableNeedsUpdating" object:nil];	
}


- (void)dealloc {
	[tempView release];
	[nextView release];
	[currentView release];
	[dataViewTimer release];
	[dataViewController release];
	[chosenSCP release];
	[vesselList release];
	[disableStaffMode release];
	[theTableView release];
	[theToolBar release];
	[pinPopOver release];
	[statusLabel release];
	if (timer)
		[timer invalidate];
	self.timer=nil;
    [super dealloc];
}


@end

