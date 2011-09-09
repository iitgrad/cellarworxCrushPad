//
//  CC702CoreSection.h
//  Crush
//
//  Created by Kevin McQuown on 6/27/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CC702Section : NSObject {
	BOOL above14;
	float startingGallons;
	float endingGallons;
	float totalBolOutTaxPaid;
	float totalBolOutBondToBond;
	float totalBolIn;
	float totalBlending;
	NSMutableArray *bolOutTaxPaid;
	NSMutableArray *bolOutBondToBond;
	NSMutableArray *bolIn;
	NSMutableArray *blending;
}

@property float totalBolOutTaxPaid;
@property float totalBolOutBondToBond;
@property float totalBolIn;
@property float startingGallons;
@property float endingGallons;
@property float totalBlending;
@property BOOL above14;
@property (retain) NSMutableArray *bolOutTaxPaid;
@property (retain) NSMutableArray *bolOutBondToBond;
@property (retain) NSMutableArray *bolIn;
@property (retain) NSMutableArray *blending;

-(id) init;

@end
