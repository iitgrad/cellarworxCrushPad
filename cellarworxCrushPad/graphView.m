//
//  graphView.m
//  Crush
//
//  Created by Kevin McQuown on 8/2/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "graphView.h"
#import "CrushHelper.h"
#import "plotRange.h"
//#import "plotUtilities.h"
#import "plotAttributes.h"
#import "axisIndicator.h"
#import "QuartzCore/QuartzCore.h"

#define PI 3.14159265358979323846

@implementation graphView
@synthesize plots;
@synthesize xAxisYPosition;
@synthesize delegate;
@synthesize dataSource;
@synthesize yAxisLabels;
@synthesize xAxisLabelValue;
@synthesize yAxisLabelValue;
@synthesize y2AxisLabelValue;
@synthesize axisColor;
@synthesize textAxisColor;
@synthesize backGroundColor;
@synthesize centerX;
@synthesize scaleX;
@synthesize centerY;
@synthesize scaleY;
@synthesize centerY2;
@synthesize scaleY2;
@synthesize xAxisFormatter;
@synthesize yAxisFormatter;
@synthesize y2AxisFormatter;
@synthesize xAxisLabelSize;
@synthesize yAxisLabelSize;
@synthesize xAxisFontSize;
@synthesize yAxisFontSize;
@synthesize xAxisTickLength;
@synthesize yAxisTickLength;
@synthesize xAxisTitleSize;
@synthesize yAxisTitleSize;

-(void)layoutSubviews
{
	[self setNeedsDisplay];
}
-(void)pan:(UIPanGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state==UIGestureRecognizerStateBegan)
	{
		count=1;
		adjustY=YES;
		adjustY2=YES;
		adjustX=YES;
		CGPoint hitPoint=[gestureRecognizer locationInView:self];
		if (hitPoint.x<self.bounds.size.width/5) 
		{
			adjustY2=NO;
			adjustX=NO;
		}
		if (hitPoint.x>self.bounds.size.width-self.bounds.size.width/5) 
		{
			adjustY=NO;
			adjustX=NO;
		}
		if (hitPoint.y>self.bounds.size.height-self.bounds.size.height/5) 
		{
			adjustY=NO;
			adjustY2=NO;
		}
		cX=self.centerX;
		cY=self.centerY;
		cY2=self.centerY2;
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
	{
		count++;
		CGPoint newLoc=[gestureRecognizer translationInView:self];
		if (adjustX) {
			plotRange *pr=[self.delegate rangeOfXAxis];
			float widthPerUnit=self.bounds.size.width/(pr.length/self.scaleX);
			self.centerX=cX-newLoc.x/widthPerUnit;
		}
		if (adjustY)
		{
			plotRange *prY=[self.delegate rangeOfYAxis];
			float heightPerUnit=self.bounds.size.height/(prY.length/self.scaleY);
			self.centerY=cY+newLoc.y/heightPerUnit;			
		}
		if (adjustY2 & [self.delegate twoAxis])
		{
			plotRange *prY2=[self.delegate rangeOfYAxis2];
			float heightPerUnit2=self.bounds.size.height/(prY2.length/self.scaleY2);
			self.centerY2=cY2+newLoc.y/heightPerUnit2;
		}
		
		[self refresh];
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled)
	{
		NSLog(@"updated %d times",count);
	}
}

-(void)handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state==UIGestureRecognizerStateBegan)
	{
		sX=self.scaleX;
		sY=self.scaleY;
		sY2=self.scaleY2;
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
	{
		self.scaleX=sX*gestureRecognizer.scale;
		self.scaleY=sY*gestureRecognizer.scale;
		self.scaleY2=sY2*gestureRecognizer.scale;
		[self refresh];
	}
	else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled)
	{
	}
}
-(void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state==UIGestureRecognizerStateRecognized) {
		[self removeFromSuperview];
	}	
}
-(void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
//	CGPoint tapPoint=[gestureRecognizer locationInView:gestureRecognizer.view];
	if (gestureRecognizer.state==UIGestureRecognizerStateRecognized) {
		self.scaleX=self.scaleX*2.0;
		self.scaleY=self.scaleY*2.0;
		self.scaleY2=self.scaleY2*2.0;
		[self refresh];
	}
}
-(void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer.state==UIGestureRecognizerStateRecognized) {
		self.scaleX=self.scaleX/2.0;
		self.scaleY=self.scaleY/2.0;
		self.scaleY2=self.scaleY2/2.0;
		[self refresh];
	}	
}
-(void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
	[self.delegate closeView];
//	if (gestureRecognizer.state==UIGestureRecognizerStateRecognized) {
//		self.scaleX=1.0;
//		self.scaleY=1.0;
//		self.scaleY2=1.0;
//		self.centerX=[self.delegate rangeOfXAxis].length/2+[self.delegate rangeOfXAxis].location;
//		self.centerY=[self.delegate rangeOfYAxis].length/2+[self.delegate rangeOfYAxis].location;
//		self.centerY2=[self.delegate rangeOfYAxis2].length/2+[self.delegate rangeOfYAxis2].location;
//		[self refresh];
//	}	
}

