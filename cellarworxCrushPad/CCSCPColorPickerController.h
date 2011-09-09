//
//  CCSCPColorPickerController.h
//  Crush
//
//  Created by Kevin McQuown on 7/21/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCSCPColorPickerControllerDelegate

@required
-(void) cancelled:(id) sender;
-(void) colorsChosen:(id) sender;

@end

@interface CCSCPColorPickerController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	
	IBOutlet UIPickerView *colorPicker;
	IBOutlet UISegmentedControl *colorCount;
	id <CCSCPColorPickerControllerDelegate> delegate;
	UIColor *color1;
	UIColor *color2;

}
@property (nonatomic, retain) UIPickerView *colorPicker;
@property (nonatomic, retain) UISegmentedControl *colorCount;
@property (nonatomic, retain) id <CCSCPColorPickerControllerDelegate> delegate;
@property (nonatomic, retain) UIColor *color1;
@property (nonatomic, retain) UIColor *color2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil setColor1:(UIColor *)theColor1 setColor2:(UIColor *)theColor2;
-(IBAction) segmentChanged:(id)sender;
-(IBAction) cancel:(id)sender;
-(IBAction) submit:(id)sender;

@end
