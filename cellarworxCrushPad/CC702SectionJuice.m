//
//  CC702SectionJuice.m
//  Crush
//
//  Created by Kevin McQuown on 6/27/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CC702SectionJuice.h"


@implementation CC702SectionJuice
@synthesize tonsAdded, tonsFermented, totalTonsAdded, totalTonsFermented, inventoryAdjustments, totalInventoryAdjustments;

-(id) init
{
	self=[super init];
	totalTonsAdded=0;
	totalTonsFermented=0;
	totalInventoryAdjustments=0;
	tonsAdded=[[NSMutableArray alloc] init];
	tonsFermented=[[NSMutableArray alloc] init];
	inventoryAdjustments=[[NSMutableArray alloc] init];
	
	return self;
}

-(void) dealloc
{
	[tonsAdded release];
	[tonsFermented release];
	[inventoryAdjustments release];
	[super dealloc];
}
@end
