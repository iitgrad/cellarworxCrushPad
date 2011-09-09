//
//  plotUtilities.h
//  Crush
//
//  Created by Kevin McQuown on 8/4/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "plotRange.h"
#import "graphView.h"

@interface plotUtilities : NSObject {
	
}
+(float) plotXForValue:(float)value forGraph:(graphView *)graph withXRange:(plotRange *)range;
+(float) plotYForValue:(float)value forGraph:(graphView *)graph withYRange:(plotRange *)range;
+(float) plotY2ForValue:(float)value forGraph:(graphView *)graph withY2Range:(plotRange *)range;

+(float) getXValueForPlotValue:(float)value forGraph:(graphView *)graph withXRange:(plotRange *)range;
+(float) getYValueForPlotValue:(float)value forGraph:(graphView *)graph withYRange:(plotRange *)range;

//+(float) plotXForValue:(float)value referenceView:(UIView *)ref withXRange:(plotRange *)range;
//+(float) plotYForValue:(float)value referenceView:(UIView *)ref withYRange:(plotRange *)range;
//+(float) plotY2ForValue:(float)value referenceView:(UIView *)ref withY2Range:(plotRange *)range;
//
//+(float) getXValueForPlotValue:(float)value referenceView:(UIView *)ref withXRange:(plotRange *)range;
//+(float) getYValueForPlotValue:(float)value referenceView:(UIView *)ref withYRange:(plotRange *)range;
@end
