//
//  testLeaks.h
//  Crush
//
//  Created by Kevin McQuown on 6/23/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface testLeaks : NSObject {
	
	NSMutableArray *myArray;

}
@property (retain) NSMutableArray *myArray;

@end
