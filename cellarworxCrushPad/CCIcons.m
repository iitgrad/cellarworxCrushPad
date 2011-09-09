//
//  CCIcons.m
//  Crush
//
//  Created by Kevin McQuown on 7/14/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCIcons.h"


@implementation CCIcons
@synthesize theIcons;

-(id)init
{
	self=[super init];
	theIcons=[[NSMutableDictionary alloc] init];
	return self;
}

-(UIImage *)getImageByName:(NSString *)name
{
	if ([theIcons objectForKey:name]==nil)
	{
		[theIcons setObject:[UIImage imageNamed:name] forKey:name];
		return [theIcons objectForKey:name];
	}
	else {
		return [theIcons objectForKey:name];
	}
}

-(void)dealloc
{
	[theIcons release];
	[super dealloc];
}

@end
