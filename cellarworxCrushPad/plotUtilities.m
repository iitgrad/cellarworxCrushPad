//
//  plotUtilities.m
//  Crush
//
//  Created by Kevin McQuown on 8/4/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "plotUtilities.h"
#import "axisIndicator.h"

@implementation plotUtilities

+(float) plotXForValue:(float)value forGraph:(graphView *)graph  withXRange:(plotRange *)range
{
	float width=[graph bounds].size.width-2*(graph.yAxisLabelSize.width+graph.yAxisTickLength);
	return (width/range.length)*(value-range.location)+(graph.yAxisLabelSize.width+graph.yAxisTickLength);
}
+(float) plotYForValue:(float)value forGraph:(graphView *)graph withYRange:(plotRange *)range
{
	float height=[graph bounds].size.height-(graph.xAxisLabelSize.height+graph.xAxisTickLength+graph.yAxisTitleSize.height);
	return [graph bounds].size.height-((height/range.length)*(value-range.location)+graph.xAxisLabelSize.height+graph.xAxisTickLength);
}
+(float) plotY2ForValue:(float)value forGraph:(graphView *)graph withY2Range:(plotRange *)range
{
	float height=[graph bounds].size.height-(graph.xAxisLabelSize.height+graph.xAxisTickLength+graph.yAxisTitleSize.height);
	return [graph bounds].size.height-((height/range.length)*(value-range.location)+graph.xAxisLabelSize.height+graph.xAxisTickLength);
}

+(float) getXValueForPlotValue:(float)value forGraph:(graphView *)graph withXRange:(plotRange *)range
{
	float width=[graph bounds].size.width-2*(graph.yAxisLabelSize.width+graph.yAxisTickLength);
	return (value*(range.length/width))+range.location;
}
+(float) getYValueForPlotValue:(float)value forGraph:(graphView *)graph withYRange:(plotRange *)range
{
	float height=[graph bounds].size.height-(graph.xAxisLabelSize.height+graph.xAxisTickLength+graph.yAxisTitleSize.height);
	return (value-height)*(-range.length/[graph bounds].size.height)+range.location;
}

@end
