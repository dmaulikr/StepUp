import UIKit

class HomeViewController: UIViewController,
                          HomeViewOutput,
                          UsesHomeViewModel,
                          UICollectionViewDelegate {
    
    internal let homeViewModel: HomeViewModel
    
    private lazy var pageControl: UIPageControl = {
        let v = UIPageControl()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.pageIndicatorTintColor = .buttonDisabled
        v.currentPageIndicatorTintColor = .baseGreen
        return v
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 40)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.white
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cv.registerReusableCell(TreatmentCell.self)
        cv.isPagingEnabled = true
        return cv
    }()
    
    private let configurator: TreatmentsCellConfigurator<TreatmentCell>
    private let dataSource: CollectionViewDataSource<ArrayDataHandler<Treatment>,
                            TreatmentsCellConfigurator<TreatmentCell>>
    
    init(viewModel: HomeViewModel) {
        homeViewModel = viewModel
        configurator = TreatmentsCellConfigurator(viewModel: homeViewModel)
        dataSource = CollectionViewDataSource(dataHandler: viewModel.dataHandler, configurator: configurator)
        super.init(nibName: nil, bundle: nil)
        viewModel.setModel(output: self)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        applyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        homeViewModel.start()
    }
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(pageControl)
    }
    
    private func applyConstraints() {
        let views: [String: Any] = ["collectionView": collectionView,
                                    "pageControl": pageControl]
        var constraints: [NSLayoutConstraint] = []
        constraints.append(NSLayoutConstraint(item: collectionView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: topLayoutGuide,
                                              attribute: .bottomMargin,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: collectionView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: bottomLayoutGuide,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: pageControl,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: bottomLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1, constant: -20))
        
        constraints.append(NSLayoutConstraint(item: pageControl,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1, constant: 0))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: HomeViewOutput
    
    func showTreatments() {
        pageControl.numberOfPages = homeViewModel.dataHandler.numberOfItems(inSection: 0)
        collectionView.reloadData()
    }
    
    func presentTreatmentWeek(viewModel: WeekScheduleViewModel) {
        navigationController?.pushViewController(WeekScheduleViewController(viewModel: viewModel), animated: true)
    }
    
    // MARK: UIScrollview delegate, calculate page position
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.bounds.size.width
        let page: CGFloat = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        pageControl.currentPage = Int(page)
    }
}
