//
//  CCLot.m
//  Crush
//
//  Created by Kevin McQuown on 6/17/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCLot.h"
#import "CCWorkOrder.h"
#import "CCSCP.h"
#import "CCWT.h"
#import "CCLabTest.h"
#import "CrushHelper.h"
#import "CCVintage.h"
#import "CCBlend.h"
#import "CCStructure.h"
#import "CCBOL.h"
#import "CC702.h"
#import "CCSortingTable.h"
#import "cellarworxAppDelegate.h"

@implementation CCLot
@synthesize workOrders;
@synthesize description;
@synthesize lotNumber;
@synthesize vintage;
@synthesize retrieved;
@synthesize favorite;
@synthesize structure;
@synthesize dbid;
@synthesize organic;
@synthesize the702View;
@synthesize active;
@synthesize needsReload;

-(id)initWithVintage:(CCVintage *)forVintage
{
	self.workOrders=[[NSMutableArray alloc] init];
	self.description=@"";
	self.vintage=forVintage;
	self.dbid=@"NEW";
	retrieved=NO;
	active=YES;
	organic=NO;
	favorite=YES;
	self.lotNumber=@"NEW LOT";
	[self.vintage.lots addObject:self];
	self.retrieved=YES;
	self.needsReload=NO;
	return self;
}

-(id)initWithLotNumber:(NSString *)lotnumber
{
	self=[super init];
	workOrders=[[NSMutableArray alloc] init];
	lotNumber=[[NSString alloc] initWithString:lotnumber];
	description=nil;
	dbid=nil;
	retrieved=NO;
	active=NO;
	organic=NO;
	favorite=YES;
	structure=nil;
	the702View=nil;
	needsReload=NO;
	
	return self;
}

+(NSInteger) getVintageYearFromLotNumber:(NSString *)theLotNumber
{
	if ([theLotNumber length]>0) {
		NSInteger year=[[theLotNumber substringWithRange:NSMakeRange(0, 2)] intValue]+2000;
		return year;
	}
	return -1;
}

-(void)updateAllWorkOrdersWithDictionary:(NSDictionary *)dictionary
{
	for (NSDictionary *dict in [dictionary objectForKey:@"workorders"])
	{
		if ([[[dict objectForKey:@"data"] objectForKey:@"TYPE"]isEqualToString:@"SCP"])
			[workOrders addObject:[[[CCSCP alloc] initWithDictionary:dict withLot:self] autorelease]];
		else if ([[dict objectForKey:@"type"] isEqualToString:@"WT"])
			[workOrders addObject:[[[CCWT alloc] initWithDictionary:dict withLot:self] autorelease]];
		else if ([[dict objectForKey:@"type"] isEqualToString:@"BOL"])
			[workOrders addObject:[[[CCBOL alloc] initWithDictionary:dict withLot:self] autorelease]];
//		else if ([[[dict objectForKey:@"data"] objectForKey:@"TYPE"] isEqualToString:@"BOTTLING"])
//			[workOrders addObject:[[[CCBottlingWorkOrder alloc] initWithDictionary:dict withLot:self] autorelease]];
		else	
			[workOrders addObject:[[[CCWorkOrder alloc] initWithDictionary:dict withLot:self] autorelease]];
	}		
}

-(id)initWithDictionary:(NSDictionary *)dictionary forVintage:(CCVintage *)theVintage;
{
	self=[super init];
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];

	NSDictionary *lotInfo=[dictionary objectForKey:@"lotinfo"];
	lotNumber=[[NSString alloc] initWithString:[lotInfo objectForKey:@"LOTNUMBER"]];
	description=[[NSString alloc] initWithString:[lotInfo objectForKey:@"DESCRIPTION"]];
	dbid=[[NSString alloc] initWithString:[lotInfo objectForKey:@"ID"]];
    
	if ([[lotInfo objectForKey:@"ORGANIC"] isEqualToString:@"YES"])
		organic=YES;
	else 
		organic=NO;
    if ([[lotInfo objectForKey:@"FAVORITE"] isEqualToString:@"YES"])
		favorite=YES;
	else 
		favorite=NO;
	if ([[lotInfo objectForKey:@"ACTIVELOT"] isEqualToString:@"YES"])
		active=YES;
	else 
		active=NO;
    
	vintage=theVintage;
	structure=[[CCStructure alloc] init];

	[[ap defaultVintage] addLot:self];
	
	[self updateAllWorkOrdersWithDictionary:dictionary];
