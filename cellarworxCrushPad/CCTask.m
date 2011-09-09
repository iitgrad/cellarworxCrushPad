//
//  CCTask.m
//  Crush
//
//  Created by Kevin McQuown on 7/2/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCTask.h"
#import "CCWorkOrder.h"
#import "cellarworxAppDelegate.h"
#import "CrushHelper.h"

@implementation CCTask
@synthesize workOrders;
@synthesize dbid;
@synthesize type;
@synthesize startDate;
@synthesize endDate;
@synthesize workPerfomedBy;

-(id)  initWithWorkOrder:(CCWorkOrder *)theWorkOrder
{
//	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	self=[super init];
	workOrders=[[NSMutableSet alloc] init];
	dbid=-1;
	self.type=theWorkOrder.theSubType;
	self.startDate=theWorkOrder.date;
	self.endDate=theWorkOrder.date;
	self.workPerfomedBy=theWorkOrder.workPerformedBy;
	[workOrders addObject:theWorkOrder];
	return self;
}

- (id) initWithDictionary:(NSDictionary *)dict
{
	self=[super init];
	workOrders=[[NSMutableSet alloc] init];
	self.dbid=[[dict objectForKey:@"id"] intValue];
	self.type=[CrushHelper blankIfNull:[dict objectForKey:@"type"]];
	self.workPerfomedBy=[CrushHelper blankIfNull:[dict objectForKey:@"workperformedby"]];
	NSString *startDateString=[CrushHelper blankIfNull:[dict objectForKey:@"startDate"]];
	self.startDate=[[CrushHelper dateFormatSQL] dateFromString:startDateString];
	self.endDate=[[CrushHelper dateFormatSQL] dateFromString:startDateString];	
	return self;
}

-(NSArray *)vintages
{
	NSMutableDictionary *list=[[[NSMutableDictionary alloc] init] autorelease];
	
	for (CCWorkOrder *wo in workOrders)
	{
		NSString *newVintage=[NSString stringWithFormat:@"20%@",[wo.lot substringWithRange:NSMakeRange(0, 2)]];
		[list setObject:[NSNull null] forKey:newVintage];
	}

	return [list allKeys];
}
-(NSArray *)unLoadedVintages
{
	NSMutableDictionary *list=[[[NSMutableDictionary alloc] init] autorelease];
	for (CCWorkOrder *wo in workOrders)
	{
		if (wo.inLot==nil)
		{
			NSString *newVintage=[NSString stringWithFormat:@"20%@",[wo.lot substringWithRange:NSMakeRange(0, 2)]];
			[list setObject:[NSNull null] forKey:newVintage];			
		}
	}
	return [list allKeys];
}

-(NSDictionary *)saveDictionary
{
	
	NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
						 [NSString stringWithFormat:@"%d",self.dbid],@"id",
						 self.type,@"type",
						 nil] autorelease];
	return dict;
}
-(void)save
{	
//	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSDictionary *dict=[self saveDictionary];
	
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"update_task"];
	NSLog(@"%@",[result description]);
	self.dbid=[[result objectForKey:@"id"] intValue];  //json returns nsdecimalnumber which needs to be converted to nsstring		
}
-(void)delete
{	
	//	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSDictionary *dict=[self saveDictionary];
	
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"delete_task"];
	NSLog(@"%@",[result description]);
	self.dbid=[[result objectForKey:@"id"] intValue];  //json returns nsdecimalnumber which needs to be converted to nsstring		
}

- (void) dealloc
{
	[startDate release];
	[endDate release];
	[workPerfomedBy release];
	[type release];
	[workOrders release];
	[super dealloc];
}
@end
