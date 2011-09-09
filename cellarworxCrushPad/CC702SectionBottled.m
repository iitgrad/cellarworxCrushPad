//
//  CC702SectionBottled.m
//  Crush
//
//  Created by Kevin McQuown on 6/28/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CC702SectionBottled.h"


@implementation CC702SectionBottled
@synthesize totalBottled;
@synthesize bottled;

-(id) init
{
	self=[super init];
	totalBottled=0;
	bottled=[[NSMutableArray alloc] init];
	return self;
}

-(void) dealloc
{
	[bottled release];
	[super dealloc];
}
@end