//	for (NSDictionary *dict in [dictionary objectForKey:@"workorders"])
//	{
//		if ([[[dict objectForKey:@"data"] objectForKey:@"TYPE"]isEqualToString:@"SCP"])
//			[workOrders addObject:[[[CCSCP alloc] initWithDictionary:dict withLot:self] autorelease]];
//		else if ([[dict objectForKey:@"type"] isEqualToString:@"WT"])
//			[workOrders addObject:[[[CCWT alloc] initWithDictionary:dict withLot:self] autorelease]];
//		else if ([[dict objectForKey:@"type"] isEqualToString:@"BOL"])
//			[workOrders addObject:[[[CCBOL alloc] initWithDictionary:dict withLot:self] autorelease]];
//		else if ([[[dict objectForKey:@"data"] objectForKey:@"type"] isEqualToString:@"BOTTLING"])
//			[workOrders addObject:[[[CCBottlingWorkOrder alloc] initWithDictionary:dict withLot:self] autorelease]];
//		else	
//			[workOrders addObject:[[[CCWorkOrder alloc] initWithDictionary:dict withLot:self] autorelease]];
//	}
	needsReload=NO;
	[self reSort];
	return self;
}

-(NSInteger) getLotNumber
{
	NSArray *theComponents=[self.lotNumber componentsSeparatedByString:@"-"];
	return [[theComponents objectAtIndex:2] intValue];
}

-(void) calculateCosts
{
	float cost=0;
	
	for (int i=0;i<[self.workOrders count];i++)
	{
		id wo=[self.workOrders objectAtIndex:i];
		if ([[wo class] isSubclassOfClass:[CCWT class]])
		{
			cost+=[wo cost];
		}
		else if ([[wo class] isSubclassOfClass:[CCBOL class]])
		{
			cost+=[wo cost];
		}
		else if ([[wo theSubType] isEqualToString:@"BLEND"]) {
			for (CCBlend *aBlend in [wo blends])
			{
//				if ([[aBlend direction] isEqualToString:@"IN FROM"])
//					tankGallons+=aBlend.gallons;
//				else 
					cost-=aBlend.gallons/[wo derivedVolume]*cost;
				[wo setEndingCost:cost];
			}
		}
		else {
			cost+=[wo cost];
		}
		[wo setEndingCost:cost];
	}
}

#pragma mark -
#pragma mark volume functions
-(void) calculateVolumes
{
	float tankGallons=0;
	float toppingGallons=0;
	float barrelCount=0;
	
	for (id wo in self.workOrders)
	{
		if ([[wo class] isSubclassOfClass:[CCWT class]])
		{
			tankGallons+=(([wo totalNetWeight] / 2000.0)*155);
			[wo setDerivedTankGallons:[wo derivedTankGallons]+tankGallons];
		}
		else if ([[wo class] isSubclassOfClass:[CCBOL class]])
		{
			float changeInVolume=[(CCBOL *)wo changeInVolume:self];
			tankGallons+=changeInVolume;
			[wo setDerivedTankGallons:[wo derivedTankGallons]+tankGallons];
		}
		else if ([[wo theSubType] isEqualToString:@"BLENDING"])
		{
			for (CCBlend *aBlend in [wo blends])
			{
				if ([[aBlend direction] isEqualToString:@"IN FROM"])
					tankGallons+=aBlend.gallons;
				else 
					tankGallons-=aBlend.gallons;
				[wo setDerivedTankGallons:[wo derivedTankGallons]+tankGallons];
			}
		}
		else if ([[wo theType] isEqualToString:@"BLEND"])
		{
			for (CCBlend *aBlend in [wo blends])
			{
				if ([[aBlend direction] isEqualToString:@"OUT TO"])
					tankGallons+=aBlend.gallons;
				else 
					tankGallons-=aBlend.gallons;
			}
			[wo setDerivedTankGallons:[wo derivedTankGallons]+tankGallons];
		}
		else {
			if ([wo inventoryAdjusted])
			{
				tankGallons=[wo endingTankGallons];
				toppingGallons=[wo endingToppingGallons];
				barrelCount=[wo endingBarrelCount];
			}
		}
		[(CCWorkOrder *)wo setDerivedTankGallons:tankGallons];
		[(CCWorkOrder *)wo setDerivedToppingGallons:toppingGallons];
		[(CCWorkOrder *)wo setDerivedBarrelCount:barrelCount];
				
		tankGallons=[wo derivedTankGallons];
		toppingGallons=[wo derivedToppingGallons];
		barrelCount=[wo derivedBarrelCount];
	}
}

