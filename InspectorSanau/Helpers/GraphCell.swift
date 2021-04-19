//
//  GraphCell.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit

class GraphCell: UICollectionViewCell {
    
    // MARK: - Exteranl properties
    
    static let reuseId = "GraphCell"
    
    // MARK: - Private proprties
    
    private var horizontaleValuesCount: Int = 7
    private var pathShapeLayer = CAShapeLayer()
    private var verticleTitlesCount = 5

    private lazy var itemHeight = frame.height / (CGFloat(verticleTitlesCount + 1))
    private lazy var itemWidth = frame.width / (CGFloat(horizontaleValuesCount + 1))
    
    private var titleLables = [UILabel]()
    private var countLabels = [UILabel]()
    private var horizontalViews  = [UIView]()
    private var items: [GraphPresentable] = []
    
    private var maxValue: CGFloat {
        return items.map({ $0.value }).max() ?? 0
    }
    
    private var minValue: CGFloat {
        return items.map({ $0.value }).min() ?? 0
    }
    
    private var medina: CGFloat {
        let values = items.map({ $0.value })
        var sum: CGFloat = 0
        values.forEach { (item) in
            sum += item
        }
        return sum / CGFloat(values.count)
    }
    
    private var minMedina: CGFloat {
        return (minValue + medina) / 2
    }
    
    private var maxMedina: CGFloat {
        return (maxValue + medina) / 2
    }
    
    private var maxMideinaAndMaxValue: CGFloat {
        return (maxValue + maxMedina) / 2
    }

    
    // MARK: - Configure
    
    func configure(presentableItem: [GraphPresentable]) {
        items = presentableItem
        
        backgroundColor = .clear
        
        setupTitleLables()
        setupCountLabel()
        setupShapePathLayer()
        
        (0..<presentableItem.count).forEach { (index) in
            countLabels[index].text = presentableItem[index].date
        }
        
        titleLables[0].text = maxMideinaAndMaxValue.clean
        titleLables[1].text = maxMedina.clean
        titleLables[2].text = medina.clean
        titleLables[3].text = minMedina.clean
        titleLables[4].text = minValue.clean
    }
    
    // MARK: - Private methods
    
    private func setupTitleLables() {
        (0..<verticleTitlesCount).forEach { index in
            let label = self.configureLabel(aligmnent: .left)
            let view = self.configureViwe()
            label.frame = CGRect(x: 16, y: itemHeight * CGFloat(index), width: itemWidth, height: itemHeight)
            
            view.frame = CGRect(x: 32 + itemHeight,
                                y: itemHeight * CGFloat(index) - itemHeight / 2,
                                width: frame.width - itemWidth - 32 ,
                                height: 0.8)
            titleLables.append(label)
            horizontalViews.append(view)
            addSubview(label)
            addSubview(view)
        }
        
        (1..<verticleTitlesCount).forEach { index in
            let view = self.configureViwe()
            view.frame = CGRect(x: 32 + itemHeight,
                                y: itemHeight * CGFloat(index) + itemHeight / 2,
                                width: frame.width - itemWidth - 32 ,
                                height: 0.8)
            horizontalViews.append(view)
            addSubview(view)
        }
    }
    
    private func setupCountLabel() {
        (1...horizontaleValuesCount).forEach { index in
            let label = configureLabel(aligmnent: .right)
            label.frame = CGRect(x: itemWidth * CGFloat(index) - 16, y: frame.height - itemHeight, width: itemWidth, height: itemHeight)
            countLabels.append(label)
            addSubview(label)
        }
    }
    
    private func configureLabel(aligmnent: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: "Play", size: 13)
        label.textColor = UIColor(named: "GraphTitleLabel")
        label.textAlignment = aligmnent
        return label
    }
    
    private func configureViwe() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(named: "GraphViewColor")
        return view
    }
    
    private func setupShapePathLayer() {
        pathShapeLayer.path = drawPath().cgPath
        pathShapeLayer.frame = bounds
        pathShapeLayer.strokeColor = UIColor(named: "TextColor2")?.cgColor
        pathShapeLayer.fillColor = UIColor.clear.cgColor
        pathShapeLayer.lineWidth = 2.5
        pathShapeLayer.lineCap = .round
        
        layer.addSublayer(pathShapeLayer)
    }

    
    private func drawPath() -> UIBezierPath {
        guard items.count > 0 else { return UIBezierPath() }
        let path = UIBezierPath()
        path.move(to: CGPoint(x: getXPossition(index: 0), y: getYposition(value:  items[0].value)))
        
        items.enumerated().forEach { pres in
            if pres.offset != 0 {
                path.addLine(to: CGPoint(x: getXPossition(index: pres.offset), y: getYposition(value: pres.element.value)))
            }
        }
        
        return path
    }
    
    private func getYposition(value: CGFloat) -> CGFloat {
        let diff = maxValue - minValue
        let ration = frame.height / diff
        let result = frame.height - (value - minValue) * ration
        return normilize(value: result)
    }
    
    private func normilize(value: CGFloat) -> CGFloat {
        let height = frame.height - itemHeight - itemHeight / 2
        let ration = frame.height / height
        return value / ration
    }
    
    private func  getXPossition(index: Int) -> CGFloat {
        return 16 + itemWidth + CGFloat(index) * itemWidth
    }
}

