//
//  User.h
//  Bubble
//
//  Created by apple on 13-11-7.
//  Copyright (c) 2013年 tyq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * gameScore;
@property (nonatomic, retain) NSDate * gameTime;
@property (nonatomic, retain) NSString * userMail;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userPsd;

@end
