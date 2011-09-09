//
//  graphView.h
//  Crush
//
//  Created by Kevin McQuown on 8/2/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class plotAttributes;
@class plotRange;

@protocol graphViewDelegate

@required
-(BOOL) twoAxis;

@optional
-(void) closeView;
-(plotAttributes *)getPlotAttributesForPlot:(int)plotNumber forAxis:(int)axisNumber;
-(plotRange *)rangeOfXAxis;
-(plotRange *)rangeOfYAxis;
-(plotRange *)rangeOfYAxis2;
@end

@protocol graphViewDataSource

@required
-(NSUInteger)numberOfPlotsForAxis:(int)axisNumber;

@optional
-(float) pointForXAxis:(NSInteger)x andPlotNumber:(NSInteger)plotNumber forAxis:(int)axisNumber;
-(id) valueForXPoint:(NSInteger)x;
-(NSUInteger)numberOfPointsForPlot:(int)plotNumber forAxis:(int)axisNumber;

@end

@interface graphView : UIView  <UIGestureRecognizerDelegate>{

	NSString *xAxisLabelValue;
	NSString *yAxisLabelValue;
	NSString *y2AxisLabelValue;
	float xAxisYPosition;

	// Axis configuration Items
	CGSize xAxisLabelSize;
	CGSize yAxisLabelSize;
	CGSize xAxisTitleSize;
	CGSize yAxisTitleSize;

	float xAxisFontSize;
	float yAxisFontSize;
	float xAxisTickLength;
	float yAxisTickLength;
	
	
	UIColor *axisColor;
	UIColor *textAxisColor;
	NSNumberFormatter *xAxisFormatter;
	NSNumberFormatter *yAxisFormatter;
	NSNumberFormatter *y2AxisFormatter;
	
	// Graph configuration items
	UIColor *backGroundColor;
	
	//Scaling
	float centerX;
	float scaleX;
	float centerY;
	float scaleY;
	float centerY2;
	float scaleY2;
	
	NSInteger count;
@private
	NSMutableArray *plots;

	id <graphViewDelegate> delegate;
	id <graphViewDataSource> dataSource;

@private
	float xMin, xMax, yMin, yMax, y2Min, y2Max;
	float sX,sY,sY2,cX,cY,cY2;
	BOOL adjustY, adjustY2, adjustX;
	NSMutableArray *yAxisLabels;
}
//@property (nonatomic, retain) graph *theGraph;
@property (nonatomic, retain) NSString *xAxisLabelValue;
@property (nonatomic, retain) NSString *yAxisLabelValue;
@property (nonatomic, retain) NSString *y2AxisLabelValue;
@property (nonatomic, retain) NSMutableArray *plots;
@property (nonatomic, retain) NSMutableArray *yAxisLabels;
@property (nonatomic) float xAxisYPosition;
@property (nonatomic, retain) UIColor *axisColor;
@property (nonatomic, retain) UIColor *textAxisColor;
@property (nonatomic, retain) UIColor *backGroundColor;

@property (nonatomic, retain) NSNumberFormatter *xAxisFormatter;
@property (nonatomic, retain) NSNumberFormatter *yAxisFormatter;
@property (nonatomic, retain) NSNumberFormatter *y2AxisFormatter;


@property (nonatomic) float centerX;
@property (nonatomic) float scaleX;
@property (nonatomic) float centerY;
@property (nonatomic) float scaleY;
@property (nonatomic) float centerY2;
@property (nonatomic) float scaleY2;

@property (nonatomic) CGSize xAxisLabelSize;
@property (nonatomic) CGSize yAxisLabelSize;
@property (nonatomic) CGSize xAxisTitleSize;
@property (nonatomic) CGSize yAxisTitleSize;
@property (nonatomic) float xAxisFontSize;
@property (nonatomic) float yAxisFontSize;
@property (nonatomic) float xAxisTickLength;
@property (nonatomic) float yAxisTickLength;


@property (nonatomic, assign) id <graphViewDelegate> delegate;
@property (nonatomic, assign) id <graphViewDataSource> dataSource;

-(void) refresh;
+(plotRange *)calculateRangeOfNumbers:(NSArray *)numbers;

@end
