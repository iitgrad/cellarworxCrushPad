//
//  CC702.m
//  Crush
//
//  Created by Kevin McQuown on 6/24/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CC702.h"
#import "CC702Section.h"
#import "CC702Event.h"
#import "CCWorkOrder.h"
#import "CCWT.h"
#import "CCTest.h"
#import "CCBOL.h"
#import "CCBOLItem.h"
#import "CCBlend.h"
#import "CCLot.h"
#import "CCActivity.h"

static const int theTable[23][6]={
	{1,1,-1,-1,-1,-1},
	{1,1,-1,-1,-1,-1},
	{2,-1,2,-1,-1,-1},
	{3,-1,-1,3,-1,-1},
	{4,-1,-1,-1,4,-1},
	{5,-1,-1,-1,-1,5},
	{-1,0,-1,-1,-1,-1},
	{-1,-1,6,-1,-1,-1},
	{-1,-1,-1,6,-1,-1},
	{-1,-1,-1,-1,6,-1},
	{-1,-1,-1,-1,-1,6},
	{-1,-1,7,-1,-1,-1},
	{-1,-1,-1,7,-1,-1},
	{-1,-1,-1,-1,7,-1},
	{-1,-1,-1,-1,-1,7},
	{-1,2,2,2,4,4},
	{-1,3,3,3,5,5},
	{-1,-1,4,5,4,5},
	{1,1,2,3,4,5},
	{1,1,2,3,-1,-1},
	{2,2,2,3,-1,-1},
	{3,3,2,3,-1,-1},
	{1,1,2,3,-1,-1}
};

@implementation CC702
@synthesize history;
@synthesize wineState;
@synthesize volume;
	
-(float) isAlcoholTestWithValue:(id)wo
{
	if ([wo labtest] != nil) {
		for (CCTest *aTest in [[wo labtest] tests])
		{
			if ([[aTest test] isEqualToString:@"ALCOHOL"] | [[aTest test] isEqualToString:@"Ethanol"])
					return aTest.value;
		}
	}
	return 0;
}

-(float) changeInVolume:(id)wo
{
	if ([[wo class] isSubclassOfClass:[CCWT class]])
    {
        return (float)[wo totalNetWeight]/2000.0*155.0;
    }
    if ([[wo class] isSubclassOfClass:[CCBOL class]])
    {
		if ([[(CCBOL *)wo direction] isEqualToString:@"IN"])
			return [[wo BOLItem] gallons];
		else 
			return -[[wo BOLItem] gallons];
    }
	
    if ([[wo class] isSubclassOfClass:[CCSCP class]])
		return 0;
	if ([(CCWorkOrder *)wo inventoryAdjusted])
		return [wo derivedVolume];
	return 0;
}

