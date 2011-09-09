//
//  CCAsset.h
//  Crush
//
//  Created by Kevin McQuown on 6/30/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CCAsset : NSObject {

	NSString *name;
	NSString *desc;
	NSNumber *capacity;
	NSString *owner;
	NSString *location;
	NSNumber *cylinderDiameter;
	NSNumber *cylinderHeight;
	NSNumber *capDiameter;
	NSNumber *capHeight;
	NSNumber *coneHeight;
	NSNumber *initialGallons;
	NSString *type;
	NSString *dbid;
	
}
@property (nonatomic, retain) NSNumber *capDiameter;
@property (nonatomic, retain) NSNumber *capHeight;
@property (nonatomic, retain) NSNumber *coneHeight;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSNumber *capacity;
@property (nonatomic, retain) NSNumber *initialGallons;
@property (nonatomic, retain) NSString *owner;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *dbid;
@property (nonatomic, retain) NSNumber *cylinderDiameter;
@property (nonatomic, retain) NSNumber *cylinderHeight;

-(id)initWithDictionary:(NSDictionary *)dictionary;
-(NSString *)description;
//-(float) volumeWithHeight2:(float)height;
//-(float) volumeByDipLength:(float)length;
-(float) gallonsByDipLength:(float)length;
-(float) gallonsByCylinderOnly;

//-(id)initWithName:(NSString *)theName;
@end
