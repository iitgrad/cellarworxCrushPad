//
//  CCWineStructure.m
//  Crush
//
//  Created by Kevin McQuown on 8/1/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCWineStructure.h"


@implementation CCWineStructure
@synthesize vineyard;
@synthesize varietal;
@synthesize appellation;
@synthesize vintage;

-(id) initWithWineStructure:(CCWineStructure *)theWineStructure
{
	self=[super init];
	vineyard=[theWineStructure.vineyard mutableCopy];
	vintage=[theWineStructure.vintage mutableCopy];
	varietal=[theWineStructure.varietal mutableCopy];
	appellation=[theWineStructure.varietal mutableCopy];
	return self;	
}
-(id) initWithDictionary:(NSDictionary *)dictionary
{
	self=[super init];
	
	if ([[NSNull null] isEqual:dictionary]) {
		return nil;
	}
	vineyard=[[NSMutableArray alloc] init];
	NSDictionary *vineyardDict=[dictionary objectForKey:@"vineyard"];
	NSArray *vineyardKeys=[vineyardDict allKeys];
	for (NSString *theVineyard in vineyardKeys)  {
		NSMutableDictionary *theValue=[[NSMutableDictionary alloc] init];
		[theValue setObject:theVineyard forKey:@"Name"];
		[theValue setObject:[vineyardDict objectForKey:theVineyard] forKey:@"Value"];
		[self.vineyard addObject:theValue];
		[theValue release];
	}
	vintage=[[NSMutableArray alloc] init];
	NSDictionary *vintageDict=[dictionary objectForKey:@"year"];
	NSArray *vintageKeys=[vintageDict allKeys];
	for (NSString *theVintage in vintageKeys)  {
		NSMutableDictionary *theValue=[[NSMutableDictionary alloc] init];
		[theValue setObject:theVintage forKey:@"Name"];
		[theValue setObject:[vintageDict objectForKey:theVintage] forKey:@"Value"];
		[self.vintage addObject:theValue];
		[theValue release];
	}
	varietal=[[NSMutableArray alloc] init];
	NSDictionary *varietalDict=[dictionary objectForKey:@"variety"];
	NSArray *varietalKeys=[varietalDict allKeys];
	for (NSString *theVarietal in varietalKeys)  {
		NSMutableDictionary *theValue=[[NSMutableDictionary alloc] init];
		[theValue setObject:theVarietal forKey:@"Name"];
		[theValue setObject:[varietalDict objectForKey:theVarietal] forKey:@"Value"];
		[self.varietal addObject:theValue];
		[theValue release];
	}
	appellation=[[NSMutableArray alloc] init];
	NSDictionary *appellationDict=[dictionary objectForKey:@"appellation"];
	NSArray *appellationKeys=[appellationDict allKeys];
	for (NSString *theAppellation in appellationKeys)  {
		NSMutableDictionary *theValue=[[NSMutableDictionary alloc] init];
		[theValue setObject:theAppellation forKey:@"Name"];
		[theValue setObject:[appellationDict objectForKey:theAppellation] forKey:@"Value"];
		[self.appellation addObject:theValue];
		[theValue release];
	}
	return self;
}
-(void) dealloc
{
	[vintage release];
	[vineyard release];
	[appellation release];
	[varietal release];
	[super dealloc];
}

@end
