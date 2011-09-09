//
//  CCAsyncView.m
//  Crush
//
//  Created by Kevin McQuown on 9/30/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "CCAsyncView.h"


@implementation CCAsyncView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
