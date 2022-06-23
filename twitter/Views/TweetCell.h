//
//  TweetCell.h
//  twitter
//
//  Created by Amanda Wang on 6/20/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tweetUserLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextTextView;
@property (weak, nonatomic) IBOutlet UILabel *tweetUserHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tweetProfileImageView;
@property (weak, nonatomic) IBOutlet UIButton *tweetReplyButton;
@property (weak, nonatomic) IBOutlet UIButton *tweetRetweetButton;
@property (weak, nonatomic) IBOutlet UIButton *tweetFavoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *tweetMessageButton;
@property (weak, nonatomic) IBOutlet UIImageView *tweetMediaImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweetMediaImageViewHeight;

@property (nonatomic, strong) Tweet *tweet;
@end

NS_ASSUME_NONNULL_END
