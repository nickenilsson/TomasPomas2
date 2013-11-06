//
//  SaveToPlaylistViewController.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 25/10/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "SaveToPlaylistViewController.h"
#import "Colors.h"

@interface SaveToPlaylistViewController ()

@property (strong, nonatomic) NSMutableArray *tableViewItems;

@end

@implementation SaveToPlaylistViewController

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
    // Do any additional setup after loading the view from its nib.
    [self createDataForTableView];
    self.tableView.dataSource = (id)self;
    self.tableView.delegate = (id)self;
    self.view.backgroundColor = COLOR_MAIN_MENU;
    self.tableView.separatorColor = COLOR_MENU_SEPARATORS;;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
}
-(void) createDataForTableView
{
    self.tableViewItems = [NSMutableArray arrayWithObjects:@"Playlist1",@"Playlist2",@"Playlist3",@"Playlist4",@"Playlist5",@"Playlist6",@"Playlist7",@"Playlist8", nil];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewItems.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textColor = COLOR_MENU_TEXT;
    cell.textLabel.text = [self.tableViewItems objectAtIndex:indexPath.item];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate closeSaveToPlayListViewController];
}

@end
