//
//  VineyardDetail.h
//  Crush
//
//  Created by Kevin McQuown on 8/9/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCVineyardController.h"
#import "TextFieldController.h"
#import "ChecklistController.h"

@class CCVineyard;

@protocol CCVineyardDetailControllerDelegate

@required

- (void) saveVineyard:(CCVineyard *)theVineyard;

@end

@interface CCVineyardDetailController : UIViewController <CCVineyardControllerDelegate, ChecklistControllerDelegate, TextFieldControllerDelegate> {

	CCVineyard *vineyard;
	IBOutlet UITableView *theTable;
	id <CCVineyardDetailControllerDelegate> delegate;

}
@property (nonatomic, retain) CCVineyard *vineyard;
@property (nonatomic, retain) UITableView *theTable;
@property (nonatomic, retain) id <CCVineyardDetailControllerDelegate> delegate;

-(id) initWithVineyard:(CCVineyard *)v;

@end
