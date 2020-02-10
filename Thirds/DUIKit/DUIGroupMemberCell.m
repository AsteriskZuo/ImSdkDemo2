//
//  DUIGroupMembersCell.m
//  ImSdkDemo
//
//  Created by AsteriskZuo on 2020/2/8.
//  Copyright © 2020 yu.zuo. All rights reserved.
//

#import "DUIGroupMemberCell.h"
#import "MMLayout/UIView+MMLayout.h"
#import "DHeader.h"

@implementation DUIGroupMemberCellData

@end


@interface DUIGroupMemberCell ()

@property (nonatomic, strong) DUIGroupMemberCellData* membersData;

@end

@implementation DUIGroupMemberCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _avatarView = [[UIImageView alloc] init];
    _avatarView.layer.cornerRadius = 5;
//    _avatarView.layer.masksToBounds = YES;
    [self addSubview:_avatarView];
    
    _nameView = [[UILabel alloc] init];
    [_nameView setFont:[UIFont systemFontOfSize:13]];
    [_nameView setTextColor:[UIColor grayColor]];
    [_nameView setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_nameView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _avatarView.mm_width(TGroupMemberCell_Head_Width).mm_height(TGroupMemberCell_Head_Height).mm_left(0).mm_top(0);
    _nameView.mm_width(_avatarView.mm_w).mm_height(TGroupMemberCell_Name_Height).mm_left(0).mm_top(_avatarView.mm_h + TGroupMemberCell_Margin);
}

- (void)fillWithData:(DUIGroupMemberCellData *)data
{
    _membersData = data;
    [_avatarView setImage:data.avatar];
    _nameView.text = data.name;
}

+ (CGSize)getSize
{
    return CGSizeMake(TGroupMemberCell_Head_Width
                      , TGroupMemberCell_Head_Height + TGroupMemberCell_Margin + TGroupMemberCell_Name_Height);
}

@end






@implementation DUIGroupMembersCellData



@end


@interface DUIGroupMembersCell () <UICollectionViewDelegate, UICollectionViewDataSource>

/**
 *  群成员数据源，本类从 data 中获取需要显示的成员信息，并在“群成员”模块中显示。
 */
@property (nonatomic, strong) DUIGroupMembersCellData *membersData;

@end

@implementation DUIGroupMembersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _membersLayout = [[UICollectionViewFlowLayout alloc] init];
//    _memberFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CGSize cellSize = [DUIGroupMemberCell getSize];
    _membersLayout.itemSize = cellSize;
    _membersLayout.minimumInteritemSpacing = (Screen_Width - cellSize.width * TGroupMembersCell_Column_Count - 2*TGroupMembersCell_Margin) / (TGroupMembersCell_Column_Count - 1);
    _membersLayout.minimumLineSpacing = TGroupMembersCell_Margin;
    _membersLayout.sectionInset = UIEdgeInsetsMake(TGroupMembersCell_Margin, TGroupMembersCell_Margin, TGroupMembersCell_Margin, TGroupMembersCell_Margin);
    
    CGRect viewRect = CGRectMake(0, 0, Screen_Width, 0);
    _membersView = [[UICollectionView alloc] initWithFrame:viewRect collectionViewLayout:_membersLayout];
    [_membersView registerClass:[DUIGroupMemberCell class] forCellWithReuseIdentifier:TGroupMemberCell_ReuseId];
    _membersView.collectionViewLayout = _membersLayout;
    _membersView.delegate = self;
    _membersView.dataSource = self;
    _membersView.showsHorizontalScrollIndicator = NO;
    _membersView.showsVerticalScrollIndicator = NO;
    _membersView.backgroundColor = self.backgroundColor;
    [self addSubview:_membersView];
    
    [self setSeparatorInset:UIEdgeInsetsMake(0, TGroupMembersCell_Margin, 0, 0)];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)updateLayout
{
    CGFloat height = [DUIGroupMembersCell getHeight:_membersData];
    _membersView.frame = CGRectMake(0, 0, Screen_Width, height);
}

+ (CGFloat)getHeight:(DUIGroupMembersCellData *)data
{
    NSInteger row = [self getRowCount:data];
    CGFloat height = row * [DUIGroupMemberCell getSize].height + (row + 1) * TGroupMembersCell_Margin;
    return height;
}

+ (NSInteger)getRowCount:(DUIGroupMembersCellData*)data
{
    NSInteger row = 1;
    if (0 == data.members.count) {
        
    } else {
        row = ceil(data.members.count * 1.0 / TGroupMembersCell_Column_Count);
        if(row > TGroupMembersCell_Row_Count) {
            row = TGroupMembersCell_Row_Count;
        }
    }
    return row;
}

- (void)fillWithData:(DUIGroupMembersCellData *)data
{
    _membersData = data;
    [self updateLayout];
    [_membersView reloadData];
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _membersData.members.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DUIGroupMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TGroupMemberCell_ReuseId forIndexPath:indexPath];
    DUIGroupMemberCellData *data = _membersData.members[indexPath.item];
    [cell fillWithData:data];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(_membersDelegate && [_membersDelegate respondsToSelector:@selector(groupMembersCell:didSelectItemAtIndex:)]){
        [_membersDelegate groupMembersCell:self didSelectItemAtIndex:indexPath.section * TGroupMembersCell_Column_Count + indexPath.item];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [DUIGroupMemberCell getSize];
}

@end
