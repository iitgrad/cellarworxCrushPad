//
//  CCTankLoadingController.h
//  Crush
//
//  Created by Kevin McQuown on 7/28/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCSCP.h"
#import "CCAssetReservation.h"

@protocol CCTankLoadingControllerDelegate

-(void)setBinsInVessel:(NSUInteger)binCount forReservation:(CCAssetReservation *)reservation;

@end

@interface CCTankLoadingController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{

	IBOutlet UIPickerView *picker;
	IBOutlet UILabel *vesselName;
	IBOutlet UILabel *totalWeight;
	IBOutlet UILabel *averageBinWeightLabel;
	IBOutlet UILabel *binCountLabel;
	IBOutlet UILabel *tonsInVessel;
	IBOutlet UILabel *vesselCapacity;
	
	CCSCP *scp;
	CCAssetReservation *reservation;
	
	id <CCTankLoadingControllerDelegate> delegate;
	
	NSUInteger binCount;
	float	 totalTons;
	float averageBinWeight;
@private
	NSUInteger maxBinCount;
	NSUInteger binsUsed;
	
}
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UILabel *vesselName;
@property (nonatomic, retain) IBOutlet UILabel *totalWeight;
@property (nonatomic, retain) IBOutlet UILabel *averageBinWeightLabel;
@property (nonatomic, retain) IBOutlet UILabel *binCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *tonsInVessel;
@property (nonatomic, retain) IBOutlet UILabel *vesselCapacity;

@property (nonatomic, retain) CCSCP *scp;
@property (nonatomic, retain) CCAssetReservation *reservation;

@property (nonatomic, retain) id <CCTankLoadingControllerDelegate> delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil
			   bundle:(NSBundle *)nibBundleOrNil 
			   forSCP:(CCSCP *)theSCP 
	   andReservation:(CCAssetReservation *)theReservation
 binsAlreadyAllocated:(NSUInteger) binsUsed;

-(IBAction) binCountSet:(id)sender;
-(IBAction) cancel:(id)sender;

@end
