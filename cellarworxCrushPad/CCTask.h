//
//  CCTask.h
//  Crush
//
//  Created by Kevin McQuown on 7/2/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCWorkOrder;
@interface CCTask : NSObject {

    NSMutableSet *workOrders;
	NSString *type;
	NSString *workPerfomedBy;
	NSDate *startDate;
	NSDate *endDate;
    int dbid;
}
@property (retain) NSMutableSet *workOrders;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *workPerfomedBy;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property int dbid;

-(id) initWithWorkOrder:(CCWorkOrder *)theWorkOrder;
-(id) initWithDictionary:(NSDictionary *)dict;
-(NSArray *)vintages;  // Returns a list of vintages from the work order list
-(NSArray *)unLoadedVintages;

-(void)save;
-(void)delete;

@end
