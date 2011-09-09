//
//  WOSummaryCell.m
//  CCC2
//
//  Created by Kevin McQuown on 5/9/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "WOSummaryCell.h"
#import "CCActivity.h"
#import "CCWT.h"
#import "CCSCP.h"
#import "CCBOL.h"
#import "CCWorkOrder.h"
#import "cellarworxAppDelegate.h"
#import "CCIcons.h"
//#include <dispatch/dispatch.h>


@implementation WOSummaryCell

@synthesize woType;
@synthesize woStartDate;
@synthesize woEndDate;
@synthesize woDescription;
@synthesize staff;
@synthesize gallons;

@synthesize leftLabel;
@synthesize middleLabel;
@synthesize rightLabel;
@synthesize multiLotLabel;
@synthesize icon;
@synthesize lotNumber;
@synthesize lotDescription;

@synthesize theActivity;

-(void) awakeFromNib
{
	UIFont *myFont=[UIFont systemFontOfSize:10.0];
	woDescription.font=myFont;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTheActivity:(id)act
{
	cellarworxAppDelegate *ap=(cellarworxAppDelegate *)[[UIApplication sharedApplication] delegate];
//	dispatch_queue_t queue;
//	queue=dispatch_queue_create("com.copaincustomcrush.loadData", NULL);
//	dispatch_async(queue, ^{
		if ([[act class] isSubclassOfClass:[CCWT class]])
		{
			icon.image=[[ap icons] getImageByName:@"grapes.png"];
		}
		else if ([[act class] isSubclassOfClass:[CCSCP class]])
		{
			icon.image=[[ap icons] getImageByName:@"scp.png"];
		}
		else if ([[act class] isSubclassOfClass:[CCBOL class]])
		{
			icon.image=[[ap icons] getImageByName:@"bol.png"];
		}
		else if ([[act class] isSubclassOfClass:[CCWorkOrder class]])
		{
			if ([[act theSubType] isEqualToString:@"LAB TEST"])
			{
				icon.image=[[ap icons] getImageByName:@"labTest.png"];
			}
			else if ([[act theSubType] isEqualToString:@"PULL SAMPLE"])
			{
				icon.image=[[ap icons] getImageByName:@"pullSample.png"];
			}
			else if ([[act theSubType] isEqualToString:@"BLENDING"])
			{
				icon.image=[[ap icons] getImageByName:@"blend.png"];
			}
			else if ([[act theSubType] isEqualToString:@"BLEND"])
			{
				icon.image=[[ap icons] getImageByName:@"blend.png"];
			}
			else if ([[act theSubType] isEqualToString:@"BOTTLING"])
			{
				icon.image=[[ap icons] getImageByName:@"bottling.png"];
			}
			else if ([[act theSubType] isEqualToString:@"ADDITION"])
			{
				icon.image=[[ap icons] getImageByName:@"addition.png"];
			}
			else {
				icon.image=[UIImage imageNamed:@"other.png"];
			}
		}
//	});
//	dispatch_release(queue);
	
}

- (void)dealloc {
    [multiLotLabel release];
    [woType release];
    [woStartDate release];
    [woEndDate release];
    [woDescription release];
    [staff release];
    [gallons release];
    [leftLabel release];
    [middleLabel release];
    [rightLabel release];
	[icon release];
    [lotNumber release];
    [lotDescription release];
    
    [super dealloc];
}


@end
