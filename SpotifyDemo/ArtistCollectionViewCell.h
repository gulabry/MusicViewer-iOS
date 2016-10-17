//
//  ArtistCollectionViewCell.h
//  SpotifyDemo
//
//  Created by CardSwapper on 10/16/16.
//
//

#import <UIKit/UIKit.h>

@interface ArtistCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
- (IBAction)playArtist:(id)sender;

@end
