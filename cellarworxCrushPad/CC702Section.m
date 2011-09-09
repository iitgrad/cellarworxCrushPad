//
//  CC702CoreSection.m
//  Crush
//
//  Created by Kevin McQuown on 6/27/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CC702Section.h"


@implementation CC702Section
@synthesize startingGallons;
@synthesize endingGallons;
@synthesize above14;
@synthesize bolOutTaxPaid;
@synthesize bolOutBondToBond;
@synthesize bolIn;
@synthesize totalBolOutTaxPaid;
@synthesize totalBolOutBondToBond;
@synthesize totalBolIn;
@synthesize blending;
@synthesize totalBlending;

-(id) init
{
	self=[super init];
	startingGallons=0;
	endingGallons=0;
	above14=NO;
	bolOutTaxPaid=[[NSMutableArray alloc] init];
	bolOutBondToBond=[[NSMutableArray alloc] init];
	bolIn=[[NSMutableArray alloc] init];
	blending=[[NSMutableArray alloc] init];
	return self;
}

-(void) dealloc
{
	[bolOutTaxPaid release];
	[bolOutBondToBond release];
	[bolIn release];
	[super dealloc];
}

@end