-(int) getWOCodeFromWO:(id)wo
{
	if ([[wo class] isSubclassOfClass:[CCWT class]])
	{
		return 0;
	}
	if ([[wo class] isSubclassOfClass:[CCBOL class]])
	{
		CCBOL *bol=wo;
		if ([[bol direction] isEqualToString:@"IN"] & [[[bol BOLItem] type] isEqualToString:@"JUICE"]) return 1;
		if ([[bol direction] isEqualToString:@"IN"] &
			[[[bol BOLItem] type] isEqualToString:@"WINE"] & 
			[[[bol BOLItem] alcoholLevel] isEqualToString:@"<14%"] ) return 2;
		if ([[bol direction] isEqualToString:@"IN"] &
			[[[bol BOLItem] type] isEqualToString:@"WINE"] & 
			[[[bol BOLItem] alcoholLevel] isEqualToString:@">=14%"] ) return 3;
		if ([[bol direction] isEqualToString:@"IN"] &
			[[[bol BOLItem] type] isEqualToString:@"BOTTLED"] & 
			[[[bol BOLItem] alcoholLevel] isEqualToString:@"<14%"] ) return 4;
		if ([[bol direction] isEqualToString:@"IN"] &
			[[[bol BOLItem] type] isEqualToString:@"BOTTLED"] & 
			[[[bol BOLItem] alcoholLevel] isEqualToString:@">=14%"] ) return 5;
		if ([[bol direction] isEqualToString:@"OUT"] & (wineState == 1)) return 6;
		if ([[bol direction] isEqualToString:@"OUT"] &
			(wineState == 2 | wineState == 3) & 
			[[[bol BOLItem] alcoholLevel] isEqualToString:@"<14%"] &
			[[bol taxClass] isEqualToString:@"BONDTOBOND"] ) return 7;
		if ([[bol direction] isEqualToString:@"OUT"] &
			(wineState == 2 | wineState == 3) & 
			[[[bol BOLItem] alcoholLevel] isEqualToString:@">=14%"] &
			[[bol taxClass] isEqualToString:@"BONDTOBOND"] ) return 8;
		if ([[bol direction] isEqualToString:@"OUT"] &
			(wineState == 4 | wineState == 5) & 
			[[[bol BOLItem] alcoholLevel] isEqualToString:@"<14%"] &
			[[bol taxClass] isEqualToString:@"BONDTOBOND"] ) return 9;
		if ([[bol direction] isEqualToString:@"OUT"] &
			(wineState == 4 | wineState == 5) & 
			[[[bol BOLItem] alcoholLevel] isEqualToString:@">=14%"] &
			[[bol taxClass] isEqualToString:@"BONDTOBOND"] ) return 10;
		if ([[bol direction] isEqualToString:@"OUT"] &
			(wineState == 2 | wineState == 3) & 
			[[[bol BOLItem] alcoholLevel] isEqualToString:@"<14%"] &
			[[bol taxClass] isEqualToString:@"TAXPAID"] ) return 11;
		if ([[bol direction] isEqualToString:@"OUT"] &
			(wineState == 2 | wineState == 3) & 
			[[[bol BOLItem] alcoholLevel] isEqualToString:@">=14%"] &
			[[bol taxClass] isEqualToString:@"TAXPAID"] ) return 12;
		if ([[bol direction] isEqualToString:@"OUT"] &
			(wineState == 4 | wineState == 5) & 
			[[[bol BOLItem] alcoholLevel] isEqualToString:@"<14%"] &
			[[bol taxClass] isEqualToString:@"TAXPAID"] ) return 13;
		if ([[bol direction] isEqualToString:@"OUT"] &
			(wineState == 4 | wineState == 5) & 
			[[[bol BOLItem] alcoholLevel] isEqualToString:@">=14%"] &
			[[bol taxClass] isEqualToString:@"TAXPAID"] ) return 14;
		NSLog(@"Unable to resolve bol type on BOL:%4d from lot:%@",[bol bolid],[[bol inLot] lotNumber]);
		return 14;
	}
	if ([[wo theSubType] isEqualToString:@"BLENDING"]) 
	{
		if ([[wo blends] count]>0) {
			CCBlend *theBlend=[[wo blends] objectAtIndex:0];
			if ([[theBlend endState] isEqualToString:@"JUICE"])
				return 19;
			if ([[theBlend endState] isEqualToString:@"WINE_BELOW"])
				return 20;
			if ([[theBlend endState] isEqualToString:@"WINE_ABOVE"])
				return 21;
		}
		return -1;
	}
	if ([[wo theSubType] isEqualToString:@"BLEND"]) 
		return 22;
	
	if ([[wo class] isSubclassOfClass:[CCBOL class]])
	{
		NSLog(@"shouldnt get here");
	}
	float testAlc=[self isAlcoholTestWithValue:wo];
	if (testAlc > 0 & testAlc < 14) 
		return 15;
	if (testAlc >= 14) 
		return 16;
	if ([[wo theSubType] isEqualToString:@"BOTTLING"]) 
		return 17;
	if ([self changeInVolume:wo] != 0) 
		return 18;
	return -1;  // no action
}

