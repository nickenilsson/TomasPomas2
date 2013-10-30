//
//  BigBannerCell.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/30/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigBannerCell : UICollectionViewCell

+(UINib *) nib;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
