//
//  AddToOrSharePopOverViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 25/10/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "AddToOrSharePopOverViewController.h"
#import "NotificationNames.h"

@interface AddToOrSharePopOverViewController ()

- (IBAction)buttonAddToFavouritesTapped:(id)sender;
- (IBAction)buttonAddToPlaylistTapped:(id)sender;
- (IBAction)buttonShareTapped:(id)sender;

@property (strong, nonatomic) id mediaObject;

@end

@implementation AddToOrSharePopOverViewController

-(id)initWithMediaObject:(id) mediaObject
{
    self = [super init];
    if (self) {
        self.mediaObject = mediaObject;
        self.contentSizeForViewInPopover = CGSizeMake(300, 200);
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAddToFavouritesTapped:(id)sender {
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:self.mediaObject forKey:NOTIFICATION_OBJECT];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NOTIFICATION_ADD_MOVIE_TO_FAVOURITES object:self userInfo:userInfo];
    [self.parentPopOverController dismissPopoverAnimated:YES];
}

- (IBAction)buttonAddToPlaylistTapped:(id)sender {
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:self.mediaObject forKey:NOTIFICATION_OBJECT];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:NOTIFICATION_ADD_MOVIE_TO_PLAYLIST object:self userInfo:userInfo];
    [self.parentPopOverController dismissPopoverAnimated:YES];

}

- (IBAction)buttonShareTapped:(id)sender {
}
@end
