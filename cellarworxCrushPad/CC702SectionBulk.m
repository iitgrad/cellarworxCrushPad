//
//  CC702SectionBulk.m
//  Crush
//
//  Created by Kevin McQuown on 6/27/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CC702SectionBulk.h"


@implementation CC702SectionBulk
@synthesize totalFermented;
//@synthesize  totalBulkWineIn;
//@synthesize  totalBulkWineOut;
@synthesize  totalChangeInAlcohol;
@synthesize  totalLossesDueToEvaporation;
@synthesize  totalLossesDueToRacking;
@synthesize  totalLossesDueToDumping;
@synthesize  totalBottled;

@synthesize  fermented;
//@synthesize  bulkWineIn;
//@synthesize  bulkWineOut;
@synthesize  changeInAlcohol;
@synthesize  lossesDueToEvaporation;
@synthesize  lossesDueToRacking;
@synthesize  lossesDueToDumping;
@synthesize  bottled;

- (id) init
{
	self=[super init];
	totalFermented=0;
	totalChangeInAlcohol=0;
	totalLossesDueToEvaporation=0;
	totalLossesDueToRacking=0;
	totalLossesDueToDumping=0;
	totalBottled=0;
	fermented=[[NSMutableArray alloc] init];
	changeInAlcohol=[[NSMutableArray alloc] init];
	lossesDueToEvaporation=[[NSMutableArray alloc] init];
	lossesDueToRacking=[[NSMutableArray alloc] init];
	lossesDueToDumping=[[NSMutableArray alloc] init];
	bottled=[[NSMutableArray alloc] init];
	return self;
}

- (void) dealloc
{
	[fermented release];
	[changeInAlcohol release];
	[lossesDueToDumping release];
	[lossesDueToRacking release];
	[lossesDueToEvaporation release];
	[bottled release];
	[super dealloc];
}
@end
