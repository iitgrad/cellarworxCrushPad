//
//  CCSCP.m
//  Crush
//
//  Created by Kevin McQuown on 6/21/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCSCP.h"
#import "CrushHelper.h"
#import "CCVineyard.h"
#import "CCWT.h"
#import "cellarworxAppDelegate.h"


@implementation CCSCP
@synthesize estTons;
@synthesize vineyard;
@synthesize varietal;
@synthesize clone;
@synthesize appellation;
@synthesize regionCode;
@synthesize specialInstructions;
@synthesize wholeClusterPercentage;
@synthesize handSorting;
@synthesize crushing;
@synthesize tankPosition;
@synthesize colorCoding;
@synthesize color1, color2;
@synthesize processingSpeed;
@synthesize actualTons;
@synthesize sulphurPPM;
@synthesize weighTags;
@synthesize varietalType;
@synthesize daysInTank;
@synthesize onTable;
@synthesize type;

#define kSortingLineProcessingSpeed 4

-(NSString *) description
{
	return @"SCP";
}

-(CCSCP *)initWithDictionary:(NSDictionary *)dictionary withLot:parentLot
{
//	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (self=[super initWithDictionary:dictionary withLot:parentLot])
	{
		NSDictionary *scpSection=[[NSDictionary alloc] initWithDictionary:[[dictionary objectForKey:@"data"]objectForKey:@"scp"]] ;
		estTons=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[scpSection objectForKey:@"ESTTONS"]]];
		vineyard=[[CCVineyard alloc] initWithDictionary:[scpSection objectForKey:@"vineyard"]];
		varietal=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[scpSection objectForKey:@"VARIETAL"]]];
		varietalType=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[scpSection objectForKey:@"VARIETALTYPE"]]];
		appellation=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[scpSection objectForKey:@"APPELLATION"]]];
		clone=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[scpSection objectForKey:@"CLONE"]]];
		regionCode=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[scpSection objectForKey:@"ZONE"]]];
		crushing=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[scpSection objectForKey:@"CRUSHING"]]];
		colorCoding=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[scpSection objectForKey:@"COLORCODE"]]];
		type=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[scpSection objectForKey:@"VARIETALTYPE"]]];
		daysInTank=[[NSNumber alloc] initWithInt:
					[[CrushHelper nillIfNull:[scpSection objectForKey:@"ESTDAYSINTANK"]] intValue]];
		specialInstructions=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[scpSection objectForKey:@"SPECIALINSTRUCTIONS"]]];
		if ([[CrushHelper blankIfNull:[scpSection objectForKey:@"TANKPOSITION"]] isEqualToString:@"TOP"])
			tankPosition=CCTankPositionTop;
		else 
			tankPosition=CCTankPositionBottom;
		if ([[CrushHelper blankIfNull:[scpSection objectForKey:@"HANDSORTING"]] isEqualToString:@"YES"])
			handSorting=YES;
		else 
			handSorting=NO;

		if ([[CrushHelper blankIfNull:[scpSection objectForKey:@"ONTABLE"]] isEqualToString:@"YES"])
			onTable=YES;
		else 
			handSorting=NO;
		
		wholeClusterPercentage=[[NSNumber alloc] initWithFloat:([[CrushHelper blankIfNull:[scpSection objectForKey:@"WHOLECLUSTER"]] floatValue] / 100.0)];
		sulphurPPM=[[CrushHelper blankIfNull:[scpSection objectForKey:@"SULPHURPPM"]] intValue];
		processingSpeed=[[CrushHelper blankIfNull:[scpSection objectForKey:@"PROCESSINGSPEED"]] intValue];
		if (processingSpeed==0)
			processingSpeed=kSortingLineProcessingSpeed;

		dbid=[[scpSection objectForKey:@"ID"] intValue];
		inventoryAdjusted=NO;
		color1=nil;
		color2=nil;
		NSArray *theColors=[colorCoding componentsSeparatedByString:@"-"];
		if ([theColors count]==1)
		{
			self.color1=[CrushHelper getSCPColorFromColorString:[theColors objectAtIndex:0]];
		}
		else {
			self.color1=[CrushHelper getSCPColorFromColorString:[theColors objectAtIndex:0]];
			self.color2=[CrushHelper getSCPColorFromColorString:[theColors objectAtIndex:1]];
		}
		weighTags=[[NSMutableArray alloc] init];

		if ([dictionary objectForKey:@"wt"])
		{
			NSArray *theWTs=[dictionary objectForKey:@"wt"];
			for (NSDictionary *wtDict in theWTs)
			{
				CCWT *wt=[[CCWT alloc] initWithDictionary:wtDict withLot:parentLot];
				[weighTags addObject:wt];
				[wt release];
			}
		}
		actualTons=0;
		
		[scpSection release];
	}
	
	return self;
}

