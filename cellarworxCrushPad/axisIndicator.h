//
//  axisIndicator.h
//  Crush
//
//  Created by Kevin McQuown on 8/26/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    axisIndicatorOrientationLeft = 0,
    axisIndicatorOrientationRight,
    axisIndicatorOrientationBottom,
	axisIndicatorOrientationTop
} axisIndicatorOrientation;

@interface axisIndicator : UIView {
	
	UILabel *axisLabel;
	UILabel *axisTitleLabel;
	UIColor *textColor;
	axisIndicatorOrientation orientation;
}
@property (nonatomic, retain) UILabel *axisLabel;
@property (nonatomic, retain) UIColor *textColor;

-(id)initWithOrientation:(axisIndicatorOrientation)theOrientation andSize:(CGSize)theSize andTextColor:(UIColor *)theTextColor;

@end