-(void) recordTransitionBasedOnWOCode:(int)woCode withWO:(id)wo
{
	int newState=theTable[woCode][wineState];
	if (newState<0)
	{
		NSLog(@"Incompatible 702 Transition: wineState:%1d newState:%1d woCode:%2d",wineState,newState,woCode);
		return;
	}

	if (newState!=wineState & (wineState > 0 & newState < 6))
	{
		CC702Event *event=[[CC702Event alloc] initWithActivity:nil 
												 previousState:wineState
													  newState:newState
											 theStartingVolume:[[volume objectAtIndex:wineState] floatValue] 
												theChangeInVolume:0 
												 fromWorkOrder:wo];
		[[history objectAtIndex:wineState] addObject:event];
		[event release];
		CC702Event *event2=[[CC702Event alloc] initWithActivity:nil 
												  previousState:wineState
													   newState:newState
											 theStartingVolume:[[volume objectAtIndex:newState] floatValue] 
												theChangeInVolume:[[volume objectAtIndex:wineState] floatValue] 
												 fromWorkOrder:wo];
		[[history objectAtIndex:newState] addObject:event2];
		[event2 release];
		[volume replaceObjectAtIndex:newState withObject:[volume objectAtIndex:wineState]];
		[volume replaceObjectAtIndex:wineState withObject:[NSNumber numberWithFloat:0]];
	}
	if (newState==6 | newState == 7)
	{
		CC702Event *event=[[CC702Event alloc] initWithActivity:nil 
												 previousState:wineState
													  newState:newState
											 theStartingVolume:[[volume objectAtIndex:wineState] floatValue] 
												theChangeInVolume:[self changeInVolume:wo]
												 fromWorkOrder:wo];
		[[history objectAtIndex:wineState] addObject:event];
		[event release];
		CC702Event *event2=[[CC702Event alloc] initWithActivity:nil 
												  previousState:wineState
													   newState:newState
											  theStartingVolume:[[volume objectAtIndex:newState] floatValue] 
												 theChangeInVolume:-[self changeInVolume:wo]   
												  fromWorkOrder:wo];
		[[history objectAtIndex:newState] addObject:event2];
		[event2 release];
		float newStateVolume=[[volume objectAtIndex:newState] floatValue]-[self changeInVolume:wo];
		float currentStateVolume=[[volume objectAtIndex:wineState] floatValue]+[self changeInVolume:wo];
		[volume replaceObjectAtIndex:newState withObject:[NSNumber numberWithFloat:newStateVolume]];
		[volume replaceObjectAtIndex:wineState withObject:[NSNumber numberWithFloat:currentStateVolume]];
		return;
	}
	wineState=newState;
 	if ([wo inventoryAdjusted])
	{
		CC702Event *event=[[CC702Event alloc] initWithActivity:nil 
												 previousState:wineState
													  newState:newState
											 theStartingVolume:[[volume objectAtIndex:wineState] floatValue] 
												theChangeInVolume:[self changeInVolume:wo] 
												 fromWorkOrder:wo];
		[[history objectAtIndex:newState] addObject:event];
		[event release];
		if ([[wo class] isSubclassOfClass:[CCWT class]] | [[wo class] isSubclassOfClass:[CCBOL class]])
			[volume replaceObjectAtIndex:wineState 
							  withObject:[NSNumber numberWithFloat:([[volume objectAtIndex:wineState] floatValue]+[self changeInVolume:wo])]];		
		else 
			[volume replaceObjectAtIndex:wineState 
							  withObject:[NSNumber numberWithFloat:[self changeInVolume:wo]]];		
	}
}

-(id) initWithWorkOrders:(NSArray *)theWorkOrders
{	
	self=[super init];

	//  First index is type of WO, BOL or WT
	//  Second is state lot is going to transition to
			
	wineState=0;
	volume=[[NSMutableArray alloc] initWithObjects:
			[NSNumber numberWithInt:0],
			[NSNumber numberWithInt:0],
			[NSNumber numberWithInt:0],
			[NSNumber numberWithInt:0],
			[NSNumber numberWithInt:0],
			[NSNumber numberWithInt:0],
			[NSNumber numberWithInt:0],
			[NSNumber numberWithInt:0],
			nil];
	
	history = [[NSMutableArray alloc] initWithObjects:
			   [[[NSMutableArray alloc] init] autorelease],
			   [[[NSMutableArray alloc] init] autorelease],
			   [[[NSMutableArray alloc] init] autorelease],
			   [[[NSMutableArray alloc] init] autorelease],
			   [[[NSMutableArray alloc] init] autorelease],
			   [[[NSMutableArray alloc] init] autorelease],
			   [[[NSMutableArray alloc] init] autorelease],
			   [[[NSMutableArray alloc] init] autorelease],
			   nil];
		
	for (id wo in theWorkOrders ) {
		int woCode=[self getWOCodeFromWO:wo];
		if (woCode >= 0)
			[self recordTransitionBasedOnWOCode:woCode withWO:wo];
	}
	
//	for (int i=0; i<[volume count]; i++)
//	{
//		NSLog(@"Section %d has resulting volume: %5.1f",i,[[volume objectAtIndex:i] floatValue]);
//		for (CC702Event *event in [history objectAtIndex:i]) {
//			NSLog(@"     %@",[event description]);
//		}
//	}
	return self;
}

