//
//  WTSummaryCellController.h
//  CCC2
//
//  Created by Kevin McQuown on 5/28/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WTSummaryCellController : UITableViewCell {
	
	IBOutlet UILabel *gross;
	IBOutlet UILabel *net;
	IBOutlet UILabel *tare;	
	IBOutlet UILabel *tons;
	IBOutlet UILabel *bincount;
	IBOutlet UILabel *averageWeightPerBin;
	
	NSInteger grossWeight;
	NSInteger netWeight;
	NSInteger tareWeight;
	float totalTons;
	NSInteger totalBinCount;

}

@property (nonatomic, retain) UILabel *gross;
@property (nonatomic, retain) UILabel *net;
@property (nonatomic, retain) UILabel *tare;
@property (nonatomic, retain) UILabel *tons;
@property (nonatomic, retain) UILabel *bincount;
@property (nonatomic, retain) UILabel *averageWeightPerBin;

@property NSInteger grossWeight;
@property NSInteger netWeight;
@property NSInteger tareWeight;
@property float totalTons;
@property NSInteger totalBinCount;

@end
