//
//  CCSCPController.h
//  Crush
//
//  Created by Kevin McQuown on 6/17/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCSCP.h"
#import "DatePickerController.h"
#import "ChecklistController.h"
//#import "LotTableViewController.h"
#import "TextFieldController.h"
#import "NumberPickerController.h"
#import "DescriptionController.h"
#import "CCVineyardListController.h"
#import "CCSCPColorPickerController.h"
#import "WOPickerController.h"

@interface CCSCPController : UITableViewController <UITableViewDelegate, UITableViewDataSource, datePickerDelegate,
ChecklistControllerDelegate, NumberPickerControllerDelegate, UIPopoverControllerDelegate,
DescriptionControllerDelegate, UISearchBarDelegate, VineyardListControllerDelegate, UIActionSheetDelegate, CCSCPColorPickerControllerDelegate,
WOPickerControllerDelegate> {
	
	CCSCP *scp;
	UIView *colorView1;
    UIView *colorView2;
    UIPopoverController *currentPopOverController;
    NSIndexPath *popOverIndexPath;
    
@private
	BOOL pushOnSave;
	UILabel *titleArea;
	
}
@property (nonatomic, retain) CCSCP *scp;
@property (nonatomic, retain) UILabel *titleArea;
@property (nonatomic, retain) UIView *colorView1;
@property (nonatomic, retain) UIView *colorView2;
@property (nonatomic, retain) UIPopoverController *currentPopOverController;
@property (nonatomic, retain) NSIndexPath *popOverIndexPath;

-(id) initWithSCP:(CCSCP *)theSCP;

@end
