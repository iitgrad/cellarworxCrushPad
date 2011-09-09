//
//  CCTankCapacityGraphController.h
//  Crush
//
//  Created by Kevin McQuown on 9/14/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "graphViewController.h"

@class plotRange;
@interface CCTankCapacityGraphController : graphViewController {

	NSArray *demand;
	NSArray *capacity;
	NSArray *remainingCapacity;
	
	plotRange *yAxisRange;
	plotRange *xAxisRange;
}
@property (nonatomic, retain) NSArray *demand;
@property (nonatomic, retain) NSArray *capacity;
@property (nonatomic, retain) NSArray *remainingCapacity;
@property (nonatomic, retain) plotRange *yAxisRange;
@property (nonatomic, retain) plotRange *xAxisRange;

-(id) initWithDemand:(NSArray *)theDemand andCapacity:(NSArray *)theCapacity;

@end
