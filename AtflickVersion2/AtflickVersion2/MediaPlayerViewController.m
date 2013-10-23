//
//  MediaPlayerViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/22/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "MediaPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MediaPlayerViewController ()

@property (strong, nonatomic) NSURL *mediaUrl;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;

@end

@implementation MediaPlayerViewController

- (IBAction)buttonPlayTapped:(id)sender {

}

- (IBAction)buttonCloseTapped:(id)sender {
    [self.moviePlayerController stop];
    [self.delegate closeMediaPlayerViewController];
}

- (id)initWithMediaObject:(NSString *) mediaObject
{
    self = [super init];
    if (self) {
        self.mediaUrl = [NSURL URLWithString:mediaObject];        
    }
    return self;
}

-(void)viewWillLayoutSubviews
{
    NSLog(@"viewwilllayoutsubviews");

}
-(void) viewDidLayoutSubviews
{
    
    NSLog(@"viewdidlayoutsubviews");


}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"viewdidload");
    self.activityIndicator.hidesWhenStopped = YES;
    [self.activityIndicator startAnimating];
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    
    dispatch_async(myQueue, ^{
        self.moviePlayerController = [[MPMoviePlayerController alloc] init];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            [self setUpMediaPlayer];

        });
    });
    
}
-(void) setUpMediaPlayer
{
    [self.playerPlaceholder addSubview:self.moviePlayerController.view];
    [self.playerPlaceholder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.moviePlayerController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.playerPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[moviePlayer]|" options:0 metrics:nil views:@{@"moviePlayer": self.moviePlayerController.view}]];
    [self.playerPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[moviePlayer]|" options:0 metrics:nil views:@{@"moviePlayer": self.moviePlayerController.view}]];
    self.moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;

    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue2",NULL);

    dispatch_async(myQueue, ^{
        [self.moviePlayerController setContentURL:self.mediaUrl];

        [self.moviePlayerController play];
    });



}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
