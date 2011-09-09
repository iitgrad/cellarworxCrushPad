//
//  VineyardListController.h
//  Crush
//
//  Created by Kevin McQuown on 8/9/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCVineyardDetailController.h"

@protocol VineyardListControllerDelegate;


@interface CCVineyardListController : UITableViewController <UITableViewDelegate, CCVineyardDetailControllerDelegate, UITableViewDataSource> {

	NSMutableArray *vydList;
	BOOL picker;
	NSString *theIndex;
	id<VineyardListControllerDelegate> delegate;
	
}
@property (nonatomic, retain) NSMutableArray *vydList;
@property (nonatomic) BOOL picker;
@property (nonatomic, retain) NSString *theIndex;

@property (nonatomic, assign) id<VineyardListControllerDelegate> delegate;

-(id) initAsPicker:(BOOL)pick  withdbid:(NSString *)index;

@end
@protocol VineyardListControllerDelegate

-(void)pickedVineyard:(CCVineyardListController *)controller item:(NSInteger)index;

@end