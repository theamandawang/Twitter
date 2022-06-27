//
//  TweetCell.h
//  twitter
//
//  Created by Amanda Wang on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TweetView.h"
NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet TweetView *tweetView;
@end

NS_ASSUME_NONNULL_END
