//
//  CCPinController.h
//  Untitled
//
//  Created by Kevin McQuown on 8/7/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCPinControllerDelegate

-(void) secretPicked;

@end

@interface CCPinController : UIViewController {

	IBOutlet UITextField *pinCode;
	id <CCPinControllerDelegate> delegate;
	NSUInteger number;
	
}
@property (nonatomic, retain) IBOutlet UITextField *pinCode;
@property (nonatomic, retain) id <CCPinControllerDelegate> delegate;

-(IBAction) buttonHit:(id)sender;

@end
