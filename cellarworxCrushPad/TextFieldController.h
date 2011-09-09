//
//  TextFieldController.h
//  CCC2
//
//  Created by Kevin McQuown on 5/17/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextFieldControllerDelegate;

@interface TextFieldController : UIViewController {

	IBOutlet UITextField *theTextField;
	id<TextFieldControllerDelegate> delegate;
	NSString *initialText;
	NSString *theFieldName;
	UIKeyboardType theKeyBoardType;
	

}
@property (nonatomic, retain) NSString *initialText;
@property (nonatomic, retain) NSString *theFieldName;
@property (nonatomic, retain) UITextField *theTextField;
@property (assign) id<TextFieldControllerDelegate>delegate;

-(IBAction) commit;

//-(id) initWithInitialText:(NSString *)text forField:(NSString *)fieldName;
- (id)initWithNibName:(NSString *)nibNameOrNil
			   bundle:(NSBundle *)nibBundleOrNil
	  withInitialText:(NSString *)text
			 forField:(NSString *)fn
		 keyBoardType:(UIKeyboardType)kt;

@end

@protocol TextFieldControllerDelegate

-(void) TextEntered:(TextFieldController *)controller forField:(NSString *)fn;

@end

