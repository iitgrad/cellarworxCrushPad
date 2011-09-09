//
//  CCAssetReservation.h
//  Crush
//
//  Created by Kevin McQuown on 7/27/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCAsset;
@class CCWorkOrder;
@interface CCAssetReservation : NSObject {
	
	NSInteger dbid;
	CCAsset *asset;
	float tonsInVessel;
	CCWorkOrder *wo;
	NSUInteger binCount;

}
@property (nonatomic) NSInteger dbid;
@property (nonatomic, retain) CCAsset *asset;
@property (nonatomic, assign) CCWorkOrder *wo;
@property (nonatomic) float tonsInVessel;
@property (nonatomic) NSUInteger binCount;

-(id) initWithWO:(CCWorkOrder *)theWO withAsset:(CCAsset *)theAsset;
-(id) initWithDictionary:(NSDictionary *)dictionary forWO:(CCWorkOrder *)theWO;

-(void) save;

@end
