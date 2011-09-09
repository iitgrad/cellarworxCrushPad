//
//  DatePickerController.h
//  CCC2
//
//  Created by Kevin McQuown on 5/16/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol datePickerDelegate;

@interface DatePickerController : UIViewController {

	IBOutlet UIDatePicker *datePicker;
	IBOutlet UISegmentedControl *segment;
	NSDate *currentDate;
	id<datePickerDelegate> delegate;
	IBOutlet UIButton *chosen;
}
@property (nonatomic, retain) IBOutlet UISegmentedControl *segment;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UIButton *chosen;
@property (nonatomic, retain) NSDate *currentDate;
@property (assign) id<datePickerDelegate> delegate;

-(id) initWithDate:(NSDate *)theDate;
-(IBAction) dateSet;

@end
@protocol datePickerDelegate <NSObject>

-(void) datePicked:(DatePickerController *)controller;

@end