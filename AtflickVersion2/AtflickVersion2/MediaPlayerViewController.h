//
//  MediaPlayerViewController.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/22/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Movie;
@protocol MediaPlayerViewControllerDelegate <NSObject>

-(void) closeMediaPlayerViewController;

@end

@interface MediaPlayerViewController : UIViewController

-(void) pause;
-(void) continuePlaying;

- (IBAction)buttonCloseTapped:(id)sender;
- (id)initWithMediaObject:(Movie *) movie;
-(void) playMediaObject:(Movie *) movie;

@property (weak, nonatomic) id <MediaPlayerViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *playerPlaceholder;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
