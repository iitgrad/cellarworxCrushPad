//
//  CCWorkOrder.m
//  Crush
//
//  Created by Kevin McQuown on 6/14/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCWorkOrder.h"
#import "CrushHelper.h"
#import "CCWT.h"
#import "CCAsset.h"
#import "CCBlend.h"
#import "CCLot.h"
#import "CCLabTest.h"
#import "CCFermProtocol.h"
#import "CCTask.h"
#import "cellarworxAppDelegate.h"
#import "CCAssetReservation.h"
#import "CCWineStructure.h"

#include <dispatch/dispatch.h>

@implementation CCWorkOrder
@synthesize clientDescription;
@synthesize typeDescription;
@synthesize clientcode;
@synthesize clientname;
@synthesize clientid;
@synthesize status;
@synthesize theType;
@synthesize theSubType;
@synthesize gallons;
@synthesize startSlot;
@synthesize dryice;
//@synthesize lot;
@synthesize theID;
@synthesize workPerformedBy;
@synthesize needsSave;
//@synthesize structure;
@synthesize lotNumberString;
@synthesize lotDescriptionString;
@synthesize toppingLot;
@synthesize so2Add;

@synthesize timeslot;
@synthesize duration;
@synthesize strength;
@synthesize vesselid;
@synthesize vesseltype;
@synthesize theLock;
@synthesize assetReservations;

@synthesize brix;
@synthesize temp;
@synthesize taskID;
@synthesize casesBottled;
@synthesize gallonsPerCase;
@synthesize task;

@synthesize startingTankGallons, startingToppingGallons, startingBarrelCount, endingTankGallons, endingToppingGallons, endingBarrelCount;

//@synthesize assets;
@synthesize blends;
@synthesize labtest;

-(NSString *) description
{
	NSMutableString *desc=[[[NSMutableString alloc] init] autorelease];
	[desc appendFormat:@"%@ %@ %@ %@ %@",self.theType,self.theSubType,self.theID,[[CrushHelper dateFormatShortStyle] stringFromDate:self.date],self.clientcode];
	return desc;
}

