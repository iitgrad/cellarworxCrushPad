//
//  CCAsyncView.h
//  Crush
//
//  Created by Kevin McQuown on 9/30/10.
//  Copyright 2010 Deck 5 Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCSCPForecastViewDelegate

-(void)viewReadyForDisplay:(UIView *)theView;

@end

@interface CCAsyncView : UIView {

	id <CCSCPForecastViewDelegate> delegate;

}

@property (nonatomic, assign) id <CCSCPForecastViewDelegate> delegate;

@end
