//
//  testLeaks.m
//  Crush
//
//  Created by Kevin McQuown on 6/23/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "testLeaks.h"


@implementation testLeaks
@synthesize myArray;

-(id) init
{
	self=[super init];
	myArray=[[NSMutableArray alloc] init];
	return self;
}

-(void) dealloc
{
	[myArray release];
	[super dealloc];
}

@end
