//
//  RootViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 9/27/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RootViewController.h"
#import "FilmContentViewController.h"
#import "TvContentViewController.h"
#import "ViewControllerHandler.h"
#import "Colors.h"
#import "InfoViewController.h"
#import "InfoViewAnimationController.h"
#import "MediaPlayerViewController.h"
#import "NotificationNames.h"
#import "Movie.h"


#define ANIMATION_DURATION 0.2
#define SHADOW_FADE_IN_TIME 0.1
#define DURATION_POP_OVER_SLIDE 1
#define DURATION_POP_OVER_FADE_OUT 0.1

@interface RootViewController ()

@property (strong, nonatomic) MainMenuViewController *mainmenuViewController;
@property (strong, nonatomic) ContentViewController *currentContentViewController;
@property (strong, nonatomic) InfoViewAnimationController *popOverController;
@property (strong, nonatomic) MediaPlayerViewController *mediaPlayerViewController;
@property (strong, nonatomic) UIView *shadowView;
@property (nonatomic) CGPoint centerOfScreen;
@property (nonatomic) BOOL menuIsActive;
@property (strong, nonatomic) UIView *popOverPlaceholder;
@property (nonatomic) CGFloat maxPanWidth;
@property (nonatomic) CGFloat maxPanWidthMenu;
@property (nonatomic) BOOL contentWindowIsSmall;
@property (nonatomic) CGFloat widthOfMediaPlayer;
@property (strong, nonatomic) NSLayoutConstraint *contentTrailingConstraint;
@property (strong, nonatomic) NSLayoutConstraint *menuLeadingConstraint;
@property (strong, nonatomic) SaveToPlaylistViewController *saveToPlaylistViewController;
@property (strong, nonatomic) NSLayoutConstraint *saveToPlaylistViewControllerVerticalConstraint;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialSetup];
}

