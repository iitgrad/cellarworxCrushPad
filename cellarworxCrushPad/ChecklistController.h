
#import <UIKit/UIKit.h>
#import "CrushHelper.h"

@protocol ChecklistControllerDelegate;

@interface ChecklistController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	NSMutableArray *theList;
//	NSMutableArray *favorites;
	NSIndexPath *lastIndexPath;
	NSString *checkedItem;
	NSString *checkListName;
	BOOL nothingChecked;
	id<ChecklistControllerDelegate> delegate;
}

@property (nonatomic, retain) NSMutableArray *theList;
//@property (nonatomic, retain) NSMutableArray *favorites;
@property (nonatomic, retain) NSIndexPath *lastIndexPath;
@property (nonatomic, retain) NSString *checkedItem;
@property (nonatomic, retain) NSString *checkListName;
@property (assign) id<ChecklistControllerDelegate> delegate;

-(id)initWithListArray:(NSArray *)list withListName:(NSString *)name withChecked:(NSString *)item;
//-(id)initWithList:(NSDictionary *)list withListName:(NSString *)name withChecked:(NSString *)item;
-(id)initWithListName:(NSString *)listName withChecked:(NSString *)item;

@end

@protocol ChecklistControllerDelegate <NSObject>

-(void) PositionChecked:(ChecklistController *)controller checkedItem:(NSString *)item;

@end
