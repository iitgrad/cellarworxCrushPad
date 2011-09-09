//
//  sortingTable.m
//  Crush
//
//  Created by Kevin McQuown on 7/19/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCSortingTableActivity.h"
#import "CCSCP.h"
#import "CrushHelper.h"

@implementation CCSortingTableActivity
@synthesize dbid;
@synthesize scp;
@synthesize weighTags;
@synthesize estimatedTimeOnTable;
@synthesize fixedStartTime;
@synthesize day;
@synthesize sequenceNumber;
@synthesize onTable;
@synthesize completed;

-(id) initWithSCP:(CCSCP *)theSCP onDay:(NSDate *)theDate
{
	self=[super init];
	weighTags=[[NSMutableArray alloc] init];
	self.scp=theSCP;
	self.day=theDate;
	fixedStartTime=nil;
	estimatedTimeOnTable=nil;
	sequenceNumber=-1;
	onTable=NO;
	completed=NO;
	dbid=-1;
	return self;
}

-(id) initWithDictionary:(NSDictionary *)dict
{
	CCSCP *anSCP=[[[CCSCP alloc] initWithDictionary:[dict objectForKey:@"scp"] withLot:nil] autorelease];
	self=[[CCSortingTableActivity alloc] initWithSCP:anSCP onDay:[NSDate date]];
	NSDictionary *theData=[dict objectForKey:@"data"];
	self.dbid=[[theData objectForKey:@"dbid"] intValue];
	if ([[theData objectForKey:@"onTable"] isEqualToString:@"YES"])
		self.onTable=YES;
	self.day=[[CrushHelper dateFormatSQL] dateFromString:[theData objectForKey:@"day"]];
	self.sequenceNumber=[[theData objectForKey:@"sequenceNumber"] intValue];
	self.fixedStartTime=[[CrushHelper dateAndTimeFormatSQLStyle] dateFromString:[theData objectForKey:@"fixedStartTime"]];
	return self;
}

-(void) completeWithPushNotification:(BOOL)sendPushNotification
{
    NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
						 [NSString stringWithFormat:@"%d",self.dbid],@"dbid",
						 [CrushHelper devToken],@"devToken",
						 @"YES",@"sendPushNotification",
						 nil] autorelease];
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"complete_sortingTableActivity"];
	NSLog(@"%@",[result description]);
	self.dbid=[[result objectForKey:@"dbid"] intValue];
	[CrushHelper setBadges:[result objectForKey:@"badges"]];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"sortingTableActivityDeleted" object:self];	
}

-(void) deleteWithPushNotification:(BOOL)sendPushNotification
{
    NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
						 [NSString stringWithFormat:@"%d",self.dbid],@"dbid",
						 [CrushHelper devToken],@"devToken",
						 @"YES",@"sendPushNotification",
						 nil] autorelease];
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"delete_sortingTableActivity"];
	NSLog(@"%@",[result description]);
	self.dbid=[[result objectForKey:@"dbid"] intValue];
	[CrushHelper setBadges:[result objectForKey:@"badges"]];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"sortingTableActivityDeleted" object:self];	
}

-(void) saveWithPushNotification:(BOOL)sendPushNotification
{
	NSMutableString *fixedST=[NSMutableString stringWithFormat:@"%@",@""];
	if (fixedStartTime!=nil) {
		[fixedST appendString:[[CrushHelper dateAndTimeFormatSQLStyle] stringFromDate:self.fixedStartTime]];
	}
    NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
						 [NSString stringWithFormat:@"%d",self.dbid],@"dbid",
                         [NSNumber numberWithInt:scp.dbid],@"scp",
                         fixedST,@"fixedStartTime",
                         [[CrushHelper dateFormatSQL] stringFromDate:self.day],@"day",
						 [[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[NSNumber numberWithInt:self.sequenceNumber]],@"sequenceNumber",
						 [CrushHelper yesNoFromBOOL:self.onTable],@"onTable",
						 [CrushHelper yesNoFromBOOL:self.completed],@"completed",
						 [CrushHelper devToken],@"devToken",
						 [CrushHelper yesNoFromBOOL:sendPushNotification],@"sendPushNotification",
						 nil] autorelease];
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"update_sortingTableActivities"];
	NSLog(@"%@",[result description]);
	self.dbid=[[result objectForKey:@"dbid"] intValue];
	self.sequenceNumber=[[result objectForKey:@"sequenceNumber"] intValue];
	[CrushHelper setBadges:[result objectForKey:@"badges"]];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"sortingTableActivitiesSaved" object:self];
}

-(void) dealloc
{
	[weighTags release];
	[scp release];
	[estimatedTimeOnTable release];
	[fixedStartTime release];
	[day release];
	[super dealloc];
}

@end
