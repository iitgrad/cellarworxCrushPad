//
//  CCTest.m
//  Crush
//
//  Created by Kevin McQuown on 6/27/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCTest.h"
#import "CrushHelper.h"
#import "CCWorkOrder.h"
#import "CCLabTest.h"
#import "CCValidLabTests.h"
#import "CCLot.h"
#import "CCVintage.h"
#import "CCValidLabTests.h"

@implementation CCTest

@synthesize test, units, value, dbid, labTest;

-(id)initWithDictionary:(NSDictionary *)dict fromLabTest:(CCLabTest *)lt
{
	if (self=[super init])
	{
		test=[[NSString alloc] initWithString:[dict objectForKey:@"LABTEST"]];
		value=[[dict objectForKey:@"VALUE1"] floatValue];
		units=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[dict objectForKey:@"UNITS"]]];
		dbid=[[NSString alloc] initWithString:[dict objectForKey:@"ID"]];
		labTest=lt;
	}
	return self;
}
-(CCTest *)initWithLabTest:(CCLabTest *)lt 
{
	if (self=[super init])
	{
		self.test=@"Pick A Test";
		value=0.0;
		self.units=@"Units";
		self.dbid=@"NEW";
		self.labTest=lt;
	}
	return self;
}
-(NSString *)unitsDescription
{
	if (labTest.wo.inLot==nil)
		return @"";
	else 
		return [labTest.wo.inLot.vintage.validLabTests unitsForTest:test];
}
-(NSString *)formatDescription
{
	return [labTest.wo.inLot.vintage.validLabTests valueFormatForTest:test];
}
-(BOOL)inRange;
{
	return [labTest.wo.inLot.vintage.validLabTests validValue:value forTest:test];
}
-(float)minimumValue
{
	return [labTest.wo.inLot.vintage.validLabTests minimumValueForTest:test];
}
-(float)maximumValue
{
	return [labTest.wo.inLot.vintage.validLabTests maximumValueForTest:test];
}
-(void) save
{
	NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:test,@"LABTEST",
						 [NSNumber numberWithFloat:value],@"VALUE1",
						 units,@"UNITS1",
						 labTest.wo.theID,@"WOID",
						 dbid,@"ID",
						 nil] autorelease];
	NSLog(@"%@",[[CrushHelper sendPostFromDictionary:dict withAction:@"update_labtest"]description]);
	
}
-(void) delete
{
	NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:dbid,@"ID",
						 nil] autorelease];
	NSLog(@"%@",[[CrushHelper sendPostFromDictionary:dict withAction:@"delete_labtest"]description]);
	
}

-(NSString *) description
{
	return [NSString stringWithFormat:@"%@ - %4.2f",test,[test floatValue]];
}

- (void) dealloc
{
	[test release];
	[units release];
	[dbid release];
	[super dealloc];
}
@end