-(float) gallonsUpToDate:(NSDate *)theDate
{
	for (int i=0; i<[workOrders count]; i++) {
//		int interval=[theDate timeIntervalSinceDate:[[workOrders objectAtIndex:i] date]];
//		NSDate *otherDate=[[workOrders objectAtIndex:i] date];
		if ([theDate timeIntervalSinceDate:[[workOrders objectAtIndex:i] date]]<=0) {
			if (i>0)
				return [[workOrders objectAtIndex:i-1] derivedVolume];
			else 
				return 0;
		}
	}
	return [[workOrders lastObject] derivedVolume];
}
//-(float) costsUpToDate:(NSDate *)theDate
//{
//	float cost=0;
//	for (int i=0;i<[self.workOrders count];i++)
//	{
//		id wo=[self.workOrders objectAtIndex:i];
//		if ([theDate timeIntervalSinceReferenceDate:[[wo objectAtIndex:i] date]]<=0) {
//			if ([[wo class] isSubclassOfClass:[CCWT class]])
//			{
//				cost+=[wo cost];
//			}
//			else if ([[wo class] isSubclassOfClass:[CCBOL class]])
//			{
//				cost+=[wo cost];
//			}
//			else if ([[wo theSubType] isEqualToString:@"BLEND"]) {
//				for (CCBlend *aBlend in [wo blends])
//				{
//					if ([[aBlend direction] isEqualToString:@"IN FROM"])
//						cost+=aBlend.gallons/[aBlend.sourceLot costsUpToDate:[wo date]];
//					else 
//						cost-=aBlend.gallons/[wo derivedVolume]*cost;
//					[wo setEndingCost:cost];
//				}
//			}
//			else {
//				cost+=[wo cost];
//			}
//			[wo setEndingCost:cost];
//		}
//}
-(CCSCP *)getSCPByID:(NSString *)theID
{
	for (CCWorkOrder *wo in workOrders) {
		if ([[wo class] isSubclassOfClass:[CCSCP class]])
		{
			if ([[(CCSCP *)wo theID] isEqualToString:theID]) {
				return (CCSCP *)wo;
			}
		}
	}
	return nil;
}

-(void)linkUpSCPsToWeighTags
{
	for (CCWorkOrder *wo in workOrders) {
		if ([[wo class] isSubclassOfClass:[CCWT class]])
		{
			CCSCP *theSCP=[self getSCPByID:[(CCWT *)wo createdFromSCPID]];
			[(CCWT *)wo setCreatedFromSCP:theSCP];
			[[theSCP weighTags] addObject:(CCWT*)wo];
		}
	}
}

-(NSArray *)weightTagsInLot
{
	NSMutableArray *wts=[[[NSMutableArray alloc] init] autorelease];
	for (CCWorkOrder *wt in workOrders)
	{
		if ([[wt class] isSubclassOfClass:[CCWT class]])
		{
			[wts addObject:wt];
		}
	}
	return wts;
}

