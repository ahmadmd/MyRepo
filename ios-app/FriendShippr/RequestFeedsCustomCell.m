//
//  RequestFeedsCustomCell.m
//  FriendShippr
//
//  Created by Zoondia on 03/09/13.
//  Copyright (c) 2013 Zoondia. All rights reserved.
//

#import "RequestFeedsCustomCell.h"

@implementation RequestFeedsCustomCell
@synthesize imageUrls,tableImageHolder;//,selectedRow;

+ (NSString *)reuseIdentifierFeed{
    return @"requestFeedsCustomCellFeed";
}

+ (NSString *)reuseIdentifierHub{
    return @"requestFeedsCustomCellHub";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)reloadTableData{
    [self.tableImageHolder reloadData];
    [self.tableImageHolder setContentOffset:CGPointZero animated:NO];
    //[self.tableImageHolder scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (IBAction)bttnActionRepost:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:FSShippingRequestRepostCellNotification object:self];
}

- (void)dealloc {
    [_lblProductShippingName release];
    [_lblShippingLocation release];
    [_lblKarmaPoints release];
    [imageUrls release];
    [_lblCurrentUser release];
    [_repostViewHolder release];
    [_lblTimeDisplay release];
    [super dealloc];
}

#pragma mark UITableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.imageUrls count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductScrollCustomCell *cell = nil;//(ProductScrollCustomCell *) [tableView dequeueReusableCellWithIdentifier:[ProductScrollCustomCell reuseIdentifier]];
    
    if (cell == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProductScrollCustomCell" owner:self options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (ProductScrollCustomCell *)currentObject;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
                break;
            }
        }
    }
    
    cell.productImageHolder.image=[UIImage imageNamed:@"NoProduct.png"];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:[self.imageUrls objectAtIndex:indexPath.row]] options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error,SDImageCacheType cacheType, BOOL finished){
        if (image)
        {
            cell.productImageHolder.image=[image thumbnailImage:320 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationLow];
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 312;
}

#pragma mark UIScrollView Delegates

- (void)scrollViewDidEndDecelerating:(UIScrollView *)newScrollView{
    CGFloat pageWidth = self.frame.size.height;
    float fractionalPage = self.tableImageHolder.contentOffset.y / pageWidth;
    //the index of image selected, use this to change content in cell..
	NSInteger nearestNumber = floor(fractionalPage);
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:self,@"cell",[NSNumber numberWithInt:nearestNumber],@"pageNum", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:FSProductScrollCellContentChangedNotification object:dict];
}



@end
