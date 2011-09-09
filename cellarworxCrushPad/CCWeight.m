//
//  CCWeights.m
//  Crush
//
//  Created by Kevin McQuown on 6/18/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCWeight.h"
#import "CrushHelper.h"


@implementation CCWeight
@synthesize bincount;
@synthesize weight;
@synthesize tare;
@synthesize misc;
@synthesize dbid;
@synthesize netWeight;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
	self=[super init];
	bincount=[[dictionary objectForKey:@"BINCOUNT"] intValue];
	weight=[[dictionary objectForKey:@"WEIGHT"] intValue];
	tare=[[dictionary objectForKey:@"TARE"] intValue];
	self.misc=[dictionary objectForKey:@"MISC"];
	dbid=[[dictionary objectForKey:@"ID"] intValue];

	return self;
}
-(id)initWithMeasurementForWT:(NSInteger)wtid theBinCount:(int)newBinCount theWeight:(int)newWeight theTare:(int)newTare;
{
	self=[super init];
	bincount=newBinCount;
	weight=newWeight;
	tare=newTare;
	self.misc=@"";
	
	NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:bincount],@"BINCOUNT",
						 [NSNumber numberWithInt:weight],@"WEIGHT",
						 [NSNumber numberWithInt:tare],@"TARE",
						 misc,@"MISC",
						 [NSString stringWithFormat:@"%d",wtid],@"WEIGHTAG",
						 nil] autorelease];
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"add_bindetail"];	
	dbid=[[result objectForKey:@"ID"] intValue];
	
	NSLog(@"%@",result);
	
	return self;
}


-(NSInteger)netWeight
{
	return weight-tare;
}

-(NSString *)description
{
	return [NSString stringWithFormat:@"Bincount: %6.3f",self.bincount];
}

#pragma mark Database Operations

-(void)save
{
	NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",bincount],@"BINCOUNT",
						 [NSString stringWithFormat:@"%d",weight],@"WEIGHT",
						 [NSString stringWithFormat:@"%d",tare],@"TARE",
						 misc,@"MISC",
						 [NSString stringWithFormat:@"%d",dbid],@"ID",
						 nil];
	NSLog(@"%@",[[CrushHelper sendPostFromDictionary:dict withAction:@"update_bindetail"]description]);
	[dict release];
}
-(void)delete
{
	NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:dbid],@"ID",
						 nil] autorelease];
	NSLog(@"%@",[[CrushHelper sendPostFromDictionary:dict withAction:@"delete_bindetail"]description]);	
}

-(void) dealloc
{
    [misc release];
    [super dealloc];
}

@end
