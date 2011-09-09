//
//  WOFieldsCell.m
//  CCC2
//
//  Created by Kevin McQuown on 5/14/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "WOFieldsCell.h"


@implementation WOFieldsCell
@synthesize leftField,rightField;

//- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
//        // Initialization code
//    }
//    return self;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [leftField release];
    [rightField release];
    
    [super dealloc];
}


@end
