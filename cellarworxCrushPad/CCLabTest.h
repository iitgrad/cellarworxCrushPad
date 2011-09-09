//
//  CCLabTest.h
//  Crush
//
//  Created by Kevin McQuown on 6/18/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCWorkOrder.h"

@class CCLot;
@class CCWorkOrder;

@interface CCLabTest : NSObject {

	NSMutableArray *tests;
	NSString *lab;
	NSString *referenceNumber;
	CCWorkOrder *wo;
		
}
@property (nonatomic, retain) NSMutableArray *tests;
@property (nonatomic, retain) NSString *lab;
@property (nonatomic, retain) NSString *referenceNumber;

@property (nonatomic, assign) CCWorkOrder *wo;

-(id) initWithDictionary:(NSDictionary *)dictionary withWO:(CCWorkOrder *)thewo;
-(id) initWithLabTestForWO:(CCWorkOrder *)thewo;

-(void) save;

@end
