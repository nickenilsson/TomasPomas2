//
//  FilmPopOverViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/7/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Movie;

@interface FilmPopOverViewController : UIViewController

-(id) initWithMovieObject:(Movie *)movie;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *smallLabel;


@end
