//
//  GraphView.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 4/13/21.
//

import UIKit

protocol GraphPresentable {
    var value: CGFloat { get set }
    var date: String { get set }
}


struct GraphPresentableModel: GraphPresentable {
    var value: CGFloat
    var date: String
}

class GraphView: UIView {

    var writeComplition: (() -> Void)?
   
    // MARK: - External properties
    
    private var views = [UIView]()
    
    var data: [GraphPresentable] = [] {
        didSet {
            update()
        }
    }
    
    var presentableItems: [[GraphPresentable]] = []
    
    // MARK: - Private properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private var viewIsLoad = false
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraintsForCollectionView()
        
        writeComplition = {
            var newValue = self.data
            newValue.append(GraphPresentableModel(value: CGFloat.random(in: 300...500), date: "\(Int.random(in: 1...12)).\(Int.random(in: 1...30))"))
            self.data = newValue
            if newValue.count % 8 == 0 {
                self.scrollToMaxX(withAnimation: true)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupConstraintsForCollectionView()
    }
    
    
    // MARK: - Setup constraints
    
    private func setupConstraintsForCollectionView() {
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    

    // MARK: - Private methods
    
    private func update() {
        _ = views.map({ $0.removeFromSuperview() })
        presentableItems = []
        presentableItems = data.chank(size: 7)
        
        scrollView.contentSize = CGSize(width: CGFloat(presentableItems.count) * frame.width, height: frame.height)
        
        presentableItems.enumerated().forEach { (presentable) in
            let v = GraphContentView()
            v.frame = CGRect(x: CGFloat(presentable.offset) * frame.width, y: 0, width: frame.width, height: frame.height)
            v.configure(presentableItem: presentable.element)
            views.append(v)
            scrollView.addSubview(v)
        }
        
        DispatchQueue.main.async {
            self.scrollToMaxX(withAnimation: self.viewIsLoad)
            self.viewIsLoad = true
        }
    }
    
    
    // MARK: - Setup constraints
    
    private func scrollToMaxX(withAnimation: Bool) {
        let position = scrollView.contentSize.width - scrollView.frame.width
        if withAnimation {
            UIView.animate(withDuration: 0.33) {
                self.scrollView.contentOffset.x = position
            }
        } else {
            self.scrollView.contentOffset.x = position
        }
    }
}


