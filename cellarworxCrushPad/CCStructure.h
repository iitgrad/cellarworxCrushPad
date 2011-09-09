//
//  CCStructure.h
//  Crush
//
//  Created by Kevin McQuown on 7/25/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCWT;
@class CCWorkOrder;
@interface CCStructure : NSObject {
	
	NSMutableArray *vineyard;
	NSMutableArray *vineyardGallons;
	NSMutableArray *varietal;
	NSMutableArray *varietalGallons;
	NSMutableArray *appellation;
	NSMutableArray *appellationGallons;
	NSMutableArray *vintage;
	NSMutableArray *vintageGallons;
	NSMutableArray *clone;
	NSMutableArray *cloneGallons;
	NSNumber  *totalGallons;

}
@property (nonatomic, retain) NSMutableArray *vineyard;
@property (nonatomic, retain) NSMutableArray *vineyardGallons;
@property (nonatomic, retain) NSMutableArray *varietal;
@property (nonatomic, retain) NSMutableArray *varietalGallons;
@property (nonatomic, retain) NSMutableArray *appellation;
@property (nonatomic, retain) NSMutableArray *appellationGallons;
@property (nonatomic, retain) NSMutableArray *vintage;
@property (nonatomic, retain) NSMutableArray *vintageGallons;
@property (nonatomic, retain) NSMutableArray *clone;
@property (nonatomic, retain) NSMutableArray *cloneGallons;
@property (nonatomic, retain) NSNumber *totalGallons;

-(id)init;
-(NSString *)description;
-(void) addToStructureFromWT:(CCWT *)theWT;
-(void) addToStructureFromWO:(CCWorkOrder *)theWO;
@end
