//
//  CCWorkOrder.h
//  Crush
//
//  Created by Kevin McQuown on 6/14/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCActivity.h"
#import "CCAssetReservation.h"

@class CCWT;
@class CCAsset;
@class CCLot;
@class CCLabTest;
@class CCTask;
@class CCWineStructure;

@interface CCWorkOrder : CCActivity {
	
	NSString *clientDescription;
	NSString *typeDescription;
	NSString *clientcode;
	NSString *clientname;
	NSString *clientid;
	NSString *theType;
	NSString *theSubType;
	NSString *startSlot;
	NSString *status;
	NSString *workPerformedBy;
	NSNumber *gallons;
	NSString *theID;
    NSString *taskID;
	NSString *lotNumberString;
	NSString *lotDescriptionString;

	NSString *timeslot;
	NSString *strength;
	NSString *duration;
	NSString *vesseltype;
	NSString *vesselid;
	NSString *dryice;
	
	NSString *toppingLot;
	NSString *so2Add;

	NSNumber *brix;
	NSNumber *temp;
	
	float startingTankGallons;
	float startingToppingGallons;
	float startingBarrelCount;
	float endingTankGallons;
	float endingToppingGallons;
	float endingBarrelCount;
	NSInteger casesBottled;
	float gallonsPerCase;

	CCLabTest *labtest;
	CCTask *task;
//	CCWineStructure *structure;
	
	NSMutableArray *assetReservations;
	NSMutableArray *blends;
	
	NSLock *theLock;
	
	BOOL needsSave;
	
}

@property (nonatomic, retain) NSString *clientDescription;
@property (nonatomic, retain) NSString *typeDescription;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *workPerformedBy;
@property (nonatomic, retain) NSString *clientcode;
@property (nonatomic, retain) NSString *clientname;
@property (nonatomic, retain) NSString *clientid;
@property (nonatomic, retain) NSString *theType;
@property (nonatomic, retain) NSString *startSlot;
@property (nonatomic, retain) NSString *dryice;
@property (nonatomic, retain) NSString *theSubType;
@property (nonatomic, retain) NSNumber *gallons;
@property (nonatomic, retain) NSString *theID;
@property (nonatomic, retain) NSString *taskID;
@property (nonatomic, retain) NSString *lotNumberString;
@property (nonatomic, retain) NSString *lotDescriptionString;
@property (nonatomic, assign) CCTask *task;
@property (nonatomic, retain) NSString *toppingLot;
@property (nonatomic, retain) NSString *so2Add;


//@property (nonatomic, retain) CCWineStructure *structure;

@property (nonatomic, retain) NSString *timeslot;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic, retain) NSString *strength;
@property (nonatomic, retain) NSString *vesselid;
@property (nonatomic, retain) NSString *vesseltype;
@property (nonatomic, retain) NSMutableArray *assetReservations;

@property (nonatomic, retain) NSNumber *brix;
@property (nonatomic, retain) NSNumber *temp;
@property (retain) NSLock *theLock;

@property float startingTankGallons;
@property float startingToppingGallons;
@property float startingBarrelCount;
@property float gallonsPerCase;
@property NSInteger casesBottled;

@property float endingTankGallons;
@property float endingToppingGallons;
@property float endingBarrelCount;

@property (nonatomic, retain) CCLabTest *labtest;

@property (nonatomic, retain) NSMutableArray *blends;
@property (nonatomic) BOOL needsSave;



-(id)initWithDictionary:(NSDictionary *)dictionary withLot:(CCLot *)parentLot;
-(id)initWithLot:(CCLot *)forLot;

-(BOOL)match:(NSString *)s;
-(void)setToCompleteWithSave:(BOOL)s;
-(NSString *)assetListDescription;
-(float) startingVolume;

-(void)delete;

-(NSString *) save;
-(void) addAssetReservation:(CCAssetReservation *)assetReservation;
-(void) deleteAssetReservationByName:(NSString *)assetName;
-(NSString *)assetDescription;

-(NSString *) description;
-(NSDictionary *)saveDictionary;


@end