-(id)initWithLot:(CCLot *)forLot
{
	self=[super	initWithLot:forLot];
	dbid=-1;
	vineyard=[[CCVineyard alloc] initWithName:@"Vineyard Name"];
	estTons=[[NSString alloc] initWithString:@""];
	appellation=[[NSString alloc] initWithString: @""];
	varietal=[[NSString alloc] initWithString: @""];
	clone=[[NSString alloc] initWithString: @""];
	varietalType=[[NSString alloc] initWithString:@""];
	colorCoding=[[NSString alloc] initWithString: @""];
	regionCode=[[NSString alloc] initWithString: @""];
	daysInTank=[[NSNumber alloc] initWithInt:0];
	crushing=[[NSString alloc] initWithString: @""];
	specialInstructions=[[NSString alloc] initWithString: @""];
	color1=nil;
	color2=nil;
	actualTons=0;
	sulphurPPM=0;
	weighTags=[[NSMutableArray alloc] init];
	processingSpeed=kSortingLineProcessingSpeed;
	inventoryAdjusted=NO;
	return self;
}

-(float)actualTons
{
	float tons=0;
	for (CCWT* wt in weighTags)
	{
		tons+=[wt totalNetWeight];
	}
	return tons/2000.0;
}

-(float)averageBinWeight
{
	NSInteger binCount=0;
	float glns=0;
	for (CCWT *wt in weighTags)
	{
		binCount+=wt.totalBinCount;
		glns+=wt.totalNetWeight;
	}
	return glns/(float)binCount;
}

-(void)saveWithPushNotification:(BOOL)sendPushNotification
{	
//	if ([self.theID isEqualToString:@"NEW"])
//		self.theID=[super save];
	
	NSString *tp;
	if (tankPosition == CCTankPositionTop)
		tp=[[[NSString alloc] initWithString:@"TOP"] autorelease];
	else 
		tp=[[[NSString alloc] initWithString:@"BOTTOM"] autorelease];

	NSString *hs;
	if (handSorting)
		hs=[[[NSString alloc] initWithString:@"YES"] autorelease];
	else 
		hs=[[[NSString alloc] initWithString:@"NO"] autorelease];

	if (self.colorCoding!=nil) {
		[colorCoding release];
		colorCoding=nil;
	}
	self.colorCoding=[CrushHelper getColorStringFromColor1:color1 andColor2:color2];
	
	NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
						 self.theID,@"WOID",
						 [NSNumber numberWithInt:dbid],@"ID",
						 self.estTons,@"ESTTONS",
						 self.lot,@"LOT",
						 self.vineyard.dbid,@"VINEYARDID",
						 self.clone,@"CLONE",
						 self.varietal,@"VARIETAL",
						 self.daysInTank,@"ESTDAYSINTANK",
						 self.appellation,@"APPELLATION",
						 [[CrushHelper dateFormatSQLStyle] stringFromDate:self.date],@"DELIVERYDATE",
						 [[CrushHelper dateFormatSQLStyle] stringFromDate:self.date],@"DUEDATE",
						 self.clientname,@"CLIENTNAME",
						 self.status,@"STATUS",
						 self.regionCode,@"ZONE",
						 self.crushing,@"CRUSHING",
						 self.specialInstructions,@"SPECIALINSTRUCTIONS",
						 [NSString stringWithFormat:@"%d",(int)([self.wholeClusterPercentage floatValue]*100)],@"WHOLECLUSTER",
						 tp,@"TANKPOSITION",
						 hs,@"HANDSORTING",
						 [[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[NSNumber numberWithInt:self.sulphurPPM]],@"SULPHURPPM",
						 [[CrushHelper numberFormatQtyNoDecimals] stringFromNumber:[NSNumber numberWithInt:self.processingSpeed]],@"PROCESSINGSPEED",
						 self.colorCoding,@"COLORCODE",
						 [CrushHelper yesNoFromBOOL:sendPushNotification],@"sendPushNotification",
						 [CrushHelper devToken],@"devToken",
						 nil] autorelease];
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"update_scp"];
	NSLog(@"%@",[result description]);
	dbid=[[result objectForKey:@"ID"] intValue];
	self.theID=[[result objectForKey:@"WOID"] description];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SCPsaved" object:self];
}

- (void)dealloc {
	[type release];
	[daysInTank release];
	[varietalType release];
	[weighTags release];
	[color1	 release];
	[color2	 release];
    [estTons release];
    [varietal release];
    [appellation release];
    [clone release];
    [regionCode release];
    [specialInstructions release];
    [crushing release];
    [colorCoding release];
    [vineyard release];
    [wholeClusterPercentage release];
    
    [super dealloc];
}


@end