- (id)initWithFrame:(CGRect)frame
{
	self=[super initWithFrame:frame];
	plots=[[NSMutableArray alloc] init];
	self.backgroundColor=[UIColor clearColor];
	yAxisLabels=[[NSMutableArray alloc] init];
	
	xAxisTickLength=6.0;
	yAxisTickLength=6.0;
	xAxisFontSize=12.0;
	yAxisFontSize=12.0;
	xAxisLabelSize=CGSizeMake(20, 15);
	yAxisLabelSize=CGSizeMake(30, 15);
	xAxisTitleSize=CGSizeMake(30, 15);
	yAxisTitleSize=CGSizeMake(30, 15);
	
//	UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
	
//	UITapGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
//	UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//	UITapGestureRecognizer *doubleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//	UITapGestureRecognizer *twoFingerTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
//	UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
//	[doubleTap setNumberOfTapsRequired:2];
//	[twoFingerTap setNumberOfTouchesRequired:2];
//	[swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
	
//	[self addGestureRecognizer:swipe];
//	[self addGestureRecognizer:panGesture];
//	[self addGestureRecognizer:pinch];
//	[self addGestureRecognizer:singleTap];
//	[self addGestureRecognizer:twoFingerTap];
//	[self addGestureRecognizer:doubleTap];
//	[self addGestureRecognizer:swipe];
	
//	[panGesture release];
//	[pinch release];
//	[singleTap release];
//	[doubleTap release];
//	[twoFingerTap release];
//	[swipe release];
	
	return self;
}

-(plotRange *) xRange
{
	plotRange *range=[self.delegate rangeOfXAxis];
	range.location=centerX-(range.length/scaleX)/2;
	range.length=range.length/scaleX;
	return range;
}
-(plotRange *) yRange
{
	plotRange *range=[self.delegate rangeOfYAxis];
	range.location=centerY-(range.length/scaleY)/2;
	range.length=range.length/scaleY;
	return range;
}
-(plotRange *) y2Range
{
	plotRange *range=[self.delegate rangeOfYAxis2];
	range.location=centerY2-(range.length/scaleY2)/2;
	range.length=range.length/scaleY2;
	return range;
}

-(float) plotXForValue:(float)value forGraph:(graphView *)graph  withXRange:(plotRange *)range
{
	float width;
	if ([self.delegate twoAxis])
		width=[graph bounds].size.width-2*(graph.yAxisLabelSize.width+graph.yAxisTickLength);
	else 
		width=[graph bounds].size.width-(graph.yAxisLabelSize.width+graph.yAxisTickLength);		
	return (width/range.length)*(value-range.location)+(graph.yAxisLabelSize.width+graph.yAxisTickLength);
}
-(float) plotYForValue:(float)value forGraph:(graphView *)graph withYRange:(plotRange *)range
{
	float height=[graph bounds].size.height-(graph.xAxisLabelSize.height+graph.xAxisTickLength+graph.yAxisTitleSize.height);
	return [graph bounds].size.height-((height/range.length)*(value-range.location)+graph.xAxisLabelSize.height+graph.xAxisTickLength);
}
-(float) plotY2ForValue:(float)value forGraph:(graphView *)graph withY2Range:(plotRange *)range
{
	float height=[graph bounds].size.height-(graph.xAxisLabelSize.height+graph.xAxisTickLength+graph.yAxisTitleSize.height);
	return [graph bounds].size.height-((height/range.length)*(value-range.location)+graph.xAxisLabelSize.height+graph.xAxisTickLength);
}

