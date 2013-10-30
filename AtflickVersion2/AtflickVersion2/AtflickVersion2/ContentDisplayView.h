//
//  ContentDisplayView.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/1/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentDisplayViewDelegate <NSObject>

@optional
-(void) objectSelectedInDisplayView:(id) object;

@end

@interface ContentDisplayView : UIViewController

@property (weak, nonatomic) id <ContentDisplayViewDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *items;

-(void) setWidth:(CGFloat) width;

@end