-(void) initialSetup
{
    [self addMainMenu];
    self.mainmenuViewController.view.hidden = YES;
    self.contentWindowIsSmall = NO;
    self.widthOfMediaPlayer = -self.view.frame.size.width/2.5;
    self.maxPanWidth = self.view.bounds.size.width/3;
    self.maxPanWidthMenu = -self.maxPanWidth / 10;
    [self.mainPlaceholder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.topBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.centerOfScreen = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    [self menuItemSelectedWithIndex:0];
    [self registerForNotifications];
    [self setupCGStyling];
}

-(void) setupCGStyling
{

    self.topBar.backgroundColor = COLOR_MAIN_TOP_BAR;
    self.topBar.layer.borderWidth = 1;
    self.topBar.layer.borderColor = [[UIColor blackColor]CGColor];
    self.placeholderForMenu.backgroundColor = COLOR_MAIN_MENU;
    self.mainPlaceholder.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.mainPlaceholder.layer.shadowOffset = CGSizeMake(-1, 0);
    self.mainPlaceholder.layer.shadowOpacity = 1;
    self.mainPlaceholder.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.mainPlaceholder.bounds] CGPath];
    self.mainPlaceholder.layer.shadowRadius = 1;
    self.mainPlaceholder.layer.shouldRasterize = YES;
}
-(void) addMainMenu
{
    if(self.mainmenuViewController == nil){
        self.mainmenuViewController = [[MainMenuViewController alloc]init];
        [self addChildViewController:self.mainmenuViewController];
        [self.mainmenuViewController didMoveToParentViewController:self];
        [self.placeholderForMenu addSubview:self.mainmenuViewController.view];
        self.mainmenuViewController.delegate = (id) self;
        [self setConstraintsForMainMenu];
    }
}
-(void) setConstraintsForMainMenu
{
    [self.placeholderForMenu setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.mainmenuViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.placeholderForMenu addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[menu]|" options:0 metrics:nil views:@{@"menu": self.mainmenuViewController.view}]];
    
    self.menuLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.mainmenuViewController.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.placeholderForMenu attribute:NSLayoutAttributeLeft multiplier:1 constant:self.maxPanWidthMenu];
    [self.placeholderForMenu addConstraint:self.menuLeadingConstraint];
    
    [self.placeholderForMenu addConstraint:[NSLayoutConstraint constraintWithItem:self.mainmenuViewController.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.placeholderForMenu attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view layoutIfNeeded];
    
}
- (IBAction)buttonMenuPressed:(id)sender {
    if(self.menuIsActive){
        [self hideMenuWithAnimation];
    }else{
        [self showMenuWithAnimation];
    }
}

- (IBAction)panGestureHappened:(id)sender
{
    CGPoint translation = [sender translationInView:self.view];
    
    self.mainmenuViewController.view.hidden = NO;
    
    CGFloat newConstantMainPlaceholder = self.placeholderLeadingConstraint.constant + translation.x;
    CGFloat translationXforMenu = translation.x / 10;
    CGFloat newConstantForMenu = self.menuLeadingConstraint.constant + translationXforMenu;
    
    if (newConstantMainPlaceholder > self.maxPanWidth) {
        newConstantMainPlaceholder = self.maxPanWidth;
        newConstantForMenu = 0;
    }else if (newConstantMainPlaceholder < 0){
        newConstantMainPlaceholder = 0;
        newConstantForMenu = self.maxPanWidthMenu;
    }
    self.placeholderLeadingConstraint.constant = newConstantMainPlaceholder;
    self.menuLeadingConstraint.constant = newConstantForMenu;
    
    //Pause media player if off screen.
    if (self.placeholderLeadingConstraint.constant > self.maxPanWidth/2) {
        if (self.mediaPlayerViewController != nil) {
            [self.mediaPlayerViewController pause];
        }
    }else{
        if (self.mediaPlayerViewController != nil) {
            [self.mediaPlayerViewController continuePlaying];
        }
    }
    if ([sender state] == UIGestureRecognizerStateEnded) {
        if (self.placeholderLeadingConstraint.constant > (self.maxPanWidth / 2)) {
            [self showMenuWithAnimation];
        }else{
            [self hideMenuWithAnimation];
        }
    }

    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
}
- (IBAction)swipeGestureRightHappened:(id)sender {
    [self showMenuWithAnimation];
}

- (IBAction)swipeGestureLeftHappened:(id)sender {
    [self hideMenuWithAnimation];
}
-(void) showMenuWithAnimation
{
    self.mainmenuViewController.view.hidden = NO;
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.placeholderLeadingConstraint.constant = self.maxPanWidth;
        self.menuLeadingConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        if (finished) {
            self.menuIsActive = YES;
            if (self.mediaPlayerViewController != nil) {
                [self.mediaPlayerViewController pause];
            }
        }
    }];
}
-(void) hideMenuWithAnimation
{
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.placeholderLeadingConstraint.constant = 0;
        self.menuLeadingConstraint.constant = self.maxPanWidthMenu;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished){
        if (finished) {
            self.menuIsActive = NO;
            self.mainmenuViewController.view.hidden = YES;
            if (self.mediaPlayerViewController != nil) {
                [self.mediaPlayerViewController continuePlaying];
            }
        }
    }];
}

-(void) removeMainMenu
{
    if (self.mainmenuViewController != nil) {
        [self.mainmenuViewController removeFromParentViewController];
        [self.mainmenuViewController.view removeFromSuperview];
        self.mainmenuViewController = nil;
    }
}
-(void) menuItemSelectedWithIndex:(NSUInteger)index
{
    [self removeCurrentContentViewController];
    ContentViewController *viewControllerToAdd = [ViewControllerHandler contentViewControllerCorrespondingToIndex:index];
    [self addContentViewController:viewControllerToAdd];
    [self setFrameForContentViewController];
    [self hideMenuWithAnimation];
    
}
-(void) removeCurrentContentViewController
{
    if(self.currentContentViewController != nil){
        [self.currentContentViewController removeFromParentViewController];
        [self.currentContentViewController.view removeFromSuperview];
        self.currentContentViewController = nil;
    }
}
-(void) addContentViewController:(ContentViewController *) viewController
{
    [self addChildViewController:viewController];
    [viewController didMoveToParentViewController:self];
    [self.contentPlaceholder addSubview:viewController.view];
    viewController.delegate = (id) self;
    self.currentContentViewController = viewController;
    [self.mainPlaceholder sendSubviewToBack:self.contentPlaceholder];
}

