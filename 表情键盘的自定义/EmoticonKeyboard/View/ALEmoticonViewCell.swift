//
//  ALEmoticonViewCell.swift
//  EmotionKeyboard
//
//  Created by 柴瑞军 on 16/4/20.
//  Copyright © 2016年 myCompany. All rights reserved.
//

import UIKit

//由于点击按钮时候要将所点击的按钮的内容进行展示,但是展示不是由cell来控制的,所以定义代理,将keyboard进行展示数据
protocol ALEmoticonViewCellDelegate:NSObjectProtocol{

//定义协议方法:
    func emoticonkeyboardpageCell(cell:ALEmoticonViewCell,didSelectedEmoticon:ALEmoticonModel)
    
    //进行删除textView的内容的代理的方法
    func emoticonKeyboardpageCellDidclickDeleteButton(cell: ALEmoticonViewCell)
}


class ALEmoticonViewCell: UICollectionViewCell {
    
    //代理属性:
    weak var delegate:ALEmoticonViewCellDelegate?
    //cell要显示表情模型,需要这一页的表情模型数组,表情模型数组已经在表情模型数据包里面准备好了
 
    var pageEmoticonModel: [ALEmoticonModel]?{
    
        didSet{
        //cell 要显示的模型
            
            //解决cell的重用问题;1.cell中的button进行赋值的时候先将所有的按钮进行清空内容
//                            2. 将所有的按钮进行隐藏,当需要展示的时候在赋值的时候将button进行展示
            
            for button in emoticonButtons {
                button.hidden = true
            }
            
            
//            print("\(pageEmoticonModel)")
            //遍历模型,还是使用迭代器,将遍历出来的button进行赋值
            for (index, emoticonModel) in pageEmoticonModel!.enumerate() {
                

                //找到模型对应的按钮,将模型的值赋值给按钮
                let emoticonButton = emoticonButtons[index]
                
                //将要展示的button进行显示
                
                emoticonButton.hidden = false
                
                emoticonButton.emoticonModel = emoticonModel
                
            }
        }
        
    }
    
    
    var indexPath : NSIndexPath?{
        didSet{
//            debugLabel.text = "当前第:\(indexPath?.section)组, 第\(indexPath?.item)行"
            
            recentLabel.hidden = indexPath?.section != 0
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //添加子控件
        prepareUI()
    }
    
    //定义存放20个按钮的数组---这样封装的好处要能体会到
    private var emoticonButtons  = [EmoticonButton]()
    
    //创建20个按钮
    
    private func creatEmoticonButton(){
    //此处用到的button使用自定义的button,在自定义的button中设置btn的内容
        for _ in 0..<20 {
            let button = EmoticonButton()
            
            //设置背景颜色进行测试
//            button.backgroundColor = UIColor.randomColor()
            //设置button文本的大小
            button.titleLabel?.font = UIFont.systemFontOfSize(32)
            button.addTarget(self, action: #selector(ALEmoticonViewCell.didClickEmoticonButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            //将button添加到按钮数组中
            emoticonButtons.append(button)
            
            //将button添加到cell的contentView上
            contentView.addSubview(button)
        }
        
    }
    @objc private func didClickEmoticonButton(button:EmoticonButton){
    
        //注意和OC中的代理书写的区别:在oc中,需要判断代理方法有没有响应,再有响应之后在去是调用代理方法
        //在swift中,delegate?可以等同与oc中的代理响应的判断和调用代理
        delegate?.emoticonkeyboardpageCell(self, didSelectedEmoticon: button.emoticonModel!)
        
    }
    
    @objc private func didClickDeleteButton(){
        
        //当点击删除的时候将输入的内容进行删除textView中的内容---代理方法
        delegate?.emoticonKeyboardpageCellDidclickDeleteButton(self)
    }

    //给按钮进行布局---区分和layout布局的时机区别:layout是在init方法中就能设置约束,在设置frame的时候不能在init方法中设置,因为此时控件还没有大小
    //设置20个按钮的大小是在layoutSubViews中设置
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置按钮的位置
        layoutButtonFrame()
    }
    private func layoutButtonFrame(){
    //button距离左边的距离
        let marginLR:CGFloat = 5
        //button底部距离contentView的距离
        let marginV: CGFloat = 25
    
        //button的宽度   = (cell 的宽度 - 2* marginLR)/按钮列数
        let width = (self.frame.width - 2*marginLR)/CGFloat(ALEmoticonColumnOfPage)
        //button的高度 = (cell 的高度 - marginV)/按钮的行数
        let height = (self.frame.height - marginV)/CGFloat(ALEmoticonRowOfPage)
        
        
        //设置每一个按钮的frame的值----迭代器遍历的好处,不经可以遍历出相应的对象,而且還可以遍历出对象所在数组中的位置索引
        for (index, button) in emoticonButtons.enumerate() {
            
            //当前的列数
            let column = index%ALEmoticonColumnOfPage
            
            //当前的行数
            let row = index/ALEmoticonColumnOfPage
            
            //计算x的值
            let x = marginLR + width*CGFloat(column)
            //计算y的值
            let y = height*CGFloat(row)
            
            //按钮的frame
            let frame = CGRect(x: x, y: y, width: width, height: height)
            
            button.frame = frame
        }
        
        //设置删除按钮的frame----删除按钮的frame是固定不变的,具体的位置是在第三行,第七列
        let buttonFrame = CGRect(x: CGFloat(ALEmoticonColumnOfPage-1)*width, y: CGFloat(ALEmoticonRowOfPage-1)*height, width: width, height: height)
        deleteButton.frame = buttonFrame
        
        
        //设置最近使用的label
        let x = (self.frame.width-recentLabel.frame.width)*0.5
        let y = self.frame.height-recentLabel.frame.height
        
        
        let recentLabelFrame = CGRect(x:x , y: y, width: recentLabel.frame.width, height: recentLabel.frame.height)
        recentLabel.frame = recentLabelFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI(){
        creatEmoticonButton()
        //删除按钮
        contentView.addSubview(deleteButton)
        
    //添加一个label
      contentView.addSubview(debugLabel)
        
        //添加最近按钮
        contentView.addSubview(recentLabel)
        debugLabel.frame = bounds
    }
    //懒加载一个label
    private lazy var debugLabel:UILabel = {
    let label = UILabel()
    
        label.textColor = UIColor.redColor()
        label.font = UIFont.systemFontOfSize(20)
        
        return label
    }()
    
    //懒加载删除按钮
    private lazy var deleteButton:UIButton = {
    let button = UIButton()
    
        //设置button的属性
        button.setImage(UIImage(named:"compose_emotion_delete"), forState: UIControlState.Normal)
        button.setImage(UIImage(named:"compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
        
        //点击删除按钮的监听事件
        button.addTarget(self, action: #selector(ALEmoticonViewCell.didClickDeleteButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    
    //懒加载最近使用的label,添加到cell的contentView上,只在第一组进行显示,其他页隐藏
    private lazy var recentLabel:UILabel = {
    let label = UILabel()
    
        //设置label的属性
        label.textColor = UIColor.lightGrayColor()
        label.font = UIFont.systemFontOfSize(12)
        label.text = "最近使用表情"
        
        label.sizeToFit()
        
        return label
    }()
}
