//
//  plotAttributes.m
//  Crush
//
//  Created by Kevin McQuown on 8/4/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "plotAttributes.h"


@implementation plotAttributes
@synthesize color;
@synthesize thickness;
@synthesize axis;
@synthesize areaColor;
@synthesize showAreaUnderCurve;

-(id) init
{
	self=[super init];
	self.color=[UIColor blueColor];
	self.areaColor=[self.color colorWithAlphaComponent:.5];
	thickness=1;
	axis=1;
	showAreaUnderCurve=YES;
	return self;
}

-(void)dealloc
{
	[areaColor release];
	[color release];
	[super dealloc];
}
@end
