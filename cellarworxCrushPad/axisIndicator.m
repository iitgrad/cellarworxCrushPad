//
//  axisIndicator.m
//  Crush
//
//  Created by Kevin McQuown on 8/26/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import "axisIndicator.h"

#define kAxisTickLength 6
#define kAxisTextLabelWidth 20
#define kAxisTextLabelHeight 15
#define kAxisTextFontSize 12.0
#define kAxisTitleWidth 30
#define kAxisTitleHeight 15

@implementation axisIndicator
@synthesize axisLabel;
@synthesize textColor;

-(id)initWithOrientation:(axisIndicatorOrientation)theOrientation andSize:(CGSize)theSize andTextColor:(UIColor *)theTextColor
{
    if ((self = [super initWithFrame:CGRectZero]))
	{
		self.textColor=theTextColor;
		orientation=theOrientation;
		[self setBackgroundColor:[UIColor clearColor]];
		switch (orientation) {
			case axisIndicatorOrientationLeft:
				self.frame=CGRectMake(0, 0, theSize.width+kAxisTickLength, theSize.height);
				axisLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, theSize.width, theSize.height)];
				[axisLabel setTextAlignment:UITextAlignmentRight];
				break;
			case axisIndicatorOrientationRight:
				self.frame=CGRectMake(0, 0, theSize.width+kAxisTickLength, theSize.height);
				axisLabel=[[UILabel alloc] initWithFrame:CGRectMake(kAxisTickLength, 0, theSize.width, theSize.height)];
				[axisLabel setTextAlignment:UITextAlignmentLeft];
				break;
			case axisIndicatorOrientationBottom:
				self.frame=CGRectMake(0, 0, theSize.width, theSize.height+kAxisTickLength);
				axisLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, kAxisTickLength, theSize.width, theSize.height)];
				[axisLabel setTextAlignment:UITextAlignmentCenter];
				break;
			default:
				break;
		}
		[axisLabel setBackgroundColor:[UIColor clearColor]];
		[axisLabel setTextColor:theTextColor];
		[axisLabel setFont:[UIFont systemFontOfSize:kAxisTextFontSize]];
		[self addSubview:axisLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	CGPoint startPoint=CGPointZero;  //Temporary values to remove warnings if not set.
	CGPoint endPoint=CGPointZero;  //Temporary values to remove warnings if not set.
	
	CGRect axisLabelFrame=axisLabel.frame;
	switch (orientation) {
		case axisIndicatorOrientationLeft:
		{
			startPoint=CGPointMake(axisLabelFrame.origin.x+axisLabelFrame.size.width,
										   axisLabelFrame.origin.y+axisLabelFrame.size.height/2);
			endPoint=CGPointMake(startPoint.x+kAxisTickLength, startPoint.y);
		}
			break;
		case axisIndicatorOrientationRight:
		{
			startPoint=CGPointMake(axisLabelFrame.origin.x,
								   axisLabelFrame.origin.y+axisLabelFrame.size.height/2);
			endPoint=CGPointMake(startPoint.x-kAxisTickLength, axisLabelFrame.origin.y+axisLabelFrame.size.height/2);
		}
			break;
		case axisIndicatorOrientationBottom:
		{
			startPoint=CGPointMake(axisLabelFrame.origin.x+axisLabelFrame.size.width/2,
								   axisLabelFrame.origin.y);
			endPoint=CGPointMake(axisLabelFrame.origin.x+axisLabelFrame.size.width/2, 
								 startPoint.y-kAxisTickLength);
		}
			break;
		default:
			break;
	}
	CGContextRef context= UIGraphicsGetCurrentContext();
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, startPoint.x, startPoint.y);
	CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
	[textColor setStroke];
	CGContextSetLineWidth(context,1);
	CGContextDrawPath(context, kCGPathStroke);
}

- (void)dealloc {
	[textColor release];
	[axisLabel release];
    [super dealloc];
}

@end
