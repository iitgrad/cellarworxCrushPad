//
//  CCValidLabTests.h
//  Crush
//
//  Created by Kevin McQuown on 7/27/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CCValidLabTests : NSObject {
	
//	NSMutableArray *testNames;
	NSMutableDictionary *testData;

}

-(id)init;
-(NSArray *)labTestNames;
-(NSString *)unitsForTest:(NSString *)testname;
-(BOOL)validValue:(float)val forTest:(NSString *)testname;
-(float)minimumValueForTest:(NSString *)testname;
-(float)maximumValueForTest:(NSString *)testname;
-(NSString *)valueFormatForTest:(NSString *)testname;


//@property (nonatomic, retain) NSMutableArray *testNames;
@property (nonatomic, retain) NSMutableDictionary *testData;

@end
