//
//  plotAttributes.h
//  Crush
//
//  Created by Kevin McQuown on 8/4/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface plotAttributes : NSObject {

	UIColor *color;				// default blue
	float	thickness;			// default 1
	NSUInteger axis;			// Is this on Y axis or Y2 axis

	UIColor *areaColor;			// default blue with alpha .5
	BOOL showAreaUnderCurve;	//default yes
}
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) UIColor *areaColor;
@property (nonatomic) float thickness;
@property (nonatomic) NSUInteger axis;
@property (nonatomic) BOOL showAreaUnderCurve;

@end
