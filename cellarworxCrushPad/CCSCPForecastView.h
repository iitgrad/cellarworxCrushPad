//
//  CCSCPForecastView.h
//  Crush
//
//  Created by Kevin McQuown on 9/29/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCAsyncView.h"
//@protocol CCSCPForecastViewDelegate
//
//-(void)viewReadyForDisplay:(UIView *)theView;
//
//@end

@interface CCSCPForecastView : CCAsyncView {

	NSMutableDictionary *whites;
	NSMutableDictionary *reds;
//	id <CCSCPForecastViewDelegate> delegate;
}

//@property (nonatomic, assign) id <CCSCPForecastViewDelegate> delegate;
@property (nonatomic, retain) NSMutableDictionary *whites;
@property (nonatomic, retain) NSMutableDictionary *reds;

@end
