//
//  ListViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/30/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentDisplayView.h"

@interface ListViewController : ContentDisplayView

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
