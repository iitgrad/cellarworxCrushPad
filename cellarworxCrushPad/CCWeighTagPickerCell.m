//
//  CCWeighTagPickerCell.m
//  Crush
//
//  Created by Kevin McQuown on 7/29/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCWeighTagPickerCell.h"


@implementation CCWeighTagPickerCell
@synthesize number;
@synthesize description;
@synthesize tons;

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
	[number release];
    [description release];
    [tons release];
    [super dealloc];
}


@end
