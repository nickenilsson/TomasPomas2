//
//  DropDownMenu.m
//  DropDownNiklas
//
//  Created by Tomas Nilsson on 10/4/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "DropDownMenu.h"
#import <QuartzCore/QuartzCore.h>

#define CELL_SPACING 2
#define DURATION_EXPAND 0.1
#define DURATION_FADE_CELLS 0.1
#define TEXT_COLOR [UIColor whiteColor]
#define FONT @"Avenir"
#define FONT_SIZE 20

@interface DropDownMenu ()

@property (strong, nonatomic) UIView *originalCell;
@property (nonatomic) CGRect baseFrame;
@property (strong, nonatomic) NSArray *selectionOptions;
@property (strong, nonatomic) NSArray *selectionTitles;
@property (strong, nonatomic) NSMutableArray *selectionCells;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic) BOOL menuIsActive;
@property (nonatomic) CGSize cellSize;
@property (nonatomic) BOOL hasLaidOutOnce;
@property (nonatomic) NSInteger selectionIndex;
@property (nonatomic) NSInteger previousSelectionIndex;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation DropDownMenu

-(void) layoutSubviews
{
    if(!self.hasLaidOutOnce){
        [self initialSetup];
        self.hasLaidOutOnce = YES;
    }
    [super layoutSubviews];
}
-(void) initialSetup
{
    self.cellSize = self.frame.size;
    self.baseFrame = self.frame;
    self.menuIsActive = NO;
    self.opaque = NO;
    
    self.layer.cornerRadius = 3;
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHappened:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor blackColor] CGColor];
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self activateMenu];
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self deactivateMenu];
}
-(void) panHappened:(id) sender
{
    // Calculate the selection index
    CGPoint location = [sender locationInView:self];
    
    if ((CGRectContainsPoint(self.bounds, location)) && (location.y > self.baseFrame.size.height)) {
        self.selectionIndex = (location.y - self.baseFrame.size.height) / self.cellSize.height;
    } else {
        self.selectionIndex = NSNotFound;
    }
    if([sender state] == UIGestureRecognizerStateEnded){
        [self deactivateMenu];
        if (self.selectionIndex < [self.selectionOptions count]) {
            NSLog(@"delegate :%@", self.delegate);
            [self.delegate dropDownControlView:self didFinishWithSelection:[self.selectionOptions objectAtIndex:self.selectionIndex]];
        } else {
            [self.delegate dropDownControlView:self didFinishWithSelection:nil];
        }
    }
    
    if (self.selectionIndex == self.previousSelectionIndex){
        return;
    }
    
    
    
    // Selection animation
    if (self.selectionIndex != NSNotFound) {
        UIView *cell = [self.selectionCells objectAtIndex:self.selectionIndex];
        [UIView animateWithDuration:DURATION_EXPAND animations:^{
            cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
            UILabel *title = [cell.subviews objectAtIndex:0];
            title.textColor = [UIColor cyanColor];
            
        }];
    }
    if (self.previousSelectionIndex != NSNotFound) {
        UIView *cell = [self.selectionCells objectAtIndex:self.previousSelectionIndex];
        [UIView animateWithDuration:DURATION_EXPAND animations:^{
            cell.backgroundColor = [UIColor clearColor];
            UILabel *title = [cell.subviews objectAtIndex:0];
            title.textColor = TEXT_COLOR;
        }];
    }
    self.previousSelectionIndex = self.selectionIndex;

}
-(void) setUpDropShadow
{
    self.layer.masksToBounds = NO;
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.layer.shadowOpacity = 0.75f;
    self.layer.shadowRadius = 5.0f;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shouldRasterize = YES;
    
}
-(void) addLabel:(UILabel *)label inCenterOfView:(UIView *) view
{
    [view addSubview:label];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}

- (void)setTitle:(NSString *)title {
    if(self.titleLabel == nil){
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = TEXT_COLOR;
        self.titleLabel.font = [UIFont fontWithName:FONT size:FONT_SIZE];
        [self addLabel:self.titleLabel inCenterOfView:self];
    }
    NSLog(@"%@", title);
    self.titleLabel.text = title;
    [self layoutSubviews];
}

