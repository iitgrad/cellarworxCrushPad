//
//  CCSortingActivityCellControler.h
//  Crush
//
//  Created by Kevin McQuown on 7/20/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCSortingActivityCellControllerDelegate

-(void) buttonClicked:(id)sender;

@end

@interface CCSortingActivityCellController : UITableViewCell {

	IBOutlet UIButton *actionButton;
	IBOutlet UILabel *tons;
	IBOutlet UILabel *sulphur;
	IBOutlet UILabel *tankList;
	IBOutlet UILabel *clientCode;
	IBOutlet UILabel *estimatedStartTime;
	IBOutlet UIView	*color1;
	IBOutlet UIView *color2;
	IBOutlet UILabel *lotDescription;
    IBOutlet UILabel *statusLabel;
	id <CCSortingActivityCellControllerDelegate> delegate;
	
}
@property (nonatomic, retain) IBOutlet UIButton *actionButton;
@property (nonatomic, retain) IBOutlet UILabel *tankList;
@property (nonatomic, retain) IBOutlet UILabel *sulphur;
@property (nonatomic, retain) IBOutlet UILabel *tons;
@property (nonatomic, retain) IBOutlet UILabel *clientCode;
@property (nonatomic, retain) IBOutlet UILabel *estimatedStartTime;
@property (nonatomic, retain) IBOutlet UIView *color1;
@property (nonatomic, retain) IBOutlet UIView *color2;
@property (nonatomic, retain) IBOutlet UILabel *lotDescription;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;

@property (nonatomic, retain) 	id <CCSortingActivityCellControllerDelegate> delegate;

-(IBAction) buttonClicked:(id)sender;

@end
