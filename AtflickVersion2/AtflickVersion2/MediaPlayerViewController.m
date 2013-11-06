//
//  MediaPlayerViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/22/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "MediaPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import "Movie.h"

@interface MediaPlayerViewController ()

@property (strong, nonatomic) Movie *movie;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;

@end

@implementation MediaPlayerViewController

- (IBAction)buttonCloseTapped:(id)sender {
    [self.moviePlayerController stop];
    [self.delegate closeMediaPlayerViewController];
}

- (id)initWithMediaObject:(Movie *) movie
{
    self = [super init];
    if (self) {
        self.movie = movie;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"viewdidload");
    self.activityIndicator.hidesWhenStopped = YES;
    
    /*
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    
    dispatch_async(myQueue, ^{
        self.moviePlayerController = [[MPMoviePlayerController alloc] init];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            [self setUpMediaPlayer];

        });
    });
     */
    [self styleView];
    
}
-(void) styleView
{
    self.view.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.view.layer.shadowOpacity = 1;
    self.view.layer.shadowOffset = CGSizeMake(-1,0 );
    CGRect shadowRect = CGRectInset(self.view.bounds, 0, 2);
    self.view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect]CGPath];
    self.view.layer.shadowRadius = 1;
    self.view.layer.shouldRasterize = YES;
}
-(void) setUpMediaPlayer
{
    [self.playerPlaceholder addSubview:self.moviePlayerController.view];
    [self.playerPlaceholder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.moviePlayerController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.playerPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[moviePlayer]|" options:0 metrics:nil views:@{@"moviePlayer": self.moviePlayerController.view}]];
    [self.playerPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[moviePlayer]|" options:0 metrics:nil views:@{@"moviePlayer": self.moviePlayerController.view}]];
    self.moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
}
-(void) playMediaObject:(Movie *) movie
{
    NSURL *movieUrl = [NSURL URLWithString:movie.urlTrailer];
    if (self.moviePlayerController == nil) {
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue2",NULL);
        dispatch_async(myQueue, ^{
            self.moviePlayerController = [[MPMoviePlayerController alloc] init];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setUpMediaPlayer];
                [self.moviePlayerController setContentURL:movieUrl];
                [self.moviePlayerController play];
            });
        });
    }else{
        [self.moviePlayerController setContentURL:movieUrl];
        [self.moviePlayerController play];
    }
}
-(void) pause
{
    if (self.moviePlayerController.playbackState == MPMoviePlaybackStatePlaying) {
        dispatch_queue_t myQueue = dispatch_queue_create("myQueue", NULL);
        dispatch_async(myQueue, ^{
            [self.moviePlayerController pause];

        });
    }
}
-(void) continuePlaying
{
    if (self.moviePlayerController.playbackState == MPMoviePlaybackStatePaused) {
        dispatch_queue_t myQueue = dispatch_queue_create("myQueue", NULL);
        dispatch_async(myQueue, ^{
            [self.moviePlayerController play];
        });
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
