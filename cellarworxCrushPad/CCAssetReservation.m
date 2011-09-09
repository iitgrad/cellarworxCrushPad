//
//  CCAssetReservation.m
//  Crush
//
//  Created by Kevin McQuown on 7/27/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCAssetReservation.h"
#import "CCWorkOrder.h"
#import "CCAsset.h"
#import "CrushHelper.h"

@implementation CCAssetReservation
@synthesize tonsInVessel;
@synthesize wo;
@synthesize asset;
@synthesize dbid;
@synthesize binCount;

-(id) initWithDictionary:(NSDictionary *)dictionary forWO:(CCWorkOrder *)theWO
{
	self=[super init];
	wo=theWO;
	dbid=[[dictionary objectForKey:@"ID"] intValue];
	tonsInVessel=[[CrushHelper nillIfNull:[dictionary objectForKey:@"tonsInVessel"]] floatValue];
	binCount=[[CrushHelper nillIfNull:[dictionary objectForKey:@"binCount"]] intValue];
	self.asset=[[CCAsset alloc] initWithDictionary:dictionary];
	return self;
}

-(id)initWithWO:(CCWorkOrder *)theWO withAsset:(CCAsset *)theAsset
{
	self=[super init];
	dbid=-1;
	wo=theWO;
	self.asset=theAsset;
	tonsInVessel=0;
	binCount=0;
	return self;
}
-(void) save
{
	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:
						[NSString stringWithFormat:@"%4d",self.dbid],@"DBID",
						self.asset.name,@"ASSETNAME",
						wo.theID,@"WOID",
						[NSString stringWithFormat:@"%6.3f",self.tonsInVessel],@"tonsInVessel",
						[NSString stringWithFormat:@"%4d",self.binCount],@"binCount",
						nil];
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"update_reservation"];
	NSLog(@"%@",[result description]);
	self.dbid=[[result objectForKey:@"DBID"] intValue];
	[dict release];
}

-(void) delete
{
	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:
						[NSString stringWithFormat:@"%4d",self.dbid],@"DBID",
						nil];
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"delete_reservation"];
	NSLog(@"%@",[result description]);
	[dict release];	
}

-(void)dealloc
{
	[asset release];
	[super dealloc];
}

@end
