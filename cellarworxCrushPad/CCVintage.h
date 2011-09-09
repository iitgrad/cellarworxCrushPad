//
//  CCVintage.h
//  Crush
//
//  Created by Kevin McQuown on 7/3/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CCLot;
@class CCValidLabTests;
@class CCClient;

@interface CCVintage : NSObject {

	NSMutableArray *lots;
	NSMutableArray *favoriteLots;
	NSMutableArray *nonFavoriteLots;
    NSMutableArray *activeLots;
    NSMutableArray *inActiveLots;
	CCClient *client;
	
	int year;
	
	CCValidLabTests *validLabTests;
	
	NSLock *theLock;
	int requestsReceived;
	int maxRequestsOutstanding;

}
@property (nonatomic, retain) NSMutableArray *lots;
@property (nonatomic, retain) NSMutableArray *favoriteLots;
@property (nonatomic, retain) NSMutableArray *activeLots;
@property (nonatomic, retain) NSMutableArray *inActiveLots;
@property (nonatomic, retain) NSMutableArray *nonFavoriteLots;
@property (nonatomic, retain) CCClient *client;
@property int year;
@property (nonatomic, retain) CCValidLabTests *validLabTests;
@property (nonatomic, retain) NSLock *theLock;
@property int requestsReceived;
@property int maxRequestsOutstanding;

-(id) initWithClient:(CCClient *)theClient andVintageYear:(int)vintage withDetail:(BOOL)detail;
//-(id) initWithLot:(NSString *)lot withDetail:(BOOL)detail;

//-(void) updateWithDetail:(NSString *)lotNumber;
-(void) updateWithDetail:(CCLot *)lot;
-(NSArray *)lotsWithDetail;

-(void)reSort;
-(CCLot *)getLotByNumber:(NSString *)lotNumber;
-(void)toggleFavoriteOnLot:(CCLot *)l;
-(void)addLot:(CCLot *)theLot;
-(void)removeLot:(CCLot *)theLot;

-(void)updateFavorites;
-(void)refreshLotCategories;

-(void)incrementRequestsReceived;
-(void)decrementRequestsReceived;
-(int)numberRetrieved:(NSArray *)theLots;

-(void)changeActiveStatusOnLot:(CCLot *)lot;

@end
