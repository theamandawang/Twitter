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
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshData];
}
- (IBAction)didTapFavorite:(id)sender {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if(self.tweet.favorited){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
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
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshData];
}

- (void) refreshData {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.tweetTextTextView.text = self.tweet.text;
    self.tweetUserLabel.text = self.tweet.user.name;
    self.tweetUserHandleLabel.text =     [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];

    self.tweetDateLabel.text = [self.tweet.date shortTimeAgoSinceNow];
    
    NSString *URLString = self.tweet.user.profilePicture;
    [URLString stringByReplacingOccurrencesOfString:@"normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.tweetProfileImageView.image = [UIImage imageWithData: urlData];
    NSString *retweetImageName = self.tweet.retweeted ? @"retweet-icon-green.png" : @"retweet-icon.png";
    [self.tweetRetweetButton setImage: [UIImage imageNamed: retweetImageName] forState:UIControlStateNormal];
    
    [self.tweetRetweetButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.retweetCount] forState:UIControlStateNormal];
    
    NSString *favoriteImageName = self.tweet.favorited ? @"favor-icon-red.png" : @"favor-icon.png";
    [self.tweetFavoriteButton setImage: [UIImage imageNamed: favoriteImageName] forState:UIControlStateNormal];
    
    [self.tweetFavoriteButton setTitle:[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] forState:UIControlStateNormal];
    NSLog(@"%@", self.tweet.media);
    if(self.tweet.media.count > 0){
        NSString *mediaURLStr = self.tweet.media[0];
        NSURL *mediaURL = [NSURL URLWithString:mediaURLStr];
        NSData *mediaData = [NSData dataWithContentsOfURL:mediaURL];
        self.tweetMediaImageView.image = [UIImage imageWithData: mediaData];
        self.tweetMediaImageViewHeight.constant = 330;
        [self.tweetMediaImageView setHidden: NO];
    }
    else {
        self.tweetMediaImageViewHeight.constant = 0;
        self.tweetMediaImageViewHeight.priority = 1000;
        [self.tweetMediaImageView setHidden:YES];
        
    }
    [self.tweetRetweetButton setTitle: [NSString stringWithFormat: @"%d", self.tweet.retweetCount] forState:UIControlStateNormal ];
    [self.tweetFavoriteButton setTitle: [NSString stringWithFormat: @"%d", self.tweet.favoriteCount] forState:UIControlStateNormal ];
}
@end