//-(id)initWithWorkOrder:(CCWorkOrder *)theWO
//{
//	self=[super init];
//	self=theWO;
//	return self;
//}
-(id)initWithLot:(CCLot *)forLot
{
	if (self=[super initWithLot:forLot])
	{
		
		self.date=[NSDate date];
		gallons=[[NSNumber alloc] initWithFloat:0.0];
		self.clientname=[[NSUserDefaults standardUserDefaults] objectForKey:@"clientname"];
		self.clientcode=[[NSUserDefaults standardUserDefaults] objectForKey:@"clientcode"];
		self.clientid=[[NSUserDefaults standardUserDefaults] objectForKey:@"clientid"];
		theSubType=[[NSString alloc] initWithString:@""];
		self.status=@"ASSIGNED";
		self.workPerformedBy=@"CCC";
		self.theID=nil;
		self.dryice=@"";
		self.clientDescription=@"";
		self.startSlot=@"";
		self.timeslot=@"";
		self.toppingLot=@"";
		self.so2Add=@"";
		self.lot=[NSString stringWithString:[forLot lotNumber]];
		self.inLot=forLot;
		self.theID=@"NEW";
		self.casesBottled=0;
		self.gallonsPerCase=2.3775;
        taskID=nil;
		task=nil;

		inventoryAdjusted=NO;
		endingTankGallons=0;
		endingToppingGallons=0;
		endingBarrelCount=0;
		cost=0.0;
		
		labtest=nil;
		blends=[[NSMutableArray alloc] init];
//		assets=[[NSMutableArray alloc] init];
		theLock=[[NSLock alloc] init];
		assetReservations=[[NSMutableArray alloc] init];
		needsSave=NO;

		[forLot.workOrders addObject:self];
		[self.inLot calculateVolumes];
		return self;
	}
	return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary withLot:(CCLot *)parentLot
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	self=[super initWithDictionary:dictionary withLot:parentLot];

	taskID=nil;
	endingTankGallons=0;
	endingToppingGallons=0;
	endingBarrelCount=0;
	
	theLock=[[NSLock alloc] init];
	
	if ([dictionary objectForKey:@"data"] == nil) {
		return nil;
	}
	if (![[dictionary objectForKey:@"data"] respondsToSelector:@selector(objectForKey:)])
	{
	   NSLog(@"***%@",[[[dictionary objectForKey:@"data"] class] description]);
		return nil;
	}
	
	self.theType=[dictionary objectForKey:@"type"];
	self.theSubType=[[dictionary objectForKey:@"data"] objectForKey:@"TYPE"];

	self.theID=[[dictionary objectForKey:@"data"] objectForKey:@"ID"];
	self.dbid=[self.theID intValue];
	
	if (self.theID==nil) 
		return nil;
	self.clientcode=[[dictionary objectForKey:@"data"] objectForKey:@"CLIENTCODE"];
	self.clientid=[[dictionary objectForKey:@"data"] objectForKey:@"CLIENTID"];
	self.clientDescription=[CrushHelper blankIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"OTHERDESC"]];

	self.dryice=[CrushHelper blankIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"DRYICE"]];
	self.startSlot=[CrushHelper blankIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"STARTSLOT"]];
	self.timeslot=[CrushHelper blankIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"TIMESLOT"]];
	self.duration=[CrushHelper blankIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"DURATION"]];
	self.strength=[CrushHelper blankIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"STRENGTH"]];
	self.vesseltype=[CrushHelper blankIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"VESSELTYPE"]];
	self.vesselid=[CrushHelper blankIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"VESSELID"]];
	self.lotNumberString=[CrushHelper blankIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"LOT"]];
	self.inLot=[[ap defaultVintage] getLotByNumber:lotNumberString];
	self.lotDescriptionString=[CrushHelper blankIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"LOTDESCRIPTION"]];
	self.casesBottled=[[CrushHelper nillIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"casesBottled"]] intValue];
	self.gallonsPerCase=[[CrushHelper nillIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"gallonsPerCase"]] floatValue];
	self.toppingLot=[CrushHelper blankIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"TOPPINGLOT"]];
	self.so2Add=[CrushHelper blankIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"SO2ADD"]];
    
    if ([CrushHelper nillIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"id"]]!=nil)
    {
		if ([[CrushHelper nillIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"id"]] intValue]>0)
		{
			[theLock lock];
			
			self.taskID=[[dictionary objectForKey:@"data"] objectForKey:@"id"];
			[ap addWO:self toTask:self.taskID];
//			if ([[ap tasks] objectForKey:taskID]!=nil)
//			{
//				CCTask *aTask=[[ap tasks] objectForKey:taskID];
//				[[aTask workOrders] addObject:self];
//				self.task=aTask;
//			}
//			else
//			{
//				CCTask *aTask=[[CCTask alloc] initWithDictionary:[dictionary objectForKey:@"data"]];
//				[aTask.workOrders addObject:self];
//				[[ap tasks] setObject:aTask forKey:taskID];
//				self.task=aTask;
//				self.taskID=[NSString stringWithFormat:@"%d",aTask.dbid];
//				[aTask release];
//			}
			[theLock unlock];			
		}
    }

	if ([[[dictionary objectForKey:@"data"] objectForKey:@"INVENTORYADJUSTED"] isEqualToString:@"NO"])
		inventoryAdjusted=NO;
	else 
		inventoryAdjusted=YES;
		
	if ([[self theSubType] isEqualToString:@"BLEND"] | [[self theSubType] isEqualToString:@"BLENDING"])
		inventoryAdjusted=YES;
	
	startingTankGallons=[[CrushHelper nillIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"TANKGALLONS"]] floatValue];
	startingToppingGallons=[[CrushHelper nillIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"TOPPINGGALLONS"]] floatValue];
	startingBarrelCount=[[CrushHelper nillIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"BARRELCOUNT"]] floatValue];

	endingTankGallons=[[CrushHelper nillIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"ENDINGTANKGALLONS"]] floatValue];
	endingToppingGallons=[[CrushHelper nillIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"ENDINGTOPPINGGALLONS"]] floatValue];
	endingBarrelCount=[[CrushHelper nillIfNull:[[dictionary objectForKey:@"data"] objectForKey:@"ENDINGBARRELCOUNT"]] floatValue];
	float endingGallons=endingTankGallons+endingToppingGallons+(endingBarrelCount*60);
	gallons=[[NSString alloc] initWithFormat:@"%5.1f", endingGallons];			
	
	brix=nil;
	temp=nil;
	if ([dictionary objectForKey:@"brixtemp"]!=nil) {
		brix=[[NSNumber alloc] initWithFloat:[[[dictionary objectForKey:@"brixtemp"] objectForKey:@"BRIX"] floatValue]];
		temp=[[NSNumber alloc] initWithFloat:[[[dictionary objectForKey:@"brixtemp"] objectForKey:@"temp"] floatValue]];
	}
	

	self.status=[[dictionary objectForKey:@"data"]objectForKey:@"STATUS"];
	self.workPerformedBy=[[dictionary objectForKey:@"data"]objectForKey:@"WORKPERFORMEDBY"];
	if (clientname!=nil)
		NSLog(@"will leak here");
  	clientname=[[NSString alloc] initWithString:[[dictionary objectForKey:@"data"] objectForKey:@"CLIENTNAME"]];
	theID=[[NSString alloc] initWithString:[[dictionary objectForKey:@"data"] objectForKey:@"ID"]];
    self.date=[[CrushHelper dateFormatSQLStyle] dateFromString:[[dictionary objectForKey:@"data"]objectForKey:@"DUEDATE"]];
	assetReservations=[[NSMutableArray alloc] init];