-(float) getYValueForPlotValue:(float)value forGraph:(graphView *)graph withYRange:(plotRange *)range
{
	float height=[graph bounds].size.height-(graph.xAxisLabelSize.height+graph.xAxisTickLength+graph.yAxisTitleSize.height);
	return (value-height)*(-range.length/[graph bounds].size.height)+range.location;
}

-(float) getXValueForPlotValue:(float)value forGraph:(graphView *)graph withXRange:(plotRange *)range
{
	NSInteger multiplier=1;
	if ([self.delegate twoAxis]) {
		multiplier=2;
	}
	float width=[graph bounds].size.width-multiplier*(graph.yAxisLabelSize.width+graph.yAxisTickLength);
	return (value*(range.length/width))+range.location;
}

-(float)plotXForValue:(float)value
{
	return [self plotXForValue:value forGraph:self withXRange:[self xRange]];
}
-(float)plotYForValue:(float)value
{
	return [self plotYForValue:value forGraph:self withYRange:[self yRange]];
}
-(float)plotY2ForValue:(float)value
{
	return [self plotY2ForValue:value forGraph:self withY2Range:[self y2Range]];
}

-(float)getXPositionForYAxis
{
	float x=[self getXValueForPlotValue:yAxisLabelSize.width forGraph:self withXRange:[self xRange]];
	if (x<xAxisYPosition)
		return xAxisYPosition;
	return x;
}

