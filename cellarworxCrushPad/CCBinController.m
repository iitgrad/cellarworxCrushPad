//
//  BinController.m
//  CCC2
//
//  Created by Kevin McQuown on 5/27/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCBinController.h"
#import "BinCell.h"
#import "WTSummaryCellController.h"
#import "WeightMeasurementController.h"
#import "CCWeight.h"
#import "CrushHelper.h"
#import "cellarworxAppDelegate.h"

@implementation CCBinController
@synthesize binTable;
@synthesize wt;
@synthesize binToolBar;
@synthesize weightag;
@synthesize queue;

-(id) initWithWeighTag:(CCWT *)theWeighTag forWeighTag:(NSInteger)tagId 
{
	self=[super initWithNibName:@"BinController" bundle:nil];
	self.queue=[[NSOperationQueue alloc] init];
	[queue setMaxConcurrentOperationCount:1];
	
	self.wt=theWeighTag;
	self.weightag=tagId;
		
	return self;
}

- (void)viewDidLoad {
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	if ([ap staff]) {
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWeight)];
		self.navigationItem.rightBarButtonItem=addButton;		
	}
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.binTable reloadData];
}	

-(IBAction) toggleEdit
{
	BOOL editingState=self.binTable.editing;
	if (!editingState)
	{
		UIBarButtonItem	*doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleEdit)];
		self.navigationItem.rightBarButtonItem=doneButton;
		[self.binToolBar setHidden:YES];
		[doneButton release];
		[self.binTable setEditing:YES animated:YES];
	}
	else
	{
		[self.binToolBar setHidden:NO];
		self.navigationItem.leftBarButtonItem=nil;
		UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEdit)];	
		self.navigationItem.rightBarButtonItem=editButton;
		[self.binTable setEditing:NO animated:YES];
	}
//	editingState=self.binTable.editing;
	[binTable reloadData];
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



#pragma mark
#pragma mark Delegate CallBacks

-(void) updateWeighMeasurement:(CCWeight *)measurement ofMeasurementNumber:(NSUInteger)num 
{
//	[[self.wt.weights objectAtIndex:num] setBincount:measurement.bincount];
//	[[self.wt.weights objectAtIndex:num] setWeight:measurement.weight];
//	[[self.wt.weights objectAtIndex:num] setTare:measurement.tare];
	
	[self.binTable reloadData];
	[self.navigationController popViewControllerAnimated:NO];
	[self addWeight];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section==0)
		return 1;
	else
		return [wt.weights count];
}
-(CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section==0)
		return 95;
	else
		return 60;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (![ap staff]) {
		return UITableViewCellEditingStyleNone;
	}
	
	if (indexPath.section>0)	
		return UITableViewCellEditingStyleDelete;
	return UITableViewCellEditingStyleNone;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section==0)
	{
		WTSummaryCellController *cell = (WTSummaryCellController *)[tableView dequeueReusableCellWithIdentifier:@"SummaryCell"];
		if (cell == nil) {
			NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"WTSummaryCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
		}
		
		cell.grossWeight=[wt totalGross];
		cell.tareWeight=-[wt totalTare];
		cell.netWeight=[wt totalNetWeight];
		cell.totalTons=(float)[wt totalNetWeight]/2000.0;
		cell.totalBinCount=[wt totalBinCount];

//        cell.gross.text=[[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithInt:[wt totalGross]]];
//		cell.tare.text=[[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithInt:-[wt totalTare]]];
//		cell.net.text=[[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithInt:[wt totalNetWeight]]];
//		cell.tons.text=[[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithFloat:([wt totalNetWeight]/2000.0)]];
//		cell.bincount.text=[[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithInt:[wt totalBinCount]]];
//        cell.averageWeightPerBin.text=[[CrushHelper numberFormatQty] 
//									   stringFromNumber:[NSNumber numberWithFloat:[wt.totalNetWeight/wt.totalBinCount]]];		
		[cell setBackgroundColor:[UIColor colorWithRed:0.87f green:0.87f blue:0.8f alpha:1.0f]];
		
		return cell;		
	}
	else
	{
		BinCell *cell = (BinCell *)[tableView dequeueReusableCellWithIdentifier:@"BinCell"];
		if (cell == nil) {
			NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"BinCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
		}
		
		cell.bincount.text=[[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithInt:[[wt.weights objectAtIndex:indexPath.row] bincount]]];
		cell.weight.text=[[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithInt:[[wt.weights objectAtIndex:indexPath.row] weight]]];
		cell.tare.text=[[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithInt:[[wt.weights objectAtIndex:indexPath.row] tare]]];
		cell.total.text=[[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithInt:[[wt.weights objectAtIndex:indexPath.row] netWeight]]];

		cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
		if ([ap staff]) {
			cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;		
		}
		
		return cell;		
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section==1)
	{
		cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
		if ([ap staff]) {
			[self.binTable deselectRowAtIndexPath:indexPath animated:YES];
			WeightMeasurementController *weightController=[[WeightMeasurementController alloc] initWithNibName:@"WeightMeasurementController"
																										bundle:nil
																									  withData:[self.wt.weights objectAtIndex:indexPath.row]
																						   ofMeasurementNumber:indexPath.row];
			weightController.delegate=self;
			[self.navigationController pushViewController:weightController animated:YES];
			[weightController release];
		}
	}

	[self.binTable deselectRowAtIndexPath:indexPath animated:YES];

}
- (void)addWeight
{
	CCWeight *newWeight=[[CCWeight alloc] initWithMeasurementForWT:self.wt.theID theBinCount:2 theWeight:0 theTare:192];
	[self.wt.weights insertObject:newWeight atIndex:0];
	
	WeightMeasurementController *weightController=[[WeightMeasurementController alloc] initWithNibName:@"WeightMeasurementController"
																								bundle:nil
																							  withData:newWeight
																				   ofMeasurementNumber:[self.wt.weights count]];
	weightController.delegate=self;
	[self.navigationController pushViewController:weightController animated:YES];
	[newWeight release];
	[weightController release];
	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		CCWeight *weight=[self.wt.weights objectAtIndex:indexPath.row];
		[weight delete];

		[self.wt.weights removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[tableView reloadData];
	}
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
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

- (void)dealloc {
    [binTable release];
    [wt release];
    [binToolBar release];
    [queue release];
    
    [super dealloc];
}


@end
