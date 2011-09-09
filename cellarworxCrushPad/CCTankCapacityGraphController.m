//
//  CCTankCapacityGraphController.m
//  Crush
//
//  Created by Kevin McQuown on 9/14/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCTankCapacityGraphController.h"
#import "CrushHelper.h"

@implementation CCTankCapacityGraphController
@synthesize demand;
@synthesize capacity;
@synthesize yAxisRange;
@synthesize xAxisRange;
@synthesize remainingCapacity;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/

-(id) initWithDemand:(NSArray *)theDemand andCapacity:(NSArray *)theCapacity
{
	self=[super init];
	NSMutableArray *d=[[NSMutableArray alloc] init];
	for (NSNumber *n in theDemand)
	{
		[d addObject:[NSNumber numberWithFloat:[n floatValue]/275]];
	}
	demand=[[NSArray alloc] initWithArray:d];
	[d release];
	
	NSMutableArray *c=[[NSMutableArray alloc] init];
	for (NSNumber *n in theCapacity)
	{
		[c addObject:[NSNumber numberWithFloat:[n floatValue]/275]];
	}
	capacity=[[NSArray alloc] initWithArray:c];
	[c release];

	NSMutableArray *r=[[NSMutableArray alloc] init];
	for (int i=0; i<[demand count]; i++) {
		float d=[[demand objectAtIndex:i] floatValue];
		float c=[[capacity objectAtIndex:i] floatValue];
		[r addObject:[NSNumber numberWithFloat:c-d]];
	}
	remainingCapacity=[[NSArray alloc] initWithArray:r];
	[r release];

	yAxisRange=[[plotRange alloc] initWithLocation:-50 andLength:500];
	xAxisRange=[[plotRange alloc] initWithLocation:0 andLength:90];
	return self;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	graph.yAxisLabelValue=@"Tons";
	graph.textAxisColor=[UIColor darkGrayColor];
	graph.axisColor=[UIColor grayColor];
	graph.backGroundColor=[UIColor whiteColor];
	graph.xAxisYPosition=0;  //Put y axis at position 0 on the x axis.
	graph.centerX=[self rangeOfXAxis].length/2+[self rangeOfXAxis].location;
	graph.scaleX=1.0;
	graph.centerY=[self rangeOfYAxis].length/2+[self rangeOfYAxis].location;
	graph.scaleY=1.0;
//	graph.centerY2=[self rangeOfYAxis2].length/2+[self rangeOfYAxis2].location;
//	graph.scaleY2=1.0;	
	
	graph.xAxisFormatter=[CrushHelper numberFormatQtyNoDecimals];

}

#pragma mark  -
#pragma mark graphViewController delegate
-(BOOL) twoAxis{
	return NO;
}
-(plotRange *)rangeOfXAxis
{
	return [[[plotRange alloc] initWithLocation:0 andLength:90] autorelease];
}
-(plotRange *)rangeOfYAxis
{
	return [[[plotRange alloc] initWithLocation:-100 andLength:600] autorelease];
}

-(NSUInteger)numberOfPlotsForAxis:(int)axis {
	return 3;
}
-(NSUInteger)numberOfPointsForPlot:(int)plotNumber forAxis:(int)axis
{
	return [demand count];
}
-(NSNumber *)numberForPlot:(int)plotNumber forPoint:(int)pointNumber forAxis:(int)axis
{
	switch (plotNumber) {
		case 0:
			return [demand objectAtIndex:pointNumber];
			break;
		case 1:
			return [capacity objectAtIndex:pointNumber];
			break;
		case 2:
			return [remainingCapacity objectAtIndex:pointNumber];
			break;
		default:
			break;
	}
	return 0;
}
-(plotAttributes *)getPlotAttributesForPlot:(int)plotNumber forAxis:(int)axis
{
	plotAttributes *attr=[[[plotAttributes alloc] init] autorelease];
	attr.thickness=1.5;
	switch (plotNumber) {
		case 0:
		{
			attr.color=[UIColor blueColor];
			attr.areaColor=[attr.color colorWithAlphaComponent:.25];
			attr.axis=0;
			attr.showAreaUnderCurve=NO;
		}
			break;
		case 1:
		{
			attr.color=[UIColor redColor];
			attr.areaColor=[attr.color colorWithAlphaComponent:.25];
			attr.axis=1;
			attr.showAreaUnderCurve=NO;
		}
			break;
		case 2:
		{
			attr.color=[UIColor greenColor];
			attr.areaColor=[attr.color colorWithAlphaComponent:.25];
			attr.axis=1;
			attr.showAreaUnderCurve=NO;
		}
			break;
		default:
			break;
	}
	return attr;
}
-(id) valueForXPoint:(NSInteger)x
{
	return [NSNumber numberWithInt:x];
}
-(float) pointForXAxis:(NSInteger)x andPlotNumber:(NSInteger)plotNumber forAxis:(int)axis
{
	switch (plotNumber) {
		case 0:
			return [[demand objectAtIndex:x] floatValue];
			break;
		case 1:
			return [[capacity objectAtIndex:x] floatValue];
			break;
		case 2:
			return [[remainingCapacity objectAtIndex:x] floatValue];
			break;
		default:
			break;
	}
	return 0;
}


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
	[remainingCapacity release];
	[xAxisRange release];
	[yAxisRange release];
	[demand release];
	[capacity release];
    [super dealloc];
}


@end

