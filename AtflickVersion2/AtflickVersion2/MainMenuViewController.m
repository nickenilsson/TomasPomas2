//
//  MainMenuViewController.m
//  VionLabsAtflickVersion1
//
//  Created by Tomas Nilsson on 9/25/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "MainMenuViewController.h"
#import "MainMenuTableViewCell.h"
#import "ArrayDataSource.h"
#import "Colors.h"
#import "Fonts.h"

static NSString * const menuCellIdentifier = @"menuCellIdentifier";

@interface MainMenuViewController ()

@property (nonatomic, strong) ArrayDataSource *menuDataSource;
@property (nonatomic, strong) NSMutableArray *menuItems;

@end

@implementation MainMenuViewController

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
    
    self.menuItems = [[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:@"Movies",@"Favourites",@"Account", nil]];
    [self setUpTableView];
    
    
}
-(void) setUpTableView
{
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[MainMenuTableViewCell nib] forCellReuseIdentifier:menuCellIdentifier];
    CellConfigureBlock cellConfiguration = ^(MainMenuTableViewCell *cell, NSString *item){
        cell.label.textColor = COLOR_MENU_TEXT;
        cell.label.text = item;
        cell.backgroundColor = [UIColor clearColor];
        
        // this is where you set your color view
        UIView *customColorView = [[UIView alloc] init];
        customColorView.backgroundColor = [UIColor blackColor];
        cell.selectedBackgroundView =  customColorView;
    };

    self.menuDataSource = [[ArrayDataSource alloc]initWithItems:self.menuItems cellIdentifier:menuCellIdentifier configureCellBlock:cellConfiguration];
    self.tableView.dataSource = self.menuDataSource;
    self.tableView.separatorColor = COLOR_MENU_SEPARATORS;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate menuItemSelectedWithIndex:indexPath.row];
}

@end
