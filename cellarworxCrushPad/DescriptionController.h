//
//  DescriptionController.h
//  CCC2
//
//  Created by Kevin McQuown on 5/20/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DescriptionControllerDelegate;

@interface DescriptionController : UIViewController <UITextViewDelegate> {

	IBOutlet UITextView *theTextView;
	IBOutlet UINavigationBar *theBar;
	IBOutlet NSString *fieldName;
	IBOutlet NSString *theText;
	id<DescriptionControllerDelegate> delegate;
	UIBarButtonItem *backButton;
}

@property (nonatomic,retain) UITextView *theTextView;
@property (nonatomic,retain) NSString *theText;
@property (nonatomic,retain) NSString *fieldName;
@property (nonatomic,retain) UINavigationBar *theBar;
@property (nonatomic,retain) UIBarButtonItem *backButton;

@property (assign) id<DescriptionControllerDelegate> delegate;

-(id) initWithDescription:(NSString *)theDesc forField:(NSString *)fn;

@end

@protocol DescriptionControllerDelegate

-(void) ChangedDescription:(DescriptionController *)controller newText:(NSString *)theText forField:(NSString *)field;

@end
