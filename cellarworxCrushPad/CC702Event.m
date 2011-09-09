//
//  CC702Event.m
//  Crush
//
//  Created by Kevin McQuown on 6/24/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CC702Event.h"
#import "CCWT.h"
#import "CCBOL.h"
#import "CCWorkOrder.h"
#import "CrushHelper.h"
#import "CCLot.h"

@implementation CC702Event
@synthesize activity, startingVolume, changeInVolume, endingVolume, previousState, newState, workOrder;

-(id) initWithActivity:(NSString *)theActivity
		 previousState:(int)ps 
			  newState:(int)ns
	 theStartingVolume:(float)sv  
	 theChangeInVolume:(float)cv 
		 fromWorkOrder:(CCWorkOrder *)wo
{
	self=[super init];
	
	previousState=ps;
	newState=ns;
	startingVolume=sv;
	if ([[wo class] isSubclassOfClass:[CCWorkOrder class]])
	{
		changeInVolume=cv-sv;
		endingVolume=cv;
	}
	else
	{
		changeInVolume=cv;
		endingVolume=sv+cv;		
	}
	activity=theActivity;
	workOrder=wo;
	
	
	return self;
}

- (NSString *) description
{
	if ([[workOrder class] isSubclassOfClass:[CCWT class]])
		return [NSString stringWithFormat:@"%@ %@ prevState:%2d sv:%5.1f cv:%5.1f ev:%5.1f newState:%2d %@:%5d",[[CrushHelper dateFormatShortStyle] stringFromDate:[(CCWT *)workOrder date]],
				@"WT",
				previousState,
				startingVolume,
				changeInVolume,
				endingVolume,
				newState,
				[[(CCWT *)workOrder inLot] lotNumber],
				[(CCWT *)workOrder tagID]];
	if ([[workOrder class] isSubclassOfClass:[CCBOL class]])	
		return [NSString stringWithFormat:@"%@ %@ prevState:%2d sv:%5.1f cv:%5.1f ev:%5.1f newState:%2d %@:%2d",[[CrushHelper dateFormatShortStyle] stringFromDate:[(CCBOL *)workOrder date]],
				@"BOL",
				previousState,
				startingVolume,
				changeInVolume,
				endingVolume,
				newState,
				[[(CCBOL *)workOrder inLot] lotNumber],
				[(CCBOL *)workOrder bolid]];
	
	return [NSString stringWithFormat:@"%@ %@ prevState:%2d sv:%5.1f cv:%5.1f ev:%5.1f newState:%2d %@:%@",[[CrushHelper dateFormatShortStyle] stringFromDate:[(CCWorkOrder *)workOrder date]],
			[(CCWorkOrder *)workOrder theSubType],
			previousState,
			startingVolume,
			changeInVolume,
			endingVolume,
			newState,
			[[(CCWorkOrder *)workOrder inLot] lotNumber],
			[(CCWorkOrder *)workOrder theID]];
	
}
@end