//	assets=[[NSMutableArray alloc] init];
//	@try {
		for (NSDictionary *d in [[dictionary objectForKey:@"data"]objectForKey:@"assets"])
		{
			CCAssetReservation *reservation=[[CCAssetReservation alloc] initWithDictionary:d forWO:self];
			[self.assetReservations addObject:reservation];
			[reservation release];
//			CCAsset *asset=[[CCAsset alloc] initWithDictionary:d];
//			[self.assets addObject:asset];
//			[asset release];
		}
//	}
//	@catch (NSException * e) {
//	}
	
	blends=[[NSMutableArray alloc] init];
	
	NSArray *blenddict=[[NSArray alloc] initWithArray:[[dictionary objectForKey:@"data"] objectForKey:@"blend"]];
	for (NSDictionary *dict in blenddict)
	{
		CCBlend *theBlend=(CCBlend *)[[CCBlend alloc] initWithDictionary:dict];
		[self.blends addObject:theBlend];
		[theBlend release];
	}
	[blenddict release];

	if ([self.theSubType isEqualToString:@"LAB TEST"])
	{
		NSDictionary *newlabtest=[[dictionary objectForKey:@"data"] objectForKey:@"labtest"];
		labtest=[[CCLabTest alloc] initWithDictionary:newlabtest withWO:self];
	}
	needsSave=NO;
//	if (![[NSNull null] isEqual:[dictionary objectForKey:@"structure"]]) {
//		structure=[[CCWineStructure alloc] initWithDictionary:[dictionary objectForKey:@"structure"]];
//	}
	return self;

}
-(NSString *)assetListDescription
{
	NSMutableString *desc=[[[NSMutableString alloc] init] autorelease];
	for (CCAssetReservation *a in self.assetReservations)
	{
		[desc appendFormat:@"%@ ",a.asset.name];
	}
	return desc;
	
}

-(NSString *)mySQLDateString
{
	return [self.date description];
}
-(void)setToCompleteWithSave:(BOOL)s
{
	self.status=@"COMPLETED";
	if (s) {
		[self save];
	}
}

-(NSDictionary *)saveDictionary
{
	NSString *tg=[NSString stringWithFormat:@"%8.3f",endingTankGallons];
	NSString *topg=[NSString stringWithFormat:@"%8.3f",endingToppingGallons];
	NSString *bc=[NSString stringWithFormat:@"%5d",endingBarrelCount];
	
	NSString *taskid=nil;
	if (self.task==nil)
		taskid=@"0";
	else 
		taskid=[NSString stringWithFormat:@"%d",self.task.dbid];
	
	NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
						self.theID,@"ID",
						self.theSubType,@"TYPE",
						self.status,@"STATUS",
						self.dryice,@"DRYICE",
						taskid,@"TASKID",
						[NSNumber numberWithFloat:cost],@"COST",
						[NSNumber numberWithFloat:gallonsPerCase],@"gallonsPerCase",
						[NSNumber numberWithInt:casesBottled],@"casesBottled",
						self.startSlot,@"STARTSLOT",
						[CrushHelper yesNoFromBOOL:self.inventoryAdjusted],@"INVENTORYADJUSTED",
						tg,@"ENDINGTANKGALLONS",
						topg,@"ENDINGTOPPINGGALLONS",
						bc,@"ENDINGBARRELCOUNT",
						self.mySQLDateString,@"DUEDATE",
						self.clientname,@"CLIENTNAME",
						self.clientcode,@"CLIENTCODE",
						self.lot,@"LOT",
						self.toppingLot,@"TOPPINGLOT",
						self.so2Add,@"SO2ADD",
						self.workPerformedBy,@"WORKPERFORMEDBY",
						self.clientDescription,@"OTHERDESC",
						nil] autorelease];
	return dict;
}
-(NSString *)save
{	
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];

	NSDictionary *dict=[self saveDictionary];
	
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"update_wo"];
	NSLog(@"%@",[result description]);
	self.theID=[[result objectForKey:@"ID"] description];  //json returns nsdecimalnumber which needs to be converted to nsstring
	self.dbid=[self.theID intValue];

	[self.inLot reSort];
	needsSave=NO;
	
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"workOrderSaved" object:self];
	[ap updateDBWithItem:self];
	
	return [result objectForKey:@"ID"];
}
				   