-(void)setFrameForContentViewController
{
    [self.currentContentViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[content]|" options:0 metrics:nil views:@{@"content": self.currentContentViewController.view}]];
    
    [self.contentPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:@{@"contentView" : self.currentContentViewController.view}]];
    [self.view layoutIfNeeded];
}
-(void) registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMediaObjectToPlaylist:) name:NOTIFICATION_ADD_MOVIE_TO_PLAYLIST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMediaObjectToFavourites:) name:NOTIFICATION_ADD_MOVIE_TO_FAVOURITES object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMediaObject:) name:PLAY_MEDIA_OBJECT object:nil];
}
-(void) addMediaObjectToPlaylist:(NSNotification *)notification
{
    Movie *movie = [[notification userInfo] valueForKey: NOTIFICATION_OBJECT];
    NSLog(@"Add media object to playlist: %@", movie.title);
    [self addSaveToPlaylistViewController];
    [self setFrameForSaveToPlayListViewController];
    [self animateConstraint:self.saveToPlaylistViewControllerVerticalConstraint toValue:0 duration:ANIMATION_DURATION];
}
-(void) playMediaObject:(NSNotification *) notification
{
    self.mediaPlayerViewController = [[MediaPlayerViewController alloc] init];
    self.mediaPlayerViewController.delegate = (id) self;
    [self addMediaPlayerControllerToView];
    [self setFrameForMediaPlayerViewController];
    [self resizeContentWindowBySettingTrailingConstraintTo:self.widthOfMediaPlayer];
    Movie* movie = (Movie *)[[notification userInfo]valueForKey:NOTIFICATION_OBJECT];
    [self.mediaPlayerViewController playMediaObject:movie];
}
-(void) addMediaPlayerControllerToView
{
    [self addChildViewController:self.mediaPlayerViewController];
    [self.mainPlaceholder addSubview:self.mediaPlayerViewController.view];
    [self.mediaPlayerViewController didMoveToParentViewController:self];
}
-(void) setFrameForMediaPlayerViewController
{
    [self.mediaPlayerViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.mainPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[contentPlaceholder][mediaPlayerViewController]|" options:0 metrics:nil views:@{@"contentPlaceholder": self.contentPlaceholder , @"mediaPlayerViewController": self.mediaPlayerViewController.view}]];
    [self.mainPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topBar][mediaPlayerViewController]|" options:0 metrics:nil views:@{@"topBar": self.topBar , @"mediaPlayerViewController" : self.mediaPlayerViewController.view}]];
    [self.view layoutIfNeeded];
}
-(void) closeMediaPlayerViewController
{
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.contentPlaceholderTrailingConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        if (finished) {
            [self removeMediaPlayerViewControllerFromView];
        }
    }];
}
-(void) removeMediaPlayerViewControllerFromView
{
    [self.mediaPlayerViewController removeFromParentViewController];
    [self.mediaPlayerViewController.view removeFromSuperview];
    self.mediaPlayerViewController = nil;
}

