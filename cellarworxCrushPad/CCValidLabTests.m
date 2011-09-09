//
//  CCValidLabTests.m
//  Crush
//
//  Created by Kevin McQuown on 7/27/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCValidLabTests.h"
#import "CrushHelper.h"

@implementation CCValidLabTests

@synthesize testData;

-(id)init
{
	self=[super init];
	testData=[[NSMutableDictionary alloc] initWithDictionary:[[CrushHelper fetchList:@"LABTESTS" fromTable:@""] objectForKey:@"list"]];
	return self;
}

-(NSArray *)labTestNames
{
	NSArray *theNames=[[[NSArray alloc] initWithArray:[[testData allKeys] sortedArrayUsingSelector:@selector(compare:)]] autorelease];
	return theNames;
}
-(float)minimumValueForTest:(NSString *)testname
{
	return [[[testData objectForKey:testname] objectForKey:@"MIN"] floatValue];
}
-(float)maximumValueForTest:(NSString *)testname
{
	return [[[testData objectForKey:testname] objectForKey:@"MAX"] floatValue];
}
-(NSString *)valueFormatForTest:(NSString *)testname
{
	NSUInteger decimals=[[[testData objectForKey:testname]objectForKey:@"DECIMALPLACES"] intValue];
	NSUInteger digits=[[[testData objectForKey:testname] objectForKey:@"MAX"] length];
	NSString *theFormat=[NSString stringWithFormat:@"%d.%d",digits+decimals,decimals];
	return theFormat;
}
-(BOOL)validValue:(float)val forTest:(NSString *)testname
{
	float min=[self minimumValueForTest:testname];
	float max=[self maximumValueForTest:testname];
	return (val>=min & val<=max);
}

-(NSString *)unitsForTest:(NSString *)testname
{
	if (testname==nil) return @"";
	NSString *units=nil;
	if ([testData objectForKey:testname]!= nil)
		units=[[[NSString alloc] initWithString:[[testData objectForKey:testname] objectForKey:@"UNITS"]] autorelease];
	else 
		units=[[[NSString alloc] initWithString:@""] autorelease];
	return units;
}

-(void) dealloc
{
    [testData release];
    [super dealloc];
}
@end
