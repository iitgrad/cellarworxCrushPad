//
//  CCActivity.m
//  Crush
//
//  Created by Kevin McQuown on 6/28/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCActivity.h"
#import "CrushHelper.h"
#import "cellarworxAppDelegate.h"
#import "CCLot.h"
#import "CCWineStructure.h"

@implementation CCActivity
@synthesize derivedVolume;
@synthesize derivedTankGallons;
@synthesize derivedBarrelCount;
@synthesize derivedToppingGallons;
@synthesize inventoryAdjusted;
@synthesize cost;
@synthesize startingCost;
@synthesize endingCost;
@synthesize inLot;
@synthesize date;
@synthesize lot;
@synthesize costBreakOut;
@synthesize endingWineState;
@synthesize client;
@synthesize structure;

-(id)initWithLot:(CCLot *)theLot
{
	self=[super init];
	derivedTankGallons=0;
	derivedToppingGallons=0;
	derivedBarrelCount=0;
	derivedVolume=0;
	client=[[CCClient alloc] initWithNSUserDefaults];
	cost=0;
	startingCost=0;
	endingCost=0;
	self.dbid=-1;
	self.date=[NSDate date];
	inLot=theLot;
	self.lot=[theLot lotNumber];
	if ([theLot.workOrders count]>0) {
		costBreakOut=[[[theLot.workOrders lastObject] costBreakOut] mutableCopy];
		structure=[[CCWineStructure alloc] initWithWineStructure:[(CCActivity *)[theLot.workOrders lastObject] structure]];
		startingCost=[[theLot.workOrders lastObject] endingCost];
		endingCost=startingCost;
		self.endingWineState=[[theLot.workOrders lastObject] endingWineState];
	}
	return self;
}
-(id)initWithDictionary:(NSDictionary *)dictionary withLot:(CCLot *)theLot
{
	self=[super init];

	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	derivedTankGallons=0;
	derivedToppingGallons=0;
	derivedBarrelCount=0;
	derivedVolume=0;

	client=[[CCClient alloc] initWithDictionary:[dictionary objectForKey:@"data"]];
	costBreakOut=[[NSMutableDictionary alloc] init];
	cost=[[CrushHelper nillIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"COST"]] floatValue];
	startingCost=[[CrushHelper nillIfNull:[dictionary objectForKey:@"starting_cost"]] floatValue];
	endingCost=[[CrushHelper nillIfNull:[dictionary objectForKey:@"ending_cost"]]  floatValue];
	self.endingWineState=[dictionary objectForKey:@"end_state"];
	NSDictionary *costBreakOutDictionary=[CrushHelper nillIfNull:[dictionary objectForKey:@"cost_data"]];
	if (costBreakOutDictionary != nil)
	{
		[costBreakOut addEntriesFromDictionary:costBreakOutDictionary];
	}
	NSString *theDate=[CrushHelper nillIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"DUEDATE"]];
	if (theDate != nil)
		self.date=[[CrushHelper dateAndTimeFormatSQLStyle] dateFromString:theDate];
	else 
		self.date=nil;
	
	lot=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"LOT"]]];
	if (theLot==nil)
//		inLot=[[ap defaultVintage] getLotByNumber:lot];
		inLot=[[ap getVintageForClient:self.client andYear:[CCLot getVintageYearFromLotNumber:lot]] getLotByNumber:lot];
	else 
		inLot=theLot;
	
	if (![[NSNull null] isEqual:[dictionary objectForKey:@"structure"]]) {
		structure=[[CCWineStructure alloc] initWithDictionary:[dictionary objectForKey:@"structure"]];
	}	
	
	return self;
}

-(void)setDerivedTankGallons:(float) val
{
	derivedTankGallons=val;
	derivedVolume=derivedTankGallons+derivedToppingGallons+(derivedBarrelCount*60);
}
-(void)setDerivedToppingGallons:(float) val
{
	derivedToppingGallons=val;
	derivedVolume=derivedTankGallons+derivedToppingGallons+(derivedBarrelCount*60);
}
-(void)setDerivedBarrelCount:(int) val
{
	derivedBarrelCount=val;
	derivedVolume=derivedTankGallons+derivedToppingGallons+(derivedBarrelCount*60);
}
-(CCLot *)inLot
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (inLot==nil) {
		inLot=[[ap getVintageForClient:self.client andYear:[CCLot getVintageYearFromLotNumber:inLot.lotNumber]] getLotByNumber:lot];
	}
	return inLot;
}
-(void) dealloc
{
	[structure release];
	[client release];
	[endingWineState release];
	[costBreakOut release];
	[lot release];
	[date release];
	[super dealloc];
}
@end
