//
//  CCVesselListSortingLineController.h
//  Crush
//
//  Created by Kevin McQuown on 7/30/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTankLoadingController.h"
#import "CCPinController.h"

@class CCSCP;
@class cellarworxAppDelegate;
@interface CCVesselListSortingLineController : UIViewController <CCTankLoadingControllerDelegate, UITableViewDelegate, UITableViewDataSource,UIPopoverControllerDelegate, CCPinControllerDelegate> {
	
	CCSCP *scp;
	cellarworxAppDelegate *ap;

	UIPopoverController *pinPopOver;

	IBOutlet UITableView *theTableView;
	IBOutlet UIToolbar *theToolBar;
	IBOutlet UIBarButtonItem *disableStaffMode;
}

@property (nonatomic, assign) CCSCP *scp;
@property (nonatomic, assign) cellarworxAppDelegate *ap;
@property (nonatomic, retain) UIPopoverController *pinPopOver;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) IBOutlet UIToolbar *theToolBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *disableStaffMode;
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withVesselList:(CCSCP *)theSCP;
-(IBAction) staffTimeOut;

@end
