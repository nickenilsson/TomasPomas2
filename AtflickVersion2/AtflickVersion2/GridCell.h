//
//  GridCell.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/7/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
+(UINib *) nib;


@end
