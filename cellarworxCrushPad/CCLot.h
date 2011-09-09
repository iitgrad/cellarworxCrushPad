//
//  CCLot.h
//  Crush
//
//  Created by Kevin McQuown on 6/17/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CCVintage;
@class CCWorkOrder;
@class CCStructure;
@class CCWT;
@class CC702;

@interface CCLot : NSObject {

	NSMutableArray *workOrders;
	NSString *description;
	NSString *lotNumber;
	NSString *dbid;
	
	CCVintage *vintage;
	CCStructure *structure;
	CC702 *the702View;
	
	BOOL retrieved;
	BOOL favorite;
    BOOL active;
	BOOL organic;
	BOOL needsReload;
}

@property (nonatomic, retain) NSMutableArray *workOrders;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *lotNumber;
@property (nonatomic, retain) NSString *dbid;
@property (nonatomic, retain) CCStructure *structure;
@property (nonatomic, retain) CC702 *the702View;

@property (nonatomic, assign) CCVintage *vintage;

@property BOOL retrieved;
@property BOOL favorite;
@property BOOL active;
@property BOOL organic;
@property BOOL needsReload;

-(id)initWithDictionary:(NSDictionary *)dictionary forVintage:(CCVintage *)theVintage;
-(id)initWithLotNumber:(NSString *)lotnumber;

-(BOOL)isDeletable;
-(CCWorkOrder *) previousWorkOrder:(CCWorkOrder *)ofWorkOrder;

-(NSArray *)incomingLots;

-(CCStructure *)getStructureUpToWorkOrder:(CCWorkOrder *)theWO includeWO:(BOOL)inc;

-(id)initWithVintage:(CCVintage *)forVintage;
-(float) gallonsUpToDate:(NSDate *)theDate;
-(float) currentGallons;
-(void) calculateVolumes;
-(void) calculateCosts;
-(void)reSort;
-(NSInteger) getLotNumber;
-(void)updateDetail;
-(void)linkUpSCPsToWeighTags;
-(NSArray *) weightTagsInLot;
+(NSInteger) getVintageYearFromLotNumber:(NSString *)theLotNumber;

-(void)save;

-(NSString *)contentsDescription;

-(CCWorkOrder *)getWorkOrderByID:(NSString *)theID;
-(CCWT *)getWTByID:(NSInteger)theID;

@end
