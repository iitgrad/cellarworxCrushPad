//
//  CCTankDetailSortingLineCell.m
//  Crush
//
//  Created by Kevin McQuown on 7/30/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCVesselDetailSortingLineCell.h"


@implementation CCVesselDetailSortingLineCell
@synthesize vesselNameLabel;
@synthesize so2Label;
@synthesize binCountLabel;
@synthesize progessStatusLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[vesselNameLabel release];
	[so2Label release];
	[binCountLabel release];
	[progessStatusLabel release];
    [super dealloc];
}


@end
