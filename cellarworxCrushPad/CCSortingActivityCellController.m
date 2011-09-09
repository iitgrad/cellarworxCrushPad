//
//  CCSortingActivityCellControler.m
//  Crush
//
//  Created by Kevin McQuown on 7/20/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCSortingActivityCellController.h"


@implementation CCSortingActivityCellController
@synthesize actionButton;
@synthesize tankList;
@synthesize clientCode;
@synthesize estimatedStartTime;
@synthesize color1;
@synthesize color2;
@synthesize delegate;
@synthesize tons;
@synthesize sulphur;
@synthesize lotDescription;
@synthesize statusLabel;

-(void) buttonClicked:(id)sender
{
	[self.delegate buttonClicked:sender];
}

- (void)dealloc {
    [statusLabel release];
	[lotDescription release];
	[sulphur release];
	[tons release];
	[actionButton release];
	[tankList release];
	[clientCode release];
	[estimatedStartTime release];
	[color1 release];
	[color2	release];
    [super dealloc];
}

@end