-(void)updateDetail
{

	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (workOrders==nil)
		workOrders=[[NSMutableArray alloc] init];
	
	[workOrders removeAllObjects];
	NSDictionary *fromServer=[CrushHelper fetchLotInfoForLotID:self.lotNumber];
	
	if ([CrushHelper nillIfNull:[fromServer objectForKey:@"workorders"]]!=nil)
	{
		[self updateAllWorkOrdersWithDictionary:fromServer];
//		for (NSDictionary *dict in [fromServer objectForKey:@"workorders"])
//		{
//			if ([[[dict objectForKey:@"data"] objectForKey:@"TYPE"]isEqualToString:@"SCP"])
//			{
//				[workOrders addObject:[[[CCSCP alloc] initWithDictionary:dict withLot:self] autorelease]];
//				[ap.sortingTable refreshLotLinks];
//			}
//			else if ([[dict objectForKey:@"type"] isEqualToString:@"WT"])
//				[workOrders addObject:[[[CCWT alloc] initWithDictionary:dict withLot:self] autorelease]];
//			else if ([[dict objectForKey:@"type"] isEqualToString:@"BOL"])
//				[workOrders addObject:[[[CCBOL alloc] initWithDictionary:dict withLot:self] autorelease]];
//			else
//				[workOrders addObject:[[[CCWorkOrder alloc] initWithDictionary:dict withLot:self] autorelease]];
//		}
		[ap.sortingTable refreshLotLinks];
	}		
		
	[self reSort];
	[self calculateVolumes];
	[self linkUpSCPsToWeighTags];
	if (the702View==nil)
		the702View=[[CC702 alloc] initWithWorkOrders:self.workOrders];
	else 
	{
		[the702View release];
		the702View=[[CC702 alloc] initWithWorkOrders:self.workOrders];		
	}
	retrieved=YES;
	needsReload=NO;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"lotDetailReceived" object:nil];	
}
-(CCStructure *)getStructureUpToWorkOrder:(CCWorkOrder *)theWO includeWO:(BOOL)inc
{
	BOOL inWOArray=YES;
	if ([self.workOrders indexOfObject:theWO]==NSNotFound){
		inWOArray=NO;
	}
	
	CCStructure *theStruct=[[[CCStructure alloc] init] autorelease];
	for (id wo in self.workOrders)
	{
		if (!inWOArray & (theWO != nil))
		{
			if ([theWO.date compare:[wo date]]==NSOrderedSame) {
				return theStruct;
			}
		}
		
		if ([wo isEqual:theWO] & !inc)
			return theStruct;
		
		if ([[[wo class] description] isEqualToString:@"CCWT"])
		{
			[theStruct addToStructureFromWT:(CCWT *)wo];
		}
		else {
			[theStruct addToStructureFromWO:(CCWorkOrder *)wo];
		}
		
		if ([wo isEqual:theWO] & inc)
			return theStruct;

	}
	return theStruct;
}

-(void)reSort
{
	[self.workOrders sortUsingComparator:^(id left,id right)
	 {
		 NSDate *leftDate=[CrushHelper stripTimeFromDate:[left date]];
		 NSDate *rightDate=[CrushHelper stripTimeFromDate:[right date]];
		 
		 NSComparisonResult result=NSOrderedAscending;
		 if ([leftDate timeIntervalSinceDate:rightDate]<0)
		 {
			 result=NSOrderedAscending;
		 }
		 else if ([leftDate timeIntervalSinceDate:rightDate]>0)
		 {
			 result=NSOrderedDescending;
		 }
		 else {
			 if (([[left class] isSubclassOfClass:[CCSCP class]]) & ([[right class] isSubclassOfClass:[CCWT class]])) {
				 result=NSOrderedAscending;
			 }
			 if (([[left class] isSubclassOfClass:[CCWT class]]) & ([[right class] isSubclassOfClass:[CCSCP class]])) {
				 result=NSOrderedDescending;
			 }
		 }
		 return result;
	 }];
}

-(void) setFavorite:(BOOL)val
{
	favorite=val;
	if (!favorite)
	{
		retrieved=NO;
		[workOrders release];
		workOrders=nil;
		[the702View release];
		the702View=nil;		
	}
}
-(NSString *)contentsDescription
{
	NSMutableString *result=[[[NSMutableString alloc] init] autorelease];
	int i=0;
	for (NSString *woDesc in self.workOrders)
	{
		[result appendFormat:@"%d %@\n",i,woDesc.description];
		i++;
	}
	return result;
}

-(float) currentGallons
{
	return [[self.workOrders lastObject] derivedVolume];
}

-(CCWorkOrder *) previousWorkOrder:(CCWorkOrder *)ofWorkOrder
{
	CCWorkOrder *theWO=[self getWorkOrderByID:[ofWorkOrder theID]];
	NSInteger indexOfCurrentWorkOrder=[self.workOrders indexOfObject:theWO];
	if (indexOfCurrentWorkOrder==NSNotFound)
		return nil;
	else 
		if (indexOfCurrentWorkOrder>0) {
			return [self.workOrders objectAtIndex:indexOfCurrentWorkOrder-1];
		}
	return nil;
}

