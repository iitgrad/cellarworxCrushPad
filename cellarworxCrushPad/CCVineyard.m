//
//  CCVineyard.m
//  Crush
//
//  Created by Kevin McQuown on 8/9/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCVineyard.h"
#import "CrushHelper.h"

#define knewLat 38.580714578
#define knewLong -122.867145538

@implementation CCVineyard
@synthesize name, coordinate, clientid, organic, biodynamic, dbid, gateCode, appellation, region;

-(id)initWithName:(NSString *)n
{
	self=[super init];
	name=[[NSString alloc] initWithString:n];
	gateCode=[[NSString alloc] initWithString:@""];
	appellation=[[NSString alloc] initWithString:@""];
	region=[[NSString alloc] initWithString:@""];
	organic=NO;
	biodynamic=NO;
	coordinate.latitude=knewLat;
	coordinate.longitude=knewLong;
	self.clientid=[[NSUserDefaults standardUserDefaults] objectForKey:@"clientid"];
	self.dbid=@"NEW";
	return self;
}
-(id)initWithDictionary:(NSDictionary *)dict
{
	if ([[NSNull null] isEqual:dict])
		return [self initWithName:@"None"];

	self=[super init];
	name=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[dict objectForKey:@"NAME"]]];
	dbid=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[dict objectForKey:@"ID"]]];
	clientid=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[dict objectForKey:@"CLIENTID"]]];
	gateCode=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[dict objectForKey:@"GATECODE"]]];
	appellation=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[dict objectForKey:@"APPELLATION"]]];
	region=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[dict objectForKey:@"REGION"]]];
	coordinate.latitude=[[CrushHelper blankIfNull:[dict objectForKey:@"LAT"]] floatValue];
	coordinate.longitude=[[CrushHelper blankIfNull:[dict objectForKey:@"LONG"]] floatValue];

	self.organic=NO;
	self.biodynamic=NO;
	if ([[CrushHelper blankIfNull:[dict objectForKey:@"ORGANIC"]] isEqualToString:@"YES"])
	{
		self.organic=YES;
	}
	if ([[CrushHelper blankIfNull:[dict objectForKey:@"BIODYNAMIC"]] isEqualToString:@"YES"])
	{
		self.biodynamic=YES;
	}
	return self;
}
-(id)initWithVineyard:(CCVineyard *)v
{
	self=[super init];
	name=[[NSString alloc] initWithString:v.name];
	dbid=[[NSString alloc] initWithString:v.dbid];
	clientid=[[NSString alloc] initWithString:v.clientid];
	gateCode=[[NSString alloc] initWithString:v.gateCode];
	appellation=[[NSString alloc] initWithString:v.appellation];
	region=[[NSString alloc] initWithString:v.region];
	self.organic=v.organic;
	self.biodynamic=v.biodynamic;
	coordinate.latitude=v.coordinate.latitude;
	coordinate.longitude=v.coordinate.longitude;
	return self;
}
-(NSString *)save
{	
	NSArray *yesno=[[[NSArray alloc] initWithObjects:@"NO",@"YES",nil] autorelease];
	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:
						self.dbid,@"ID",
						self.name,@"NAME",
						self.clientid,@"CLIENTID",
						self.gateCode,@"GATECODE",
						self.appellation,@"APPELLATION",
						self.region,@"REGION",
						[NSString stringWithFormat:@"%12.9f",self.coordinate.latitude],@"LAT",
						[NSString stringWithFormat:@"%12.9f",self.coordinate.longitude],@"LONG",
						[yesno objectAtIndex:self.organic],@"ORGANIC",
						[yesno objectAtIndex:self.biodynamic],@"BIODYNAMIC",
						nil];
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"update_vineyard"];
	NSLog(@"%@",[result description]);
	self.dbid=[[result objectForKey:@"ID"] description];  //json returns nsdecimalnumber which needs to be converted to nsstring

	[[NSNotificationCenter defaultCenter] postNotificationName:@"vineyardSaved" object:self];
	
	[dict release];
	return nil;
}
-(NSString *)remove 
{	
	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:
						self.dbid,@"ID",
						nil];
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"delete_vineyard"];
	NSLog(@"%@",[result description]);
	[dict release];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"vineyardDeleted" object:nil];
	return nil;
}


-(NSString *)title
{
	return name;
}
-(void) setNewLocation:(CLLocationCoordinate2D)loc
{
	coordinate.latitude=loc.latitude;
	coordinate.longitude=loc.longitude;
}
-(void) dealloc
{
    [name release];
    [dbid release];
    [clientid release];
    [gateCode release];
    [appellation release];
    [region  release];
    
    [super dealloc];
}

@end
