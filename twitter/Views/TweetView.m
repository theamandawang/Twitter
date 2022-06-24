//
//  TweetView.m
//  twitter
//
//  Created by Amanda Wang on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetView.h"
#import "APIManager.h"
#import "DateTools.h"
@implementation TweetView
- (IBAction)didTapRetweet:(id)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if(self.tweet.retweeted){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [self refreshData];
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self refreshData];
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
}
- (IBAction)didTapFavorite:(id)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if(self.tweet.favorited){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self refreshData];
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self refreshData];
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}

- (void) refreshData {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.tweetRetweetButton setTitle: [NSString stringWithFormat: @"%d", self.tweet.retweetCount] forState:UIControlStateNormal ];
    [self.tweetFavoriteButton setTitle: [NSString stringWithFormat: @"%d", self.tweet.favoriteCount] forState:UIControlStateNormal ];
    NSString *favoriteImageName = self.tweet.favorited ? @"favor-icon-red.png" : @"favor-icon.png";
    [self.tweetFavoriteButton setImage: [UIImage imageNamed: favoriteImageName] forState:UIControlStateNormal];
    NSString *retweetImageName = self.tweet.retweeted ? @"retweet-icon-green.png" : @"retweet-icon.png";
    [self.tweetRetweetButton setImage: [UIImage imageNamed: retweetImageName] forState:UIControlStateNormal];
}
@end
