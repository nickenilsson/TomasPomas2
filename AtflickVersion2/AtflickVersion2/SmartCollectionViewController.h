//
//  SmartCollectionViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/3/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentDisplayView.h"

@interface SmartCollectionViewController : ContentDisplayView <UICollectionViewDelegateFlowLayout>

- (IBAction)buttonListTapped:(id)sender;
- (IBAction)buttonGridTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