-(NSArray *)historyBetweenDate:(NSDate *)startDate andDate:(NSDate *)endDate forSection:(int)section
{
	NSMutableArray *filteredHistory=[[[NSMutableArray alloc] initWithArray:[history objectAtIndex:section]] autorelease];
    NSMutableIndexSet *removeEvents=[[NSMutableIndexSet alloc] init];
    for (int i=0;i<[filteredHistory count]; i++)
    {
        CC702Event *anEvent=[filteredHistory objectAtIndex:i];
        if (!([[(CCWorkOrder *)[anEvent workOrder] date] timeIntervalSinceDate:startDate]<0 |
            [[(CCWorkOrder *)[anEvent workOrder] date] timeIntervalSinceDate:endDate]>0)) {
            [removeEvents addIndex:i];
        }
    }
//	NSIndexSet *removeEvents=[filteredHistory indexesOfObjectsPassingTest:
//							  ^(id obj, NSUInteger idx, BOOL *stop) {
//								  CC702Event *anEvent=(CC702Event *)obj;
//								  if ([[(CCWorkOrder *)[anEvent workOrder] date] timeIntervalSinceDate:startDate]<0 |
//									  [[(CCWorkOrder *)[anEvent workOrder] date] timeIntervalSinceDate:endDate]>0) {
//									  return YES;
//								  }
//								  return NO;
//							  }];
	[filteredHistory removeObjectsAtIndexes:removeEvents];	
    [removeEvents release];
	return filteredHistory;
}

-(float) startingVolumeForDate:(NSDate *)theDate forSection:(int)section
{
	NSMutableArray *filteredHistory=[[[NSMutableArray alloc] initWithArray:[history objectAtIndex:section]] autorelease];
    NSMutableIndexSet *removeEvents=[[NSMutableIndexSet alloc] init];
    for (int i=0; i<[filteredHistory count]; i++)
    {
        CC702Event *anEvent=[filteredHistory objectAtIndex:i];
        if (!([[(CCWorkOrder *)[anEvent workOrder] date] timeIntervalSinceDate:theDate]>0))
            [removeEvents addIndex:i];
    }
      
//	NSIndexSet *removeEvents=[filteredHistory indexesOfObjectsPassingTest:
//							  ^(id obj, NSUInteger idx, BOOL *stop) {
//								  CC702Event *anEvent=(CC702Event *)obj;
//								  if ([[(CCWorkOrder *)[anEvent workOrder] date] timeIntervalSinceDate:theDate]>0)
//									  return YES;
//								  else
//									  return NO;
//							  }];
	[filteredHistory removeObjectsAtIndexes:removeEvents];	
    [removeEvents release];
	if ([filteredHistory count]>0)
		return [[filteredHistory lastObject] endingVolume];
	else 
		return 0;
}

-(int) inSectionOnDate:(NSDate *)theDate
{
	int endingState=0;
	NSMutableArray *allHistories=[[NSMutableArray alloc] init];
	for (int i=0; i<=7; i++) {
		[allHistories addObjectsFromArray:[history objectAtIndex:i]];
	}
/*	[allHistories sortUsingComparator:^(id left, id right)
		 {
			 NSComparisonResult result;
			 CC702Event *anEventLeft=(CC702Event *)left;
			 CC702Event *anEventRight=(CC702Event *)right;
			 if ([[(CCWorkOrder *)[anEventLeft workOrder] date] timeIntervalSinceDate:[(CCWorkOrder *)[anEventRight workOrder] date]]<0)
				 result=NSOrderedAscending;
			 else if ([[(CCWorkOrder *)[anEventLeft workOrder] date] timeIntervalSinceDate:[(CCWorkOrder *)[anEventRight workOrder] date]]==0)
				 result=NSOrderedSame;
			 else
				 result=NSOrderedDescending;
			 return result;
		 }];
*/
	for (CC702Event *theHistory in allHistories)
	{
		if ([[[theHistory workOrder] date] timeIntervalSinceDate:theDate]<=0) {
			endingState=[theHistory newState];
		}
	}
	[allHistories release];
	return endingState;
}

-(NSString *)sectionNameFromNumber:(int)number
{
	switch (number) {
		case 0:
			return @"Empty";
			break;
		case 1:
			return @"Juice";
			break;
		case 2:
			return @"Wine Below";
			break;
		case 3:
			return @"Wine Above";
			break;
		case 4:
			return @"Bottled Below";
			break;
		case 5:
			return @"Bottled Above";
			break;
		case 6:
			return @"Out Bond to Bond";
			break;
		case 7:
			return @"Out Tax Paid";
			break;
		default:
			break;
	}
	return @"";
}

-(void) dealloc
{
	[volume release];
	[history release];
	[super dealloc];
}
@end
