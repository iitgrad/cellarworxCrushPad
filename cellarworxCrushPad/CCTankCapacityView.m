//
//  CCTankCapacityView.m
//  Crush
//
//  Created by Kevin McQuown on 9/30/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCTankCapacityView.h"
#import "CrushHelper.h"
#import "CCSCP.h"
#import "CCAsset.h"
#import "plotRange.h"
#import "plotAttributes.h"

@implementation CCTankCapacityView
@synthesize demandPool;
@synthesize scpPool;
@synthesize capacityPool;
@synthesize tankPool;
@synthesize demand;
@synthesize capacity;
@synthesize remainingCapacity;
@synthesize yAxisRange;
@synthesize xAxisRange;
//@synthesize delegate;

- (NSInteger) dayNumberForDate:(NSDate *)date
{
	NSDateComponents *currentDateComponents=[[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
	
	NSDate *theDate=[[NSCalendar currentCalendar] dateFromComponents:currentDateComponents];
	NSDate *startDate=[[CrushHelper dateFormatSQL] dateFromString:@"2011-09-01"];
	
	return (int)[theDate timeIntervalSinceDate:startDate]/86400.0;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake((frame.size.width-frame.size.width*.8)/2, 
												(frame.size.height-frame.size.height*.8)/2,
												frame.size.width*.8,
												frame.size.height*.8)]) {
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			float totalCapacityPool=0;
			demandPool=[[NSMutableArray alloc] init];
			capacityPool=[[NSMutableArray alloc] init];
			tankPool=[[NSMutableDictionary alloc] init];
			scpPool=[[NSMutableDictionary alloc] init];
			
			NSArray *tanks=[CrushHelper fetchAssetListOfTanks];
			NSArray *scps=[CrushHelper fetchSCPsForSeason];
			NSArray *reservations=[CrushHelper fetchTankCapacityAnalysisData];
			
			NSUInteger maxDaysInTank=0;
			for (CCSCP *s in scps)
			{
				if ([[s daysInTank] intValue]>maxDaysInTank) {
					maxDaysInTank=[[s daysInTank] intValue];
				}
			}
			maxDaysInTank+=90;
			
			for (NSDictionary *item in tanks)
			{
				CCAsset *theAsset=[[CCAsset alloc] initWithDictionary:item];
				[tankPool setObject:theAsset forKey:theAsset.name];
				if ([[theAsset type] isEqualToString:@"TANK"] & ([[theAsset desc] isEqualToString:@"FLOAT"] | [[theAsset desc] isEqualToString:@"OPEN"]| [[theAsset desc] isEqualToString:@"BOLTON"])) {
					totalCapacityPool+=[theAsset gallonsByCylinderOnly];
				}
				[theAsset release];
			}
			for (int i=0; i<maxDaysInTank; i++) {
				[capacityPool addObject:[NSNumber numberWithFloat:totalCapacityPool]];
				[demandPool addObject:[NSNumber numberWithFloat:0]];
			}
			
			// Create scp pool of all scps accessible by scp id
			for (CCSCP *scp in scps)
			{
				[scpPool setObject:scp forKey:[scp theID]];
			}
			
			//Decrement Capacity for each reservation out of the capacity pool
			for (NSDictionary *item in reservations) {
				NSDate *startDate=[[CrushHelper dateFormatSQLLong] dateFromString:[item objectForKey:@"DUEDATE"]];
				NSInteger startIndex=[self dayNumberForDate:startDate];
				CCAsset *theAsset=[tankPool objectForKey:[item objectForKey:@"NAME"]];
				if ([[theAsset type] isEqualToString:@"TANK"] & ([[theAsset desc] isEqualToString:@"FLOAT"] | [[theAsset desc] isEqualToString:@"OPEN"]| [[theAsset desc] isEqualToString:@"BOLTON"])) {
					for (int i=startIndex; i<startIndex+[[item objectForKey:@"ESTDAYSINTANK"] intValue]; i++) {
						float theCapacity=[[capacityPool objectAtIndex:i] floatValue];
						CCAsset *theAsset=[tankPool objectForKey:[item objectForKey:@"NAME"]];
						float tankCapacity=[theAsset gallonsByCylinderOnly];
						theCapacity-=tankCapacity;
						[capacityPool replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:theCapacity]];
					}
				}
			}
			
			//Remove each scp that has tank reservations from the list so that they are not added to the demand pool
			for (NSDictionary *item in reservations) {
				NSString *scpID=[item objectForKey:@"SCPID"];
				[scpPool removeObjectForKey:scpID];
			}
			
			//All remaining scps should be added to the demand pool
			for (NSString *scpID in [scpPool allKeys])
			{
				CCSCP *scp=[scpPool objectForKey:scpID];
				NSDate *startDate=[scp date];
				NSInteger startIndex=[self dayNumberForDate:startDate];
				NSInteger daysInTank=[[scp daysInTank] intValue];
				if (daysInTank<0) {
					[NSException raise:@"invalid days in tank" format:@""];
				}
				for (int i=startIndex; i<startIndex+[[scp daysInTank] intValue]; i++) {
					float theDemand=[[demandPool objectAtIndex:i] floatValue];
					theDemand+=[[scp estTons] floatValue]*275;
					[demandPool replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:theDemand]];
				}
			}
			
			NSInteger lowPoint=totalCapacityPool;
			NSInteger dayAtLowPoint=0;
			for (int i=0; i<maxDaysInTank; i++)
			{
				if (([[capacityPool objectAtIndex:i] floatValue]-[[demandPool objectAtIndex:i] floatValue])<lowPoint) {
					lowPoint=[[capacityPool objectAtIndex:i] floatValue]-[[demandPool objectAtIndex:i] floatValue];
					dayAtLowPoint=i;
				}
			}
			NSMutableArray *d=[[NSMutableArray alloc] init];
			for (NSNumber *n in demandPool)
			{
				[d addObject:[NSNumber numberWithFloat:[n floatValue]/275]];
			}
			demand=[[NSArray alloc] initWithArray:d];
			[d release];
			
			NSMutableArray *c=[[NSMutableArray alloc] init];
			for (NSNumber *n in capacityPool)
			{
				[c addObject:[NSNumber numberWithFloat:[n floatValue]/275]];
			}
			capacity=[[NSArray alloc] initWithArray:c];
			[c release];
			
			NSMutableArray *r=[[NSMutableArray alloc] init];
			for (int i=0; i<[demand count]; i++) {
				float d=[[demand  objectAtIndex:i] floatValue];
				float c=[[capacity  objectAtIndex:i] floatValue];
				[r addObject:[NSNumber numberWithFloat:c-d]];
			}
			remainingCapacity=[[NSArray alloc] initWithArray:r];
			[r release];
			
			yAxisRange=[[plotRange alloc] initWithLocation:-50 andLength:500];
			xAxisRange=[[plotRange alloc] initWithLocation:0 andLength:90];
			
			graphView *graph=[[graphView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
			graph.delegate=self;
			graph.dataSource=self;
			
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
			[self addSubview:graph];

			UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width, 50)];
			[title setText:@"Tank Capacity Forecast"];
			[title setBackgroundColor:[UIColor clearColor]];
			[title setTextColor:[CrushHelper backGroundTheme]];
			[title setFont:[UIFont systemFontOfSize:20]];
			[title setTextAlignment: UITextAlignmentCenter];
			[self addSubview:title];
			[title release];
			
			[self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
			[delegate viewReadyForDisplay:self];
		});		
    }
    return self;
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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    NSLog(@"parent graph view getting drawn");
//}


- (void)dealloc {
	[demand release];
	[capacity release];
	[remainingCapacity release];
	[scpPool release];
	[demandPool release];
	[tankPool release];
	[capacityPool release];
	
    [super dealloc];
}


@end
