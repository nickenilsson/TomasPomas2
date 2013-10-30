//
//  Actor.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/3/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@interface Actor : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *movies;


@end
