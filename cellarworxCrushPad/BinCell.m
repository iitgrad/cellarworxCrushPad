//
//  BinCell.m
//  CCC2
//
//  Created by Kevin McQuown on 5/27/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import "BinCell.h"

@implementation BinCell
@synthesize bincount, weight, tare, total;

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
    [bincount release];
    [weight release];
    [tare release];
    [total release];
    
    [super dealloc];
}


@end
