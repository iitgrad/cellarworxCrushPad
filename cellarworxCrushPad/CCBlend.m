//
//  CCBlend.m
//  Crush
//
//  Created by Kevin McQuown on 7/2/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "CCBlend.h"
#import "CrushHelper.h"
#import "CCWorkOrder.h"

@implementation CCBlend
@synthesize sourceLot, gallons, direction, comment, blendID, woID, dbid, endState;

-(id) initWithDictionary:(NSDictionary *)dict
{
	self=[super init];
	sourceLot=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[dict objectForKey:@"SOURCELOT"]]];
	gallons=[[CrushHelper nillIfNull:[dict objectForKey:@"GALLONS"]] floatValue];
	direction=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[dict objectForKey:@"DIRECTION"]]];
	endState=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[dict objectForKey:@"end_state"]]];
	comment=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[dict objectForKey:@"COMMENT"]]];
	blendID=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[dict objectForKey:@"BLENDID"]]];
	woID=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[dict objectForKey:@"WOID"]]];
	dbid=[[NSString alloc] initWithString:[CrushHelper blankIfNull:[dict objectForKey:@"ID"]]];
	return self;
}

-(id) initWithWorkOrder:(CCWorkOrder *)wo
{
	if (self=[super init])
	{
		self.sourceLot=@"";
		self.gallons=0;
		self.direction=@"IN FROM";
		self.comment=@"";
		self.endState=@"";
		self.blendID=@"NEW";
		self.woID=wo.theID;
	}
	return self;
}

-(void)save
{
	NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
						 sourceLot,@"SOURCELOT",
						 [[CrushHelper numberFormatQty] stringFromNumber:[NSNumber numberWithFloat:gallons]],@"GALLONS",
						 direction,@"DIRECTION",
						 comment,@"COMMENT",
						 blendID,@"BLENDID",
						 woID,@"WOID",
						 dbid,@"ID",
						 nil] autorelease];
	NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"update_blend"];
	[blendID release];
	blendID=nil;
	self.blendID=[[result objectForKey:@"BLENDID"]description];
	NSLog(@"%@",[result description]);
	
}
-(void)delete
{
	if (dbid != nil) {
		NSDictionary *dict=[[[NSDictionary alloc] initWithObjectsAndKeys:
							 dbid,@"ID",
							 nil] autorelease];
		NSDictionary *result=[CrushHelper sendPostFromDictionary:dict withAction:@"delete_blend"];
		NSLog(@"%@",[result description]);	
	}
}

- (void) dealloc
{
	[endState release];
    [sourceLot release];
    [direction release];
    [comment release];
    [blendID release];
    [woID release];
    [dbid release];
    [super dealloc];
}

@end
