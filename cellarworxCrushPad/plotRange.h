//
//  plotRange.h
//  Crush
//
//  Created by Kevin McQuown on 8/4/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface plotRange : NSObject {

	float location;
	float length;
}
@property (nonatomic) float location;
@property (nonatomic) float length;

-(id) initWithLocation:(float)loc andLength:(float)len;

@end
