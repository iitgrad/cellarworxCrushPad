//
//  CCBOLItem.m
//  Crush
//
//  Created by Kevin McQuown on 6/25/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCBOLItem.h"
#import "CCBOL.h"
#import "CCLot.h"
#import "cellarworxAppDelegate.h"
#import "CrushHelper.h"

@implementation CCBOLItem
@synthesize alcoholLevel;
@synthesize type;
@synthesize gallons;
@synthesize gallonsPerCase;
@synthesize caseCount;
@synthesize qtyType;
@synthesize lot;
@synthesize lotString;
@synthesize bol;
@synthesize palletCount;
@synthesize casesPerPallet;
@synthesize partialPalletCount;
@synthesize bottlesPerCase;

-(id) initWithBOL:(CCBOL *)theBOL
{
	self=[super init];
	self.dbid=-1;
	bol=theBOL;
	gallonsPerCase=2.37754847;
	bottlesPerCase=12;
	if ([bol.endingWineState rangeOfString:@"BOTTLED"].location!=NSNotFound) {
		self.type=@"BOTTLED";
	}
	else if ([bol.endingWineState rangeOfString:@"WINE"].location!=NSNotFound) {
		self.type=@"WINE";
	}
	else {
		self.type=@"JUICE";
	}
	if ([bol.endingWineState rangeOfString:@"ABOVE"].location!=NSNotFound) {
		self.alcoholLevel=@">=14%";
	}
	else {
		self.alcoholLevel=@"<14%";
	}
	return self;
}
-(id) initWithDictionary:(NSDictionary *)dictionary forBOL:(CCBOL *)theBOL
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
	self=[super init];
	dbid=[[dictionary objectForKey:@"ID"] intValue];
	self.alcoholLevel=[dictionary objectForKey:@"ALC"];
	self.type=[dictionary objectForKey:@"TYPE"];
	gallons=[[dictionary objectForKey:@"GALLONS"] floatValue];
	gallonsPerCase=[[dictionary objectForKey:@"GALLONSPERCASE"] floatValue];
	bottlesPerCase=[[dictionary objectForKey:@"BOTTLESPERCASE"] floatValue];
	caseCount=[[dictionary objectForKey:@"CASECOUNT"] intValue];
	casesPerPallet=[[dictionary objectForKey:@"CASESPERPALLET"] intValue];
	palletCount=[[dictionary objectForKey:@"PALLETCOUNT"] floatValue];
	partialPalletCount=[[dictionary objectForKey:@"PARTIALPALLETCASECOUNT"] floatValue];
	lotString=[[NSString alloc] initWithString:[dictionary objectForKey:@"LOT"]];
	lot=[[ap defaultVintage] getLotByNumber:lotString];
	bol=theBOL;
	[ap updateDBWithItem:self];
	return self;
}

-(NSDictionary *)saveDictionary
{
	NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
						 [NSNumber numberWithInt:self.dbid],@"ID",
						 self.type,@"TYPE",
						 self.alcoholLevel,@"ALC",
						 [NSNumber numberWithInt:self.bol.bolid],@"BOLID",
						 self.lotString,@"LOT",
						 self.bol.clientCode,@"CLIENTCODE",
						 [NSNumber numberWithInt:self.bottlesPerCase],@"BOTTLESPERCASE",
						 [NSNumber numberWithFloat:self.gallons],@"GALLONS",
						 [NSNumber numberWithFloat:self.gallonsPerCase],@"GALLONSPERCASE",
						 [NSNumber numberWithInt:self.caseCount],@"CASECOUNT",
						 [NSNumber numberWithInt:self.casesPerPallet],@"CASESPERPALLET",
						 [NSNumber numberWithInt:self.palletCount],@"PALLETCOUNT",
						 [NSNumber numberWithInt:self.partialPalletCount],@"PARTIALPALLETCASECOUNT",
						 nil] autorelease];
	return dict;
}
-(NSString *)save
{	
	NSDictionary *dict=[self saveDictionary];
	
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"update_bolitem"];
	NSLog(@"%@",[result description]);
	self.dbid=[[CrushHelper nillIfNull:[result objectForKey:@"ID"]] intValue];  //json returns nsdecimalnumber which needs to be converted to nsstring
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"workOrderSaved" object:self];
	
	return [CrushHelper nillIfNull:[result objectForKey:@"ID"]];
}
-(void)delete
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (self.dbid>=0)
	{
		NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
							 [NSNumber numberWithInt:self.dbid],@"ID",
							 nil]autorelease];
		NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"delete_bolitem"];
		NSLog(@"%@",[result description]);		
	}
	[ap deleteDBItem:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"workOrderSaved" object:self];
}
-(void) dealloc
{
	[lotString release];
	[alcoholLevel release];
	[type release];
	[qtyType release];
	[super dealloc];
}

@end