-(void)plotAxis 
{
	CGContextRef context= UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
	
	//Plot X Axis
	float y=xAxisYPosition;
	CGContextMoveToPoint(context, [self plotXForValue:xMin], [self plotYForValue:y]);
	CGContextAddLineToPoint(context, [self plotXForValue:xMax], [self plotYForValue:y]);
	
	//Plot Y Axis
	float x=yAxisLabelSize.width+yAxisTickLength;
	CGContextMoveToPoint(context, x, [self plotYForValue:yMin]);
	CGContextAddLineToPoint(context, x, [self plotYForValue:yMax]);
	
	//Plot Y2 Axis
	if ([self.delegate twoAxis])
	{
		float locx=self.frame.size.width-(yAxisLabelSize.width+yAxisTickLength);
		CGContextMoveToPoint(context, locx, [self plotY2ForValue:y2Min]);
		CGContextAddLineToPoint(context, locx, [self plotY2ForValue:y2Max]);
	}
	
	CGContextSetLineWidth(context, 1.0);
	[self.axisColor setStroke];
	CGContextDrawPath(context, kCGPathStroke);
}
-(void)plotPlotNumber:(int)plotNumber forAxis:(int)axis
{	
	NSArray *points=[plots objectAtIndex:plotNumber];
	if ([points count]==0) return;
	
	plotAttributes *attr=[self.delegate getPlotAttributesForPlot:plotNumber forAxis:axis];
	
	CGContextRef context= UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);

	CGMutablePathRef path = CGPathCreateMutable();
	CGContextBeginPath(context);
	if (axis==0) {
		CGPathMoveToPoint(path,NULL, [self plotXForValue:0],[self plotYForValue:[[points objectAtIndex:0] floatValue]]);
	}
	else {
		CGPathMoveToPoint(path,NULL, [self plotXForValue:0],[self plotY2ForValue:[[points objectAtIndex:0] floatValue]]);
	}
	
	for (int i=1;i<[points count];i++)
	{
		float y=[[points objectAtIndex:i] floatValue];
		if (axis==0) {
			CGPathAddLineToPoint(path, NULL, [self plotXForValue:i], [self plotYForValue:y]);
		}
		else {
			CGPathAddLineToPoint(path,NULL, [self plotXForValue:i], [self plotY2ForValue:y]);
		}
	}
	CGContextAddPath(context, path);
	CGContextSetLineWidth(context, attr.thickness);
	[attr.color setStroke];
	CGContextStrokePath(context);

	CGPathAddLineToPoint(path, NULL, [self plotXForValue:[points count]-1], [self plotYForValue:xAxisYPosition]);
	CGPathAddLineToPoint(path, NULL, [self plotXForValue:0],[self plotYForValue:xAxisYPosition]);
	CGPathCloseSubpath(path);
	CGContextAddPath(context, path);

	if (attr.showAreaUnderCurve==YES)
	{
		CGContextAddPath(context, path);
		[attr.areaColor setFill];
		CGContextFillPath(context); 		
	}
	CGPathRelease(path);
}
- (void)updateYAxisTitle
{
	if (yAxisLabelValue!=nil)
	{
		UILabel *yAxisLabel=[[UILabel alloc] 
							 initWithFrame:CGRectMake(0, 0, yAxisTitleSize.width,yAxisTitleSize.height)];
		[yAxisLabel setTextColor:[self.delegate getPlotAttributesForPlot:0 forAxis:0].color];
		[yAxisLabel setFont:[UIFont systemFontOfSize:12]];
		[yAxisLabel setTextAlignment:UITextAlignmentCenter];
		[yAxisLabel setText:yAxisLabelValue];
		[yAxisLabel setBackgroundColor:[UIColor clearColor]];

		float x=yAxisLabelSize.width+yAxisTickLength;
		float y=yAxisLabel.frame.size.height/2;
		[yAxisLabel setCenter:CGPointMake(x, y)];
		[self addSubview:yAxisLabel];
		[yAxisLabel release];
	}	
}
- (void)updateYAxisLabels
{
	[self updateYAxisTitle];
	
	float height=self.frame.size.height;
	NSInteger majorGridLineCount=(height*.35)/yAxisLabelSize.height+1;
	
	int increment=MAX([self yRange].length/majorGridLineCount,1);
	int end=[self yRange].length+[self yRange].location;
	for (int i=[self yRange].location; i<=end; i+=increment) {
		axisIndicator *axis=[[axisIndicator alloc] initWithOrientation:axisIndicatorOrientationLeft 
															   andSize:yAxisLabelSize 
														  andTextColor:textAxisColor];
		[axis setCenter:CGPointMake((yAxisLabelSize.width+yAxisTickLength)/2, [self plotYForValue:i])];
		[axis.axisLabel setText:[NSString stringWithFormat:@"%d",i]];
		[self addSubview:axis];
		[axis release];
	}
	
}
- (void)updateY2AxisTitle
{
	if (y2AxisLabelValue!=nil)
	{
		UILabel *y2AxisLabel=[[UILabel alloc] 
								initWithFrame:CGRectMake(0, 0, yAxisTitleSize.width, yAxisTitleSize.height)];
		[y2AxisLabel setTextColor:[self.delegate getPlotAttributesForPlot:1 forAxis:1].color];
		[y2AxisLabel setFont:[UIFont systemFontOfSize:12]];
		[y2AxisLabel setTextAlignment:UITextAlignmentCenter];
		[y2AxisLabel setText:y2AxisLabelValue];
		[y2AxisLabel setBackgroundColor:[UIColor clearColor]];
		
		float y=y2AxisLabel.frame.size.height/2;
		float locx=self.frame.size.width-(y2AxisLabel.frame.size.width+yAxisTickLength);
		[y2AxisLabel setCenter:CGPointMake(locx, y)];
		[self addSubview:y2AxisLabel];
		[y2AxisLabel release];
	}	
}
- (void)updateY2AxisLabels
{
	[self updateY2AxisTitle];
	float height=self.frame.size.height;
	NSInteger majorGridLineCount=(height*.35)/yAxisLabelSize.height+1;
	
	int increment=MAX([self y2Range].length/majorGridLineCount,1);
	int end=[self y2Range].length+[self y2Range].location;

	for (int i=[self y2Range].location; i<=end; i+=increment) {
		axisIndicator *axis=[[axisIndicator alloc] initWithOrientation:axisIndicatorOrientationRight andSize:yAxisLabelSize andTextColor:textAxisColor];
		[axis setCenter:CGPointMake(self.frame.size.width-yAxisLabelSize.width/2, [self plotY2ForValue:i])];
		[axis.axisLabel setText:[NSString stringWithFormat:@"%d",i]];
		[self addSubview:axis];
		[axis release];
	}
	
}
- (NSString *)xAxisTextForIndex:(NSInteger)index
{
	if ([[[self.dataSource valueForXPoint:index] class] isSubclassOfClass:[NSNumber class]]) {
		return [xAxisFormatter stringFromNumber:(NSNumber *)[self.dataSource valueForXPoint:index]];
	}
	else {
		return (NSString *)[self.dataSource valueForXPoint:index];
	}
	return @"";
}
- (void)updateXAxisLabels
{
	float width=self.frame.size.width;
	NSInteger majorGridLineCount=(width*.35)/xAxisLabelSize.width+1;

	int increment=MAX([self xRange].length/majorGridLineCount,1);
	int end=[self xRange].length+[self xRange].location;
	for (int i=[self xRange].location; i<=end; i+=increment) {
		axisIndicator *axis=[[axisIndicator alloc] initWithOrientation:axisIndicatorOrientationBottom andSize:xAxisLabelSize andTextColor:textAxisColor];
		[axis setCenter:CGPointMake([self plotXForValue:i], self.bounds.size.height-axis.bounds.size.height/2)];
//		[axis setCenter:CGPointMake([self plotXForValue:i], [self plotYForValue:yMin]+(axis.bounds.size.height/2))];
		[axis.axisLabel setText:[self xAxisTextForIndex:i]];
		[self addSubview:axis];
		[axis release];
	}
}

