//
//  NumberPickerController.h
//  CCC2
//
//  Created by Kevin McQuown on 5/16/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberPickerControllerDelegate;

@interface NumberPickerController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {

	IBOutlet UIPickerView *myPicker;
	id<NumberPickerControllerDelegate> delegate;
	float start;
	float end;
	float increment;
	float currentValue;
	float pickerWidth;
	NSString *fieldName;
	NSString *stringFormat;
	
	IBOutlet UIButton *chosenButton;
	
	NSNumberFormatter *theFormat;
}

@property (nonatomic, retain) UIPickerView *myPicker;
@property (nonatomic, retain) NSString *fieldName;
@property (nonatomic, retain) NSString *stringFormat;
@property (nonatomic, retain) NSNumberFormatter *theFormat;
@property (nonatomic, retain) UIButton *chosenButton;

@property (assign) id<NumberPickerControllerDelegate> delegate;

-(id) initWithInitialValue:(float)initValue useIncrement:(float)inc  beginningValue:(float)bv endingValue:(float)ev forField:(NSString *)fn withFormat:(NSString *)format widthOfPicker:(NSUInteger)thePickerWidth;

-(IBAction) setPressed;

@end

@protocol NumberPickerControllerDelegate

-(void) NumberPicked:(NumberPickerController *)thePicker withValue:(float)value forField:(NSString *)fieldName;

@end

