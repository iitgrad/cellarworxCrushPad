//
//  plotRange.m
//  Crush
//
//  Created by Kevin McQuown on 8/4/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "plotRange.h"


@implementation plotRange
@synthesize location;
@synthesize length;

-(id) initWithLocation:(float)loc andLength:(float)len
{
	self=[super init];
	location=loc;
	length=len;
	return self;
}

-(void) dealloc
{
	[super dealloc];
}
@end
