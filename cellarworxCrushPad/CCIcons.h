//
//  CCIcons.h
//  Crush
//
//  Created by Kevin McQuown on 7/14/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CCIcons : NSObject {
	
	NSMutableDictionary *theIcons;

}
@property (nonatomic, retain) NSMutableDictionary *theIcons;

-(UIImage *)getImageByName:(NSString *)name;

@end
