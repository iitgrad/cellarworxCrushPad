//
//  TankPicker.h
//  Crush
//
//  Created by Kevin McQuown on 7/7/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCAsset.h"

@class CCWorkOrder;

@protocol TankPickerControllerDelegate;

@interface CCTankPickerController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>{
	
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *capacityLabel;
	IBOutlet UILabel *capacityByTonsLabel;
	IBOutlet UILabel *capacityByBBLSLabel;
	IBOutlet UILabel *locationLabel;
	IBOutlet UILabel *descriptionLabel;
	IBOutlet UILabel *ownerLabel;
	IBOutlet UIButton *chosenButton;
	
	NSMutableArray *byCapacity;
	
	NSMutableArray *column1;
	NSMutableArray *column2;
	CCWorkOrder *workOrder;
	UISegmentedControl *segmentedControl;

	id <TankPickerControllerDelegate> delegate;
	
@private
	IBOutlet UIPickerView  *picker;
	NSMutableArray *tankAssets;
	NSMutableArray *tbinAssets;
	NSMutableArray *portaAssets;
	int assetTypeShowing;
}
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *capacityLabel;
@property (nonatomic, retain) IBOutlet UILabel *capacityByTonsLabel;
@property (nonatomic, retain) IBOutlet UILabel *capacityByBBLSLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *ownerLabel;
@property (nonatomic, retain) UIButton *chosenButton;

@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet NSMutableArray *tankAssets;
@property (nonatomic, retain) IBOutlet NSMutableArray *tbinAssets;
@property (nonatomic, retain) IBOutlet NSMutableArray *portaAssets;
@property (nonatomic, retain) IBOutlet CCWorkOrder *workOrder;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet NSMutableArray *column1;
@property (nonatomic, retain) IBOutlet NSMutableArray *column2;
@property (nonatomic, retain) IBOutlet NSMutableArray *byCapacity;
@property (assign) id <TankPickerControllerDelegate> delegate;


-(id) initWithWO:(CCWorkOrder *)wo;
-(IBAction) tankPicked;

@end

@protocol TankPickerControllerDelegate

-(void) AssetChosen:(CCAsset *)asset;

@end

