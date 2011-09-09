//
//  WOFieldsCell.h
//  CCC2
//
//  Created by Kevin McQuown on 5/14/09.
//  Copyright 2009 Copain Wines Cellars. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WOFieldsCell : UITableViewCell {
	
	IBOutlet UILabel *leftField;
	IBOutlet UILabel *rightField;

}

@property (nonatomic, retain) UILabel *leftField;
@property (nonatomic, retain) UILabel *rightField;

@end
