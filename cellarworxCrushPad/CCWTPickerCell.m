//
//  CCWTPickerCell.m
//  Crush
//
//  Created by Kevin McQuown on 7/29/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCWTPickerCell.h"


@implementation CCWTPickerCell
@synthesize tons;
@synthesize number;
@synthesize description;

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
	[tons release];
	[number release];
	[description release];
    [super dealloc];
}


@end
