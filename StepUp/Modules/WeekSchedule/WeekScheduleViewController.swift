import UIKit
import App
import CollectionViewKit

class WeekScheduleViewController: UIViewController,
                                  UsesWeekSchedulePresenter,
                                  WeekScheduleView,
                                  UICollectionViewDelegate {
    internal let weekSchedulePresenter: WeekSchedulePresenter

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
        cv.registerReusableCell(DayScheduleCell.self)
        cv.isPagingEnabled = true
        return cv
    }()

    private lazy var closeButton: UIButton = {
        let b = UIButton(type: .roundedRect)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Sluiten", for: .normal)
        b.setTitleColor(.baseGreen, for: .normal)
        b.setTitleColor(UIColor.buttonDisabled, for: .highlighted)
        b.titleLabel?.font = UIFont.light(withSize: 17)
        b.layer.borderWidth = 1
        b.layer.cornerRadius = 4
        b.layer.borderColor = UIColor.actionGreen.cgColor
        b.contentEdgeInsets = UIEdgeInsets(top: 3, left: 7, bottom: 3, right: 7)
        return b
    }()

    private lazy var treatmentTitle: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        l.textAlignment = .right
        l.font = UIFont.light(withSize: 17)
        return l
    }()

    internal lazy var loaderView: LoaderView = {
        let l = LoaderView()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let configurator: WeekScheduleCellConfiguration
    private let dataSource: CollectionViewDataSource<SectionDataHandler<Section<DaySchedule>>,
                                                                          WeekScheduleCellConfiguration>

    init(presenter: WeekSchedulePresenter) {
        weekSchedulePresenter = presenter
        configurator = WeekScheduleCellConfiguration(presenter: weekSchedulePresenter)
        dataSource = CollectionViewDataSource(dataHandler: presenter.dataHandler, configurator: configurator)
        super.init(nibName: nil, bundle: nil)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        weekSchedulePresenter.setView(view: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        applyConstraints()

        treatmentTitle.text = "Behandeling \(weekSchedulePresenter.weekNumber)"
        weekSchedulePresenter.start()
        closeButton.addTarget(self, action: #selector(closeButtonTapped(sender:)), for: .touchUpInside)
    }

    // MARK: Week schedule output

    func showWeekSchedule() {
        pageControl.numberOfPages = weekSchedulePresenter.dataHandler.numberOfItems(inSection: 0)
        collectionView.reloadData()
    }

    // MARK: UIScrollview delegate, calculate page position

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.bounds.size.width
        let page: CGFloat = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        pageControl.currentPage = Int(page)
    }

    @objc private func closeButtonTapped(sender: UIButton) {
        weekSchedulePresenter.dismissWeekSchedule()
    }

    private func setup() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(treatmentTitle)
        view.addSubview(pageControl)
    }

    // swiftlint:disable function_body_length
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

        constraints.append(NSLayoutConstraint(item: closeButton,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: topLayoutGuide,
                                              attribute: .bottomMargin,
                                              multiplier: 1, constant: 7))

        constraints.append(NSLayoutConstraint(item: closeButton,
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .left,
                                              multiplier: 1, constant: 10))

        constraints.append(NSLayoutConstraint(item: treatmentTitle,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: topLayoutGuide,
                                              attribute: .bottomMargin,
                                              multiplier: 1, constant: 7))

        constraints.append(NSLayoutConstraint(item: treatmentTitle,
                                              attribute: .right,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .right,
                                              multiplier: 1, constant: -10))

        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|",
                                                                   options: [],
                                                                   metrics: nil, views: views))
        NSLayoutConstraint.activate(constraints)

    }
    // swiftlint:enable function_body_length
}
