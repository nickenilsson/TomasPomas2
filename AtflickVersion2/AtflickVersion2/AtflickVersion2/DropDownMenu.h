//
//  DropDownMenu.h
//  DropDownNiklas
//
//  Created by Tomas Nilsson on 10/4/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownMenu;

@protocol DropDownMenuDelegate <NSObject>

// Selection contains the user selected option or nil if nothing was selected
- (void)dropDownControlView:(DropDownMenu *)view didFinishWithSelection:(id)selection;

@optional

// You can use this to disable scrolling on a tableView
- (void)dropDownControlViewWillBecomeActive:(DropDownMenu *)view;

@end


@interface DropDownMenu : UIView

- (void)setTitle:(NSString *)title;

- (void)setSelectionOptions:(NSArray *)selectionOptions withTitles:(NSArray *)selectionOptionTitles;

@property (weak, nonatomic) id <DropDownMenuDelegate> delegate;

@end
