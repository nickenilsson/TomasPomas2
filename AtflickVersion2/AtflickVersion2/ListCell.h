//
//  ListCell.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/7/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UICollectionViewCell

+(UINib *)nib;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *bigLabel;

@end
