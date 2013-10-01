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
    
    self.menuItems = [[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:@"MenuItem1",@"MenuItem2",@"MenuItem3",@"MenuItem4",@"MenuItem5", nil]];
    [self setUpTableView];
    
}
-(void) setUpTableView
{
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[MainMenuTableViewCell nib] forCellReuseIdentifier:menuCellIdentifier];
    CellConfigureBlock cellConfiguration = ^(MainMenuTableViewCell *cell, NSString *item){
        cell.label.text = item;
    };
    self.menuDataSource = [[ArrayDataSource alloc]initWithItems:self.menuItems cellIdentifier:menuCellIdentifier configureCellBlock:cellConfiguration];
    self.tableView.dataSource = self.menuDataSource;
    
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
