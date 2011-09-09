//
//  CCTankCapacityView.h
//  Crush
//
//  Created by Kevin McQuown on 9/30/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "graphView.h"
#import "CCAsyncView.h"

//@protocol CCSCPForecastViewDelegate
//
//-(void)viewReadyForDisplay:(UIView *)theView;
//
//@end

@class CCTankCapacityGraphController;
@class plotRange;
@interface CCTankCapacityView : CCAsyncView <graphViewDelegate, graphViewDataSource> {

//	id <CCSCPForecastViewDelegate> delegate;
	NSMutableArray *demandPool;
	NSMutableArray *capacityPool;
	NSMutableDictionary *tankPool;
	NSMutableDictionary *scpPool;
	
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

//@property (nonatomic, assign) id <CCSCPForecastViewDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *demandPool;
@property (nonatomic, retain) NSMutableArray *capacityPool;
@property (nonatomic, retain) NSMutableDictionary *tankPool;
@property (nonatomic, retain) NSMutableDictionary *scpPool;

@end
