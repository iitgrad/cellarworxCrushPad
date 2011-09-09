//
//  CCSortingTableScheduleController.h
//  Crush
//
//  Created by Kevin McQuown on 7/19/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCSortingActivityCellController.h"
#import "CCPinController.h"
//#import "CCTankForecastView.h"
#import "CCSCPForecastView.h"
//#import "PickCustomerVintageController.h"
@class cellarworxAppDelegate;
@class CCVesselListSortingLineController;
@interface CCSortingTableScheduleController : UIViewController <CCSortingActivityCellControllerDelegate, CCPinControllerDelegate,  UIGestureRecognizerDelegate, UIPopoverControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate,
CCSCPForecastViewDelegate> {

	cellarworxAppDelegate *ap;
	NSTimer *timer;
	NSTimer *dataViewTimer;
 	UIPopoverController *pinPopOver;
	IBOutlet UILabel *statusLabel;

	IBOutlet UITableView *theTableView;
	IBOutlet UIToolbar *theToolBar;
	IBOutlet UIBarButtonItem *disableStaffMode;
	
	CCVesselListSortingLineController *vesselList;
	NSIndexPath *chosenSCP;
	
	UIViewController *dataViewController;

	UIView *currentView; // This view holds the currently visible report view
	UIView *nextView;   // This view holds the view ready to be made the currentview and added to the view hierarchy once the timer goes off
	UIView *tempView;  // This view holds the start of a view but generation is not complete.  Once completed, it moves from here to nextView
	NSInteger reportNumber;
}

@property (nonatomic, retain) UIView *tempView;
@property (nonatomic, retain) UIView *nextView;
@property (nonatomic, retain) UIView *currentView;
@property (nonatomic, retain) NSTimer *dataViewTimer;
@property (nonatomic, retain) UIViewController *dataViewController;

@property (nonatomic, retain) CCVesselListSortingLineController *vesselList;
@property (nonatomic, retain) NSIndexPath *chosenSCP;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) UIPopoverController *pinPopOver;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) IBOutlet UIToolbar *theToolBar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *disableStaffMode;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void)refreshTable:(id)sender;
-(IBAction) staffTimeOut;
-(IBAction) generateReport;
@end