-(NSString *)assetDescription
{
	NSMutableString *desc=[[[NSMutableString alloc] init] autorelease];
	if ([self.assetReservations count]>0)
	{
		for (int i=0;i<[self.assetReservations count];i++)
		{
			[desc appendFormat:@"%@ ",[[[self.assetReservations objectAtIndex:i] asset]description]];
		}
	}
	else {
		[desc appendString:@"---"];
	}

	return desc;
}

-(void) delete
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (![self.theID isEqualToString:@"NEW"]) {
		NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
							 self.theID,@"ID",
							 nil] autorelease];
		NSLog(@"%@",[[CrushHelper sendPostFromDictionary:dict withAction:@"delete_wo"]description]);
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"workOrderSaved" object:self];
		
		[ap deleteDBItem:self];
	}
}
-(BOOL)match:(NSString *)s
{
	NSRange find=[self.theSubType rangeOfString:s options:NSCaseInsensitiveSearch];
	if (find.length > 0)
		return YES;
	return NO;
}
//-(void) deleteAssetByName:(NSString *)assetName
//{
//	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:
//						assetName,@"ASSETNAME",
//						self.theID,@"WOID",
//						nil];
//	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"delete_reservation"];
//	NSLog(@"%@",[result description]);
//	[dict release];
//	
//	int i=0;
//	for (CCAsset *asset in self.assets)
//	{
//		if ([asset.name isEqualToString:assetName])
//			break;
//		i++;
//	}
//	if (i<[self.assets count])
//		[self.assets removeObjectAtIndex:i]; // we found it and can delete it
//	
//}
-(void) deleteAssetReservationByName:(NSString *)assetName
{
	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:
						assetName,@"ASSETNAME",
						self.theID,@"WOID",
						nil];
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"delete_reservation"];
	NSLog(@"%@",[result description]);
	[dict release];
	
	int i=0;
	for (CCAssetReservation *assetReservation in self.assetReservations)
	{
		if ([assetReservation.asset.name isEqualToString:assetName])
			break;
		i++;
	}
	if (i<[self.assetReservations count])
		[self.assetReservations removeObjectAtIndex:i]; // we found it and can delete it
}
-(void) addAssetReservation:(CCAssetReservation *)assetReservation
{
	[self.assetReservations addObject:assetReservation];
}

//-(void) addAssetReservationByName:(NSString *)assetName
//{
//	
//	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:
//						assetName,@"ASSETNAME",
//						self.theID,@"WOID",
//						nil];
//	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"add_reservation"];
//	NSLog(@"%@",[result description]);
//	[dict release];
//	
//	CCAssetReservation *assetReservation=(CCAssetReservation *)[[CCAssetReservation alloc] initWithDictionary:[result objectForKey:@"asset"]];
//	[self.assetReservations addObject:assetReservation];
//	[assetReservation release];
//}

//-(void) addAsset:(CCAsset *)asset
//{
//	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:
//						asset.name,@"ASSETNAME",
//						self.theID,@"WOID",
//						nil];
//	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"add_reservation"];
//	NSLog(@"%@",[result description]);
//	[dict release];
//	
//	[self.assets addObject:asset];
//}
//
//-(void) addAssetByName:(NSString *)assetName
//{
//	
//	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:
//						assetName,@"ASSETNAME",
//						self.theID,@"WOID",
//						nil];
//	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"add_reservation"];
//	NSLog(@"%@",[result description]);
//	[dict release];
//	
//	CCAsset *asset=(CCAsset *)[[CCAsset alloc] initWithDictionary:[result objectForKey:@"asset"]];
//	[self.assets addObject:asset];
//	[asset release];
//}
-(float) startingVolume
{
	return startingTankGallons+startingToppingGallons+(startingBarrelCount * 60);
}

- (void)dealloc {
	[toppingLot release];
	[so2Add release];
	[theLock release];
    [clientDescription release];
    [typeDescription release];
    [clientcode release];
    [clientname release];
    [clientid release];
    [theType release];
    [theSubType release];
    [startSlot release];
    [status release];
    [workPerformedBy release];
    [gallons release];
    [theID release];
//    [lot release];
    [timeslot release];
    [strength release];
    [duration release];
    [vesseltype release];
    [vesselid release];
    [dryice release];
    [brix release];
    [temp release];
    [labtest release];
//	[structure release];
	[lotNumberString release];
	[lotDescriptionString release];
  //  [assets release];
    [blends release];
	[assetReservations release];
	
    [super dealloc];
}

@end
