import Foundation
import UIKit

class CollectionViewDataSource<T: DataHandler,
                               C: CollectionViewCellConfigurator>: NSObject,
                                                                   UICollectionViewDataSource 
                                                                   where T.DataType == C.DataType {
    private let dataHandler: T
    private let configurator: C
    
    init(dataHandler: T, configurator: C) {
        self.dataHandler = dataHandler
        self.configurator = configurator
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataHandler.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataHandler.numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return configurator.configure(using: collectionView,
                                      at: indexPath,
                                      with: dataHandler.item(at: indexPath))
    }
}