-(void) addSaveToPlaylistViewController
{
    self.saveToPlaylistViewController = [[SaveToPlaylistViewController alloc] init];
    [self addChildViewController:self.saveToPlaylistViewController];
    [self.saveToPlaylistViewController didMoveToParentViewController:self];
    [self.contentPlaceholder addSubview:self.saveToPlaylistViewController.view];
    self.saveToPlaylistViewController.delegate = (id)self;
}
-(void) setFrameForSaveToPlayListViewController
{
    [self.saveToPlaylistViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentPlaceholder addConstraint:[NSLayoutConstraint constraintWithItem:self.saveToPlaylistViewController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentPlaceholder attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.contentPlaceholder addConstraint:[NSLayoutConstraint constraintWithItem:self.saveToPlaylistViewController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentPlaceholder attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [self.contentPlaceholder addConstraint:[NSLayoutConstraint constraintWithItem:self.saveToPlaylistViewController.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentPlaceholder attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    self.saveToPlaylistViewControllerVerticalConstraint = [NSLayoutConstraint constraintWithItem:self.saveToPlaylistViewController.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentPlaceholder attribute:NSLayoutAttributeCenterY multiplier:1 constant:self.contentPlaceholder.frame.size.height];
    
    [self.contentPlaceholder addConstraint:self.saveToPlaylistViewControllerVerticalConstraint];
    [self.view layoutIfNeeded];
}
-(void) closeSaveToPlayListViewController
{
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.saveToPlaylistViewControllerVerticalConstraint.constant = self.contentPlaceholder.frame.size.height;
        [self.view layoutIfNeeded];

    } completion:^(BOOL finished){
        [self.saveToPlaylistViewController removeFromParentViewController];
        [self.saveToPlaylistViewController.view removeFromSuperview];
        self.saveToPlaylistViewController = nil;
    }];
}
-(void) animateConstraint:(NSLayoutConstraint *)constraint toValue:(CGFloat) value duration:(CGFloat) duration
{
    [UIView animateWithDuration:duration animations:^{
        constraint.constant = value;
        [self.view layoutIfNeeded];
    }];
}
-(void) addMediaObjectToFavourites:(NSNotification *)notification
{
    Movie *movie = (Movie *)[[notification userInfo] valueForKey: NOTIFICATION_OBJECT];
    NSLog(@"addMediaObjectToFavourites movie: %@", movie.title);
    
}
// ContentViewControllerDelegate - called from current content view controller
-(void) presentPopOverViewController:(InfoViewController *) viewController
{
    [self addShadowView];
    [self addPopOverController];
    [self setConstraintsForPopOverController];
    [self.popOverController presentNewInfoView:viewController];
}
-(void) addPopOverController
{
    self.popOverController = [[InfoViewAnimationController alloc]init];
    [self.currentContentViewController addChildViewController:self.popOverController];
    [self.popOverController didMoveToParentViewController:self.currentContentViewController];
    self.popOverController.delegate = (id) self;
    [self.currentContentViewController.view addSubview:self.popOverController.view];
    [self.currentContentViewController.view insertSubview:self.shadowView belowSubview:self.popOverController.view];
}
-(void) setConstraintsForPopOverController
{
    [self.popOverController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.currentContentViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[popOverController]|" options:0 metrics:nil views:@{@"popOverController": self.popOverController.view}]];
    [self.currentContentViewController.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[popOverController]|" options:0 metrics:nil views:@{@"popOverController": self.popOverController.view}]];
}
-(void) addShadowView
{
    self.shadowView = [[UIView alloc] init];
    [self.contentPlaceholder addSubview:self.shadowView];
    [self.shadowView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[shadowView]|" options:0 metrics:nil views:@{@"shadowView": self.shadowView}]];
    [self.contentPlaceholder addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[shadowView]|" options:0 metrics:nil views:@{@"shadowView": self.shadowView}]];
    self.shadowView.backgroundColor = [UIColor blackColor];
    self.shadowView.alpha = 0;
    
    [UIView animateWithDuration:SHADOW_FADE_IN_TIME delay:0 options:SHADOW_FADE_IN_TIME animations:^{
        self.shadowView.alpha = 0.7;
    } completion:^(BOOL finished){} ];
}
-(void) removeInfoViewAnimationController
{
    [UIView animateWithDuration:DURATION_POP_OVER_FADE_OUT delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.popOverController.view.alpha = 0;
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished){
        if (finished) {
            [self.popOverController removeFromParentViewController];
            [self.popOverController.view removeFromSuperview];
            self.popOverController = nil;
            [self.shadowView removeFromSuperview];
            self.shadowView = nil;
        }
    }];
    
}
-(void) resizeContentWindowBySettingTrailingConstraintTo:(CGFloat) distance
{
    [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.contentPlaceholderTrailingConstraint.constant = distance;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
