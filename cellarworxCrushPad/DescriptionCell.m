//
//  DescriptionCell.m
//  CCC2
//
//  Created by Kevin McQuown on 5/18/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "DescriptionCell.h"


@implementation DescriptionCell
@synthesize theDescription;

//- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
//    }
//    return self;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}


- (void)dealloc {
    [theDescription release];
    [super dealloc];
}


@end
