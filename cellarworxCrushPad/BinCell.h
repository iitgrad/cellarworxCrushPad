//
//  BinCell.h
//  CCC2
//
//  Created by Kevin McQuown on 5/27/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BinCell : UITableViewCell {

	IBOutlet UILabel *bincount;
	IBOutlet UILabel *weight;
	IBOutlet UILabel *tare;
	IBOutlet UILabel *total;

}
@property (nonatomic, retain) UILabel *bincount;
@property (nonatomic, retain) UILabel *weight;
@property (nonatomic, retain) UILabel *tare;
@property (nonatomic, retain) UILabel *total;

@end