- (void)drawRect:(CGRect)rect {
	xMin=[self xRange].location;
	xMax=[self xRange].length+xMin;
	yMin=[self yRange].location;
	yMax=[self yRange].length+yMin;
	if ([self.delegate twoAxis]) {
		y2Min=[self y2Range].location;
		y2Max=[self y2Range].length+y2Min;
	}	
	
	// Set up Background
	self.layer.backgroundColor=[backGroundColor CGColor];
	self.layer.cornerRadius=5;
	self.layer.shadowOpacity=.5;
	self.layer.shadowOffset=CGSizeMake(0, 10);
	self.layer.shadowRadius=10;
	CGPathRef shadowPath=[UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
	self.layer.shadowPath=shadowPath;
	
	// Draw plots
	[plots removeAllObjects];
	for (int i=0; i<[self.dataSource numberOfPlotsForAxis:0]; i++) {
		NSMutableArray *aPlot=[[NSMutableArray alloc] init];
		for (int j=0; j<[self.dataSource numberOfPointsForPlot:i forAxis:0];j++)
		{
			[aPlot addObject:[NSNumber numberWithFloat:[self.dataSource pointForXAxis:j andPlotNumber:i forAxis:0]]];
		}
		[plots addObject:aPlot];
		[aPlot release];
	}
	for (int i=0; i<[plots count]; i++) {
		[self plotPlotNumber:i forAxis:0];
	}
	
	if ([self.delegate twoAxis]) {
		[plots removeAllObjects];
		for (int i=0; i<[self.dataSource numberOfPlotsForAxis:1]; i++) {
			NSMutableArray *aPlot=[[NSMutableArray alloc] init];
			for (int j=0; j<[self.dataSource numberOfPointsForPlot:i forAxis:1];j++)
			{
				[aPlot addObject:[NSNumber numberWithFloat:[self.dataSource pointForXAxis:j andPlotNumber:i forAxis:1]]];
			}
			[plots addObject:aPlot];
			[aPlot release];
		}
		for (int i=0; i<[plots count]; i++) {
			[self plotPlotNumber:i forAxis:1];
		}
	}

	// Draw x,y and y2 axis
	[self plotAxis];
	
	// Draw Axis Labels
	for (UIView *view in self.subviews)
	{
		[view removeFromSuperview];
	}
	[self updateYAxisLabels];
	[self updateXAxisLabels];
	if ([self.delegate twoAxis])
	{
		[self updateY2AxisLabels];
	}
}

-(void) refresh
{
	[self setNeedsDisplay];
}

+(plotRange *)calculateRangeOfNumbers:(NSArray *)numbers
{
	if ([numbers count]==0) {
		return nil;
	}
	float maxNumber=[[numbers objectAtIndex:0] floatValue];
	float minNumber=[[numbers objectAtIndex:0] floatValue];
	for (int i=1; i<[numbers count]; i++) {
		if ([[numbers objectAtIndex:i] floatValue]>maxNumber) {
			maxNumber=[[numbers objectAtIndex:i] floatValue];
		}
		if ([[numbers objectAtIndex:i] floatValue]<minNumber) {
			minNumber=[[numbers objectAtIndex:i] floatValue];
		}
	}
	return [[[plotRange alloc] initWithLocation:minNumber andLength:maxNumber-minNumber] autorelease];
}

- (void)dealloc {
	[xAxisFormatter release];
	[yAxisFormatter release];
	[y2AxisFormatter release];
	[backGroundColor release];
	[textAxisColor release];
	[axisColor release];
	[xAxisLabelValue release];
	[yAxisLabelValue release];
	[y2AxisLabelValue release];
	[yAxisLabels release];
	[plots release];
    [super dealloc];
}


@end
