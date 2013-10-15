//
//  MovieDAO.h
//  AtflickVersion2
//
//  Created by Tomas Nilsson on 10/14/13.
//  Copyright (c) 2013 Niklas Nilsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Movie;

@interface MovieDAO : NSObject

+(NSMutableArray *) getRelatedMovies:(Movie *) movie;

+(NSMutableArray *) getHeadliningMovies;
+(NSMutableArray *) getMoviesTest;

@end
