//
//  TextFieldController.h
//  CCC2
//
//  Created by Kevin McQuown on 5/17/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeightControllerDelegate;

@interface WeightController : UIViewController {
	
	IBOutlet UITextField *theTextField;
	id<WeightControllerDelegate> delegate;
	NSString *initialText;
	NSString *theFieldName;
	UIKeyboardType theKeyBoardType;
	
	
}
@property (nonatomic, retain) NSString *initialText;
@property (nonatomic, retain) NSString *theFieldName;
@property (nonatomic, retain) UITextField *theTextField;
@property (assign) id<WeightControllerDelegate>delegate;

-(IBAction) commit;

//-(id) initWithInitialText:(NSString *)text forField:(NSString *)fieldName;
- (id)initWithNibName:(NSString *)nibNameOrNil
			   bundle:(NSBundle *)nibBundleOrNil
	  withInitialText:(NSString *)text
			 forField:(NSString *)fn
		 keyBoardType:(UIKeyboardType)kt;

@end

@protocol WeightControllerDelegate

-(void) TextEntered:(WeightController *)controller forField:(NSString *)fn;

@end

