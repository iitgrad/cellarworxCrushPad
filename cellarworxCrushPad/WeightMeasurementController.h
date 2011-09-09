//
//  WeightMeasurementController.h
//  CCC2
//
//  Created by Kevin McQuown on 5/29/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberPickerController.h"
#import "WeightController.h"
#import "TextFieldController.h"
#import "CCWeight.h"

@protocol WeightMeasurementControllerDelegate;

@interface WeightMeasurementController : UIViewController <UITableViewDelegate, UITableViewDataSource, WeightControllerDelegate, TextFieldControllerDelegate, NumberPickerControllerDelegate> {

	IBOutlet UITableView *weightMeasurementTable;
	CCWeight *measurement;
	NSUInteger measurementNumber;
	NSArray *controllers;
	
	id<WeightMeasurementControllerDelegate> delegate;
}

@property (nonatomic, retain) UITableView *weightMeasurementTable;
@property (nonatomic, retain) CCWeight *measurement;
@property (nonatomic, retain) NSArray *controllers;

@property (assign) id<WeightMeasurementControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
			 withData:(CCWeight *)measurementData
  ofMeasurementNumber:(NSUInteger)num;

@end

@protocol WeightMeasurementControllerDelegate

-(void) updateWeighMeasurement:(CCWeight *)measurement ofMeasurementNumber:(NSUInteger)num;

@end