-(float)tankGallonsUptoWO:(CCWorkOrder *)theWO;
{
	float g=0;
	for (id wo in self.workOrders)
	{
		if ([[[wo class] description]isEqualToString:@"CCWT"])
			g+=([wo totalNetWeight]/ 2000.0)*155;
		else
		{
			if ([wo endingTankGallons]>0) {
				g=[wo endingTankGallons];
			}
		}
		if ([wo isEqual:theWO])
			return g;
	}
	return g;
	
}
-(float)toppingGallonsUptoWO:(CCWorkOrder *)theWO;
{
	float g=0;
	for (id wo in self.workOrders)
	{
		if (![[[wo class] description]isEqualToString:@"CCWT"])
		{
			if ([wo endingToppingGallons]>0)
			{
				g=[wo endingToppingGallons];
			}
			if ([wo isEqual:theWO])
				return g;			
		}
		if ([wo isEqual:theWO])
			return g;
	}
	return g;	
}
-(int)barrelCountUptoWO:(CCWorkOrder *)theWO;
{
	int g=0;
	for (id wo in self.workOrders)
	{
		if (![[[wo class] description]isEqualToString:@"CCWT"])
		{
			if ([wo endingBarrelCount]>0) {
				g=[wo endingBarrelCount];
			}
			if ([wo isEqual:theWO])
				return g;
			
		}
	}
	return g;	
}

-(BOOL)isDeletable
{
	if (self.retrieved & [self.workOrders count]==0)
		return YES;
	else 
		return NO;
}

-(NSArray *)incomingLots
{
	NSMutableArray *list=[[[NSMutableArray alloc] init] autorelease];
	
	for (NSObject *wo in self.workOrders)
	{
		if (![[[wo class] description] isEqualToString:@"CCWT"])
		{
			if ([[(CCWorkOrder *)wo theType] isEqualToString:@"BLEND"])
			{
				for (CCBlend *aBlend in [(CCWorkOrder *)wo blends])
				{
					if ([aBlend.direction isEqualToString:@"OUT TO"]) {
						[list addObject:[self.vintage getLotByNumber:aBlend.sourceLot]];
					}
				}
			}
			if ([[(CCWorkOrder *)wo theSubType] isEqualToString:@"BLENDING"])
			{
				for (CCBlend *aBlend in [(CCWorkOrder *)wo blends])
				{
					if ([aBlend.direction isEqualToString:@"IN FROM"]) {
						[list addObject:[self.vintage getLotByNumber:aBlend.sourceLot]];
					}
				}
			}			
		}
	}
//	NSArray *result=[[[NSArray alloc] initWithArray:list]autorelease];
	return list;
}

-(CCWorkOrder *)getWorkOrderByID:(NSString *)theID
{
	for (CCWorkOrder *awo in self.workOrders)
	{
		if ([[awo class] isSubclassOfClass:[CCWorkOrder class]]) {
			if ([awo.theID isEqualToString:theID])
				return awo;
		}
	}
	return nil;
}
-(CCWT *)getWTByID:(NSInteger)theID
{
	for (CCWT *awo in self.workOrders)
	{
		if (awo.theID==theID)
			return awo;
	}
	return nil;
}

-(void)save
{
	
	if (dbid!=nil)
	{
		NSDictionary *dict;
		dict=[[NSDictionary alloc] initWithObjectsAndKeys:
			  self.lotNumber,@"lotnumber",
			  self.description,@"description",
			  [CrushHelper yesNoFromBOOL:self.active],@"active",
			  [NSString stringWithFormat:@"%4d", [self.vintage year]],@"vintage",
			  self.dbid,@"DBID",
			  [[NSUserDefaults standardUserDefaults] objectForKey:@"clientid"],@"clientid",
			  [CrushHelper boolDescription:self.favorite],@"favorite",
			  [CrushHelper boolDescription:self.organic],@"organic",
			  nil];	
		NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"modlot"];
		self.dbid=[[result objectForKey:@"ID"] description];  //json returns nsdecimalnumber which needs to be converted to nsstring
		self.lotNumber=[result objectForKey:@"LOT"];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"lotSaved" object:self];
		[dict release];
		
	}
	
}
-(void)dealloc
{
    [workOrders release];
    [description release];
    [lotNumber release];
    [dbid release];
    [structure release];
	[the702View release];
    
    [super dealloc];
}
@end
