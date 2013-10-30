//
//  FilmPopOverViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/7/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoViewController.h"

@class Movie;

@interface FilmInfoViewController : InfoViewController <UICollectionViewDelegateFlowLayout>

-(id) initWithMovieObject:(Movie *)movie;
- (IBAction)trailerButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *smallLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end
