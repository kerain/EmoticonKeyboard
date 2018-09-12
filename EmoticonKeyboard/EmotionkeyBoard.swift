//
//  EmotionkeyBoard.swift
//  表情键盘的自定义
//
//  Created by 柴瑞军 on 16/4/19.
//  Copyright © 2016年 myCompany. All rights reserved.
//

import UIKit

class EmotionkeyBoard: UIView {
    // collectionView模拟的组和cell数量
//    private let items = [1, 6, 4, 2]
    
    weak var textView:UITextView?
    
    private let ReuseIdentifier = "ReuseIdentifier"

    override init(frame: CGRect) {
        
        let newFrame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 216)
        
        
        super.init(frame: newFrame)
        //添加子控件
        
        //用单例答应获取到的数据
//        print("\(ALEmoticonManager.shareManager.packageModels[2].pageEmoticons)")
        
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func prepareUI(){
    
        //添加collectionView
        addSubview(collectionView)
        
        
        addSubview(toolbar)
        addSubview(pageControl)
        //添加自定义的toolBar------该view上添加4个button
    
        // 添加约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: [], metrics: nil, views:  ["collectionView" : collectionView]))
       addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolbar]-0-|", options: [], metrics: nil, views: ["toolbar":toolbar]))
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-[toolbar(44)]-0-|", options: [], metrics: nil, views: ["collectionView" : collectionView,"toolbar":toolbar]))
        
        // pageControll约束
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: toolbar, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25))
    }
    //layout的item的大小
    override func layoutSubviews() {
        super.layoutSubviews()
        //确定子控件的大小
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
    }
    
    //懒加载collectionView
    private lazy var collectionView:UICollectionView = {
    
    //创建collectionView
        let layout = UICollectionViewFlowLayout()
        let  collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
//        collectionView.backgroundColor = UIColor.cyanColor()
        
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView.bounces = false
        collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "emoticon_keyboard_background")!)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView.pagingEnabled = true
        //设置代理方法和数据源方法
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        //注册cell
        collectionView.registerClass(ALEmoticonViewCell.self, forCellWithReuseIdentifier: self.ReuseIdentifier)
        return collectionView
    }()
    
    //懒加载toolBar
    private lazy var toolbar:ALEmoticonToolBar = {
    //创建toolbar
        let toolbar = ALEmoticonToolBar.emoticonToolBar()
        // 5.设置self为代理
        toolbar.delegate = self
        return toolbar
    }()
    
    //懒加载pageControl
    
    private lazy var pageControl:UIPageControl={
    //创建UIPageControl
    let pageC = UIPageControl()
        
        //当界面加载的时候先将pageControl进行隐藏
        pageC.hidden = true

        //在此处要记住一点:即运行时获取一个类的所有 属性:swift区别oc的遍历方法
        UIPageControl.printIvars()
        pageC.setValue(UIImage(named:"compose_keyboard_dot_selected"), forKey: "_currentPageImage")
        pageC.setValue(UIImage(named:"compose_keyboard_dot_normal"), forKey: "_pageImage")
        return pageC
    }()
    
}
// MARK: - 点击自定义toobar上的按钮的代理方法
extension EmotionkeyBoard:ALEmoticonToolBarDelegate{
    func emoticonToolBar(toolBar: ALEmoticonToolBar, selectedButtonType type: ALEmoticonToolBarType) {
        
        print("HMEmoticonKeyboard知道点击了哪个按钮,collectionView进行跳转到:\(type)")
        
        //滚动到对应的组
        let indexPath = NSIndexPath(forItem: 0, inSection: type.rawValue)
        
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        
        
        //当点击toolbard的时候也要设置pageControl的属性
        
        setupPageControl(indexPath)
    }
}
extension EmotionkeyBoard:UICollectionViewDataSource,UICollectionViewDelegate{
//有多少组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return ALEmoticonManager.shareManager.packageModels.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ALEmoticonManager.shareManager.packageModels[section].pageEmoticons.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ReuseIdentifier, forIndexPath: indexPath) as! ALEmoticonViewCell

        cell.indexPath = indexPath
        cell.pageEmoticonModel = ALEmoticonManager.shareManager.packageModels[indexPath.section].pageEmoticons[indexPath.item]
        cell.delegate = self
        
        return cell
    }
    
    //scrollView的滚动
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // 判断显示哪一组
        
        var refPoint = scrollView.center
        refPoint.x += scrollView.contentOffset.x
        //        print("refPoint: \(refPoint)")
        
        // 获取正在显示的cell
        for cell in collectionView.visibleCells() {
            if cell.frame.contains(refPoint) {
                // 获取cell的indexPath
                let indexPath = collectionView.indexPathForCell(cell)
//                                print("找到了indexPath: \(indexPath)")
                // 选中对应这组的按钮
                
                toolbar.switchSelectButton(indexPath!.section)
                
                //设置pageControl的内容
                setupPageControl(indexPath!)
            }
        }
    }
    
    private func setupPageControl(indexPath:NSIndexPath){
    
        pageControl.numberOfPages = ALEmoticonManager.shareManager.packageModels[indexPath.section].pageEmoticons.count
        pageControl.currentPage = indexPath.item
        
        //第0组不需要显示
        pageControl.hidden = indexPath.section == 0
    }
}
//MARK: 实现给属性文本赋值
extension EmotionkeyBoard:ALEmoticonViewCellDelegate{

    func emoticonKeyboardpageCellDidclickDeleteButton(cell: ALEmoticonViewCell){
    //删除textView中的内容
        textView?.deleteBackward()
    }
    
    func emoticonkeyboardpageCell(cell: ALEmoticonViewCell, didSelectedEmoticon: ALEmoticonModel) {
//        print("点击了当前的cell是:\(cell),数据是:\(didSelectedEmoticon)")
        
                // 判断textView是否有值
        guard let textView = self.textView else {
            print("textView 为空")
            return
        }
        textView.insertIcon(didSelectedEmoticon)
        
        
        //添加最近表情,将表情添加到最近展示的那一页.通过单例管理添加方法
        ALEmoticonManager.shareManager.addRecentEmoticon(didSelectedEmoticon)
    }
    
}