- (void)setSelectionOptions:(NSArray *)selectionOptions withTitles:(NSArray *)selectionOptionTitles {
    if ([selectionOptions count] != [selectionOptionTitles count]) {
        [NSException raise:NSInternalInconsistencyException format:@"selectionOptions and selectionOptionTitles must contain the same number of objects"];
    }
    self.selectionOptions = selectionOptions;
    self.selectionTitles = selectionOptionTitles;
    self.selectionCells = nil;
}
/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] != 1){
        return;
    }
        
    UITouch *touch = [touches anyObject];
    
    // Calculate the selection index
    CGPoint location = [touch locationInView:self];
    if ((CGRectContainsPoint(self.bounds, location)) && (location.y > self.baseFrame.size.height)) {
        self.selectionIndex = (location.y - self.baseFrame.size.height) / self.cellSize.height;
    } else {
        self.selectionIndex = NSNotFound;
    }
    
    if (self.selectionIndex == self.previousSelectionIndex)
        return;
    
    // Selection animation
    if (self.selectionIndex != NSNotFound) {
        UIView *cell = [self.selectionCells objectAtIndex:self.selectionIndex];
        [UIView animateWithDuration:DURATION_EXPAND animations:^{
            cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
            UILabel *title = [cell.subviews objectAtIndex:0];
            title.textColor = [UIColor cyanColor];

        }];
    }
    if (self.previousSelectionIndex != NSNotFound) {
        UIView *cell = [self.selectionCells objectAtIndex:self.previousSelectionIndex];
        [UIView animateWithDuration:DURATION_EXPAND animations:^{
            cell.backgroundColor = [UIColor clearColor];
            UILabel *title = [cell.subviews objectAtIndex:0];
            title.textColor = TEXT_COLOR;
        }];
    }
    self.previousSelectionIndex = self.selectionIndex;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self deactivateMenu];
    if (self.selectionIndex < [self.selectionOptions count]) {
        [self.delegate dropDownControlView:self didFinishWithSelection:[self.selectionOptions objectAtIndex:self.selectionIndex]];
    } else {
        [self.delegate dropDownControlView:self didFinishWithSelection:nil];
    }
    
}
*/

-(void) activateMenu
{
    CGFloat newHeight = (self.selectionTitles.count + 1) * self.cellSize.height;
    CGRect newframe = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeight);
    [UIView animateWithDuration:DURATION_EXPAND delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame = newframe;
    } completion:^(BOOL finished){
        if(finished){
            [self addAndFadeInCells];
        }
    }];
}
-(void) addAndFadeInCells
{
    if (self.selectionCells == nil) {
        self.selectionCells = [NSMutableArray arrayWithCapacity:0];
        UIView *cell;
        for (int i=0; i < [self.selectionTitles count]; i++) {
            cell = [[UIView alloc]init];
            [self addSubview:cell];
            cell.backgroundColor = [UIColor clearColor];
            cell.frame = CGRectMake(0, (i+1)*self.cellSize.height, self.cellSize.width, self.cellSize.height);
            cell.layer.cornerRadius = 5;
            UILabel *title = [[UILabel alloc]init];
            title.text = [self.selectionTitles objectAtIndex:i];
            title.backgroundColor = [UIColor clearColor];
            title.textColor = TEXT_COLOR;
            title.font = [UIFont fontWithName:FONT size:FONT_SIZE];
            [self addLabel:title inCenterOfView:cell];
            cell.alpha = 0.0;
            [self.selectionCells addObject:cell];
        }
    }
    [UIView animateWithDuration:DURATION_FADE_CELLS delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        for (UIView *cell in self.selectionCells) {
            cell.alpha = 1.0;
        }
    } completion:^(BOOL finished){}];
}
-(void) deactivateMenu
{
    [UIView animateWithDuration:DURATION_FADE_CELLS delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        for (UIView *cell in self.selectionCells) {
            cell.alpha = 0;
        }
    } completion:^(BOOL finished){
    }];
    
    [UIView animateWithDuration:DURATION_EXPAND delay:DURATION_FADE_CELLS options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame = self.baseFrame;
        self.menuIsActive = NO;
    } completion:^(BOOL finished){
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
