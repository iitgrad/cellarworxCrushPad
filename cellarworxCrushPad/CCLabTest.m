//
//  CCLabTest.m
//  Crush
//
//  Created by Kevin McQuown on 6/18/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCLabTest.h"
#import "CrushHelper.h"
#import "CCTest.h"

@implementation CCLabTest

@synthesize lab;
@synthesize tests;
@synthesize wo;
@synthesize referenceNumber;

-(id) initWithDictionary:(NSDictionary *)dictionary withWO:(CCWorkOrder *)thewo
{
	self=[super init];
	lab= [[NSString alloc]initWithString:[CrushHelper blankIfNull:[dictionary  objectForKey:@"lab"]]];
	referenceNumber=[[NSString alloc]initWithString:[CrushHelper blankIfNull:[dictionary objectForKey:@"LABTESTNUMBER"]]];
	tests=[[NSMutableArray alloc] init];
	
	NSArray *theTests=[dictionary objectForKey:@"results"];
	if (![[NSNull null] isEqual:theTests])
	{
		for (NSDictionary *d in theTests)
		{
			CCTest *theTest=[[CCTest alloc] initWithDictionary:d fromLabTest:self];
			[tests addObject:theTest];
			[theTest release];
		}						
	}
	wo=thewo;
	return self;
}
-(id) initWithLabTestForWO:(CCWorkOrder *)thewo
{
	self=[super init];
	lab=[[NSString alloc] initWithString:@""];
	referenceNumber=[[NSString alloc] initWithString:@""];
	if (tests != nil)
		[tests release];
	tests=[[NSMutableArray alloc] init];
	wo=thewo;
	
	return self;
}
-(NSString *) description
{
	NSMutableString *desc=[[[NSMutableString alloc] init] autorelease];
	for (CCTest *aTest in self.tests)	
	{
		[desc appendString:aTest.test];
		[desc appendString:@" - "];
		[desc appendString:[[CrushHelper numberFormatQtyWithDecimals:2] stringFromNumber:[NSNumber numberWithFloat:aTest.value]]];
		[desc appendString:@"\n"];
	}
	return desc;
	
}

-(void) save
{
	
	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:self.lab,@"LAB",
						self.referenceNumber,@"LABTESTNUMBER",
						 self.wo.theID,@"WOID",
						 nil];
	NSLog(@"%@",[[CrushHelper sendPostFromDictionary:dict withAction:@"update_lab"]description]);
	[dict release];
}
- (void)dealloc {
    [tests release];
    [lab release];
    [referenceNumber release];
    [super dealloc];
}
@end

