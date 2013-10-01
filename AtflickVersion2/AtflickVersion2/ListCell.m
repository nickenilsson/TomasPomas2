//
//  ListCell.m
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/1/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

+(UINib *) nib
{
    return [UINib nibWithNibName:@"ListCell" bundle:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
