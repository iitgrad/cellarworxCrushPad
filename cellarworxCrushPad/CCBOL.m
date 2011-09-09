//
//  CCBOL.m
//  Crush
//
//  Created by Kevin McQuown on 6/25/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCBOL.h"
#import "CCBOLItem.h"
#import "CCLot.h"
#import "CrushHelper.h"
#import "cellarworxAppDelegate.h"

@implementation CCBOL

@synthesize bolid;
@synthesize taxClass;
@synthesize direction;
@synthesize facility;
@synthesize carrier;
@synthesize BOLItem;
@synthesize bolItems;
@synthesize clientCode;

-(NSString *) description
{
	return [NSString stringWithFormat:@"BOL - %d",self.bolid];
}

-(float) changeInVolume:(CCLot *)theLot
{
	float gallons=0;
	if ([self.direction isEqualToString:@"IN"])
	{
		for (CCBOLItem *item in self.bolItems)
		{
			if (theLot==item.lot)
				gallons+=[item gallons];
		}
	}
	else
	{
		for (CCBOLItem *item in self.bolItems)
		{
			if (theLot==item.lot)
				gallons-=[item gallons];
		}
	}
	return gallons;
}

-(id) initWithDictionary:(NSDictionary *)dictionary withLot:(CCLot *)parentLot;
{
	self=[super initWithDictionary:dictionary withLot:parentLot];
	
    NSDictionary *data=[dictionary objectForKey:@"data"];
    self.date=[[CrushHelper dateFormatSQLStyle] dateFromString:[CrushHelper nillIfNull:[data objectForKey:@"DATE"]]];
    self.taxClass=[data objectForKey:@"BONDED"];
    self.clientCode=[data objectForKey:@"CLIENTCODE"];
    self.direction=[data objectForKey:@"DIRECTION"];
    self.carrier=[CrushHelper nillIfNull:[data objectForKey:@"CARRIER"]];
    bolid=[[data objectForKey:@"BOLID"] intValue];
    facility=[[CCFacility alloc] initWithDictionary:data];
	
	NSArray *bolItemDictionaries=[data objectForKey:@"bolItems"];
	bolItems=[[NSMutableArray alloc] init];
	for (NSDictionary *dict in bolItemDictionaries)
	{
		CCBOLItem *item=[[CCBOLItem alloc] initWithDictionary:dict forBOL:self];
		[bolItems addObject:item];
		[item release];
	}
	self.inventoryAdjusted=YES;
    return self;
}
-(id) initWithClient:(CCClient *)theClient
{
	self=[super init];
	self.date=[NSDate date];
	self.bolid=-1;
	self.taxClass=@"BONDTOBOND";
	self.client=theClient;
	self.direction=@"OUT";
	self.carrier=nil;
	bolItems=[[NSMutableArray alloc] init];
	self.inventoryAdjusted=YES;
	return self;
}

-(void)refresh
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	for (int i=0; i<[self.bolItems count];i++)
	{
		CCDatabaseObject *item=(CCDatabaseObject *)[self.bolItems objectAtIndex:i];
		CCDatabaseObject *newItem=[ap getDBObjectWithItem:item];
		if (newItem==nil)
			[self.bolItems removeObjectAtIndex:i];
		else 
			[self.bolItems replaceObjectAtIndex:i withObject:newItem];
	}
}

-(NSDictionary *)saveDictionary
{
	NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
						 [NSNumber numberWithInt:self.bolid],@"ID",
						 [[CrushHelper dateFormatSQL] stringFromDate:self.date],@"DATE",
						 self.direction,@"DIRECTION",
						 self.taxClass,@"BONDED",
						 self.client.clientCode,@"CLIENTCODE",
						 [NSNumber numberWithInt:self.facility.dbid],@"FACILITYID",
						 [NSNumber numberWithFloat:self.cost],@"COST",
						 nil] autorelease];
	return dict;
}
-(NSString *)save
{	
	NSDictionary *dict=[self saveDictionary];
	
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"update_bol"];
	NSLog(@"%@",[result description]);
	self.bolid=[[CrushHelper nillIfNull:[result objectForKey:@"ID"]] intValue];  //json returns nsdecimalnumber which needs to be converted to nsstring
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"workOrderSaved" object:self];
	
	return [CrushHelper nillIfNull:[result objectForKey:@"ID"]];
}
-(void)delete
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (self.dbid>=0)
	{
		NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
							 [NSNumber numberWithInt:self.bolid],@"ID",
							 nil]autorelease];
		NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"delete_bol"];
		NSLog(@"%@",[result description]);		
	}
	[ap deleteDBItem:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"workOrderSaved" object:self];
}

-(void) dealloc
{
	[clientCode release];
	[bolItems release];
	[BOLItem release];
    [taxClass release];
    [direction release];
    [facility release];
    [carrier release];
    [super dealloc];
}
@end
