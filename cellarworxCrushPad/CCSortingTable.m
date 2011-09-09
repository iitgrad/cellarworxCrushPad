//
//  CCSortingTable.m
//  Crush
//
//  Created by Kevin McQuown on 7/19/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCSortingTable.h"
#import "CCSortingTableActivity.h"
#import "CCSCP.h"
#import "CrushHelper.h"
#import "CCSCP.h"
#import "cellarworxAppDelegate.h"
#include <dispatch/dispatch.h>
#import <math.h>

#define kSecondsForLineChangeOver 600

@implementation CCSortingTable
@synthesize activities;

#pragma mark -
#pragma mark Initialization methods

-(id) init
{
	self=[super init];
	activities=[[NSMutableArray alloc] init];
	serverContacted=NO;
	refreshInProgress=[[NSLock alloc] init];
	return self;
}

-(void) initFromServerWithRefresh:(BOOL)refresh
{
	if ([refreshInProgress tryLock])
	{
		if (!serverContacted | refresh) {
			serverContacted=YES;
			NSDictionary *theDictionary=[CrushHelper fetchSortingTableActivities];
			NSArray *request=[theDictionary objectForKey:@"result"];
			[activities removeAllObjects];
			for (NSDictionary *anActivity in request)
			{
				CCSortingTableActivity *aSortingActivity=[[CCSortingTableActivity alloc] initWithDictionary:anActivity];
				[activities addObject:aSortingActivity];
				[aSortingActivity release];
			}
			[CrushHelper setBadges:[theDictionary objectForKey:@"badges"]];
		}
		[refreshInProgress unlock];
	}
}

-(void) refreshLotLinks
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	for (CCSortingTableActivity *activity in activities)
	{
		activity.scp.inLot=[[ap defaultVintage] getLotByNumber:activity.scp.lot];
	}
}

#pragma mark -
#pragma mark Sequence and time methods
-(void) generateSequenceNumbers
{
	for (int i=0; i<[activities count]; i++)
	{
		[(CCSortingTableActivity *)[activities objectAtIndex:i] setSequenceNumber:i];
	}
}

-(void) calculateTableSchedule
{
	[self generateSequenceNumbers];
	
	NSString *currentClientCode=nil;
	NSDate *theTime;
	if ([[activities objectAtIndex:0] onTable])
		theTime=[[activities objectAtIndex:0] fixedStartTime];
	else 
		theTime=[NSDate date];
	int seconds=0;
	int lateSeconds=0;
	for (CCSortingTableActivity *activity in activities)
	{
		[activity setEstimatedTimeOnTable:[theTime dateByAddingTimeInterval:seconds+lateSeconds]];
		float tons=[[activity scp] actualTons];
		float tph=[[activity scp] processingSpeed];
		seconds+=(tons/tph)*60*60;
		if (currentClientCode!=nil)
		{
			if (![currentClientCode isEqualToString:[[activity scp] clientcode]]) {
				seconds+=kSecondsForLineChangeOver;
			}
		}
		else {
			currentClientCode=[[activity scp] clientcode];
		}
		int theLateSeconds=[[theTime dateByAddingTimeInterval:seconds] timeIntervalSinceDate:[NSDate date]];
		if (theLateSeconds<=0)
			theLateSeconds=-theLateSeconds;
		else 
			theLateSeconds=0;
		lateSeconds=MAX(lateSeconds, theLateSeconds);
	}
}

#pragma mark -
#pragma mark Activity operations

-(void) addActivity:(CCSortingTableActivity *)theActivity
{
	if (!serverContacted)
	{
		[self initFromServerWithRefresh:NO];
		serverContacted=YES;
	}
	[activities addObject:theActivity];
	[self calculateTableSchedule];
	[(CCSortingTableActivity *)[activities lastObject] saveWithPushNotification:YES];
}

-(void) removeActivity:(CCSortingTableActivity *)theActivity
{
	[theActivity deleteWithPushNotification:YES];
	[activities removeObject:theActivity];
}

-(void) saveAllActivities
{
	for (CCSortingTableActivity *a in activities)
	{
		NSLog(@"from dispatch");
		NSLog(@"%d",[a sequenceNumber]);
	}
	for (CCSortingTableActivity *theActivity in activities)
	{
		if ([activities lastObject]==theActivity) 
			[theActivity saveWithPushNotification:YES];
		else 
			[theActivity saveWithPushNotification:NO];
	}
}

-(void) moveRow:(int)sourceRow toRow:(int)destinationRow
{
	CCActivity *tempActivity=[[activities objectAtIndex:sourceRow] retain];
	[activities removeObjectAtIndex:sourceRow];
	[activities insertObject:tempActivity atIndex:destinationRow];
	[tempActivity release];
	[self generateSequenceNumbers];
	for (CCSortingTableActivity *a in activities)
	{
		NSLog(@"%d",[a sequenceNumber]);
	}
	[self saveAllActivities];
}

-(void) startedTopMostActivity
{
	[[activities objectAtIndex:0] setOnTable:YES];
	[[activities objectAtIndex:0] setFixedStartTime:[NSDate date]];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[[activities objectAtIndex:0] saveWithPushNotification:YES];
	});
	[self calculateTableSchedule];
}

-(void) completeTopMostActivity
{
	[[activities objectAtIndex:0] completeWithPushNotification:YES];
	[activities removeObjectAtIndex:0];
}
-(BOOL) hasSCP:(CCSCP *)theSCP
{
	for (CCSortingTableActivity *activity in self.activities)
	{
		if (activity.scp.dbid==theSCP.dbid)
		{
			return YES;
		}
	}
	return NO;
}

-(void) deleteActivityForSCP:(CCSCP *)theSCP
{
	CCSortingTableActivity *theActivity=nil;
	for (CCSortingTableActivity *activity in activities)
	{
		if (activity.scp.dbid==theSCP.dbid) {
			theActivity=activity;
		}
	}
	if (theActivity!=nil)
	{
		[self removeActivity:theActivity];
	}
}
#pragma mark -
#pragma mark memory management

-(void)dealloc
{
	[activities release];
	[super dealloc];
}
@end
