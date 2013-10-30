//
//  MainMenuTableViewCell.h
//  VionLabsAtflickVersion1
//
//  Created by Tomas Nilsson on 9/24/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

+(UINib*) nib;


@end
