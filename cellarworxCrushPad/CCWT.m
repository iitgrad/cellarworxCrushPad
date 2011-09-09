//
//  CCWT.m
//  Crush
//
//  Created by Kevin McQuown on 6/18/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCWT.h"
#import "CCWeight.h"
#import "CrushHelper.h"
#import "CCLot.h"
#import "CCVineyard.h"
#import "cellarworxAppDelegate.h"

@implementation CCWT

@synthesize vineyard;
@synthesize varietal;
@synthesize appellation;
@synthesize clone;

@synthesize regionCode;
@synthesize truckLicense;
@synthesize trailerLicense;
@synthesize clientname;
@synthesize clientid;
@synthesize clientcode;
@synthesize number;

@synthesize weights;
@synthesize totalNetWeight;
@synthesize totalBinCount;
@synthesize totalGross;
@synthesize totalTare;

@synthesize theID;
@synthesize tagID;
@synthesize gallons;
@synthesize createdFromSCP;
@synthesize createdFromSCPID;

-(NSString *)description
{
	return [NSString stringWithFormat:@"Weigh Tag:%@ \n  Varietal:%@\n  Vineyard Name:%@",self.tagID,self.varietal,vineyard.name];
}

-(id) initWithDictionary:(NSDictionary *)dictionary withLot:(CCLot *)parentLot
{
	if (parentLot==nil)
	{
		cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
		parentLot=[[ap defaultVintage] getLotByNumber:[[[dictionary objectForKey:@"data"] objectForKey:@"wt"] objectForKey:@"LOT"]];		
	}
	
	self=[super initWithDictionary:dictionary withLot:parentLot];

	NSDate *theDate=[CrushHelper nillIfNull:[dictionary objectForKey:@"date"]];
	if (theDate != nil)
		self.date=[[CrushHelper dateAndTimeFormatSQLStyle] dateFromString:[CrushHelper nillIfNull:[dictionary objectForKey:@"date"]]];
	else 
		self.date=nil;
	NSDictionary *data=[dictionary objectForKey:@"data"];	
	NSDictionary *wtdict=[data objectForKey:@"wt"];
	
	NSDateFormatter *format=[[[NSDateFormatter alloc] init] autorelease];
	[format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

	self.clientname=[wtdict objectForKey:@"CLIENTNAME"];
	self.clientid=[wtdict objectForKey:@"CLIENTID"];
	self.clientcode=[wtdict objectForKey:@"CLIENTCODE"];
	tagID=[[CrushHelper nillIfNull:[wtdict objectForKey:@"TAGID"]] intValue];
	vineyard=[[CCVineyard alloc] initWithDictionary:[wtdict objectForKey:@"vineyard"]];
	self.varietal=[CrushHelper blankIfNull:[wtdict objectForKey:@"VARIETAL"]];
	self.appellation=[CrushHelper blankIfNull:[wtdict objectForKey:@"APPELLATION"]];
	self.clone=[CrushHelper blankIfNull:[wtdict objectForKey:@"CLONE"]];
	self.regionCode=[CrushHelper blankIfNull:[wtdict objectForKey:@"REGIONCODE"]];
	self.truckLicense=[CrushHelper blankIfNull:[wtdict objectForKey:@"TRUCKLICENSE"]];
	self.trailerLicense=[CrushHelper blankIfNull:[wtdict objectForKey:@"TRAILERLICENSE"]];
	self.trailerLicense=[CrushHelper blankIfNull:[wtdict objectForKey:@"TRAILERLICENSE"]];
	self.createdFromSCPID=[CrushHelper blankIfNull:[wtdict objectForKey:@"SCPID"]];
	cost=[[CrushHelper nillIfNull:[wtdict objectForKey:@"COST"]]floatValue];
	theID=[[CrushHelper nillIfNull:[wtdict objectForKey:@"ID"]] intValue];
	number=[[CrushHelper blankIfNull:[wtdict objectForKey:@"TAGID"]] intValue]+5000;
	createdFromSCPID=[CrushHelper blankIfNull:[wtdict objectForKey:@"SCPID"]];
	inventoryAdjusted=YES;
	
	weights=[[NSMutableArray alloc] init];
	if ([wtdict objectForKey:@"bindetail"]!=[NSNull null])
	{
		for (NSDictionary *aWeight in [wtdict objectForKey:@"bindetail"])
		{
			[weights addObject:[[[CCWeight alloc] initWithDictionary:aWeight]autorelease]];
		}
	}
	totalNetWeight=0;
	totalBinCount=0;
	totalGross=0;
	totalTare=0;
	for (CCWeight *newWeight in weights)
	{
		totalNetWeight+=[newWeight netWeight];
		totalBinCount+=[newWeight bincount];
		totalGross+=[newWeight weight];
		totalTare+=[newWeight tare];
	}
	
	return self;
}
-(id)initWithLot:(CCLot *)parentLot
{
	self=[super initWithDictionary:nil withLot:parentLot];
	theID=-1;
	tagID=-1;
	self.date=[NSDate date];
	vineyard=[[NSString alloc] initWithString:@""];
	varietal=[[NSString alloc] initWithString:@""];
	appellation=nil;
	clone=nil;
	regionCode=nil;
	truckLicense=[[NSString alloc] initWithString:@""];
	trailerLicense=[[NSString alloc] initWithString:@""];
	number=-1;
	clientname=[[NSString alloc] initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientname"]];
	clientid=[[NSString alloc] initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientid"]];
	clientcode=[[NSString alloc] initWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"clientcode"]];
	weights=[[NSMutableArray alloc] init];
	inventoryAdjusted=YES;
	createdFromSCP=nil;
	cost=0;
	return self;
}

-(id)initWithSCP:(CCSCP *)fromSCP withLot:(CCLot *)parentLot
{
	self=[super initWithDictionary:nil withLot:parentLot];
	self.date=[NSDate date];
	theID=-1;
	tagID=-1;
	self.inLot=fromSCP.inLot;
	vineyard=[[CCVineyard alloc] initWithVineyard:fromSCP.vineyard];
	varietal=[[NSString alloc] initWithString:fromSCP.varietal];
	appellation=[[NSString alloc] initWithString:fromSCP.appellation];
	clone=[[NSString alloc] initWithString:fromSCP.clone];
	regionCode=[[NSString alloc] initWithString:fromSCP.regionCode];
	truckLicense=[[NSString alloc] initWithString:@""];
	trailerLicense=[[NSString alloc] initWithString:@""];
	number=-1;
	clientname=[[NSString alloc] initWithString:fromSCP.clientname];
	clientid=[[NSString alloc] initWithString:fromSCP.clientid];
	clientcode=[[NSString alloc] initWithString:fromSCP.clientcode];
	weights=[[NSMutableArray alloc] init];
	inventoryAdjusted=YES;
	createdFromSCP=fromSCP;
	cost=0;
	return self;
}

-(NSInteger)totalNetWeight
{
	float theSum=0;
	for (CCWeight *newWeight in weights)
	{
		theSum+=[newWeight netWeight];
	}
	return theSum;
}

-(float)gallons
{
//	return [[NSNumber alloc] initWithFloat:[totalNetWeight floatValue]/2000*155];
	return (float)totalNetWeight/2000*155;
}

-(NSInteger)totalBinCount
{
	float theSum=0;
	for (CCWeight *newWeight in weights)
	{
		theSum+=[newWeight bincount];
	}
	return theSum;
}
-(NSInteger)totalGross
{
	float theSum=0;
	for (CCWeight *newWeight in weights)
	{
		theSum+=[newWeight weight];
	}
	return theSum;
}

-(NSInteger)totalTare
{
	float theSum=0;
	for (CCWeight *newWeight in weights)
	{
		theSum+=[newWeight tare];
	}
	return theSum;
}

-(NSString *)dateAndTimeString
{
	NSDateFormatter *format=[[[NSDateFormatter alloc] init] autorelease];
	
	[format setDateStyle:NSDateFormatterShortStyle];
	[format setTimeStyle:NSDateFormatterShortStyle];
	return [format stringFromDate:date];
}


-(NSString *)dateString
{
	NSDateFormatter *format=[[[NSDateFormatter alloc] init] autorelease];

	[format setDateStyle:NSDateFormatterShortStyle];
	[format setTimeStyle:NSDateFormatterNoStyle];
	return [format stringFromDate:date];
}

-(void)delete
{
	NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
						 [NSNumber numberWithInt:theID],@"ID",
						 [NSNumber numberWithInt:tagID],@"TAGID",
						 nil] autorelease];
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"delete_wt"];
	NSLog(@"%@",[result description]);
}
-(void)save
{
	NSDateFormatter *format=[[[NSDateFormatter alloc] init] autorelease];
	[format setDateFormat:@"yyyy-MM-dd HH:mm"];
	
	NSString *vyd;
	if (vineyard==nil) {
		vyd=[NSString stringWithString:@""];
	}
	else {
		vyd=vineyard.dbid;
	}

	NSString *scpID;
	if (createdFromSCP!=nil) {
		scpID=[NSString stringWithString:[createdFromSCP theID]];
	}
	else {
		scpID=[NSString stringWithString:@""];
	}

	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:vyd,@"VINEYARDID",
						varietal,@"VARIETY",
						appellation,@"APPELLATION",
						truckLicense,@"TRUCKLICENSE",
						trailerLicense,@"TRAILERLICENSE",
						[NSString stringWithFormat:@"%d",(int)cost],@"COST",
						[inLot lotNumber],@"LOT",
						clientname,@"CLIENTNAME",
						regionCode,@"REGIONCODE",
						[format stringFromDate:self.date],@"DATETIME",
						[NSString stringWithFormat:@"%d",theID],@"ID",
						[NSString stringWithFormat:@"%d",tagID],@"TAGID",
						scpID,@"SCPID",
						nil];
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"update_wt"];
	[dict release];
	theID=[[result objectForKey:@"ID"]intValue];
	tagID=[[result objectForKey:@"TAGID"]intValue];
	number=tagID+5000;
	NSLog(@"%@",[result description]);
//	[inLot reSort];
}

-(BOOL) match:(NSString *)s
{
	return NO;
}

-(void) dealloc {
	[createdFromSCPID release];
    [vineyard release];
    [varietal release];
    [appellation release];
    [clone release];
    [regionCode release];
    [truckLicense release];
    [trailerLicense release];
    [clientname release];
    [clientcode release];
    [clientid release];
    [weights release];
    [super dealloc];
}
@end
