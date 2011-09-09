//
//  BinController.h
//  CCC2
//
//  Created by Kevin McQuown on 5/27/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeightMeasurementController.h"
#import "CCWT.h"

@interface CCBinController : UIViewController <UITableViewDelegate, UITableViewDataSource, WeightMeasurementControllerDelegate> {

	IBOutlet UITableView *binTable;
	CCWT *wt;
	IBOutlet UIToolbar *binToolBar;
	NSInteger weightag;
	NSOperationQueue *queue;
	
}
@property (nonatomic, retain) UITableView *binTable;
@property (nonatomic, retain) CCWT *wt;
@property (nonatomic, retain) UIToolbar *binToolBar;
@property NSInteger weightag;
@property (nonatomic, retain) NSOperationQueue *queue;

-(id) initWithWeighTag:(CCWT *)theWeighTag forWeighTag:(NSInteger)tagId;
//-(IBAction) theWeights;
-(IBAction)addWeight;

@end
