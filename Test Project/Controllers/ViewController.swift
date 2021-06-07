//
//  ViewController.swift
//  Test Project
//
//  Created by Admin on 07/06/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var progress: UIActivityIndicatorView!
    
    let viewModel = FlickerViewModel()
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupViewModelListeners()
        viewModel.fetchFlickerData()
    }
    
    
    //MARK:- UI
    func setupTableView(){
        collectionView.delegate=self
        collectionView.dataSource=self
        collectionView.register(UINib(nibName: FlickrCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FlickrCollectionViewCell.identifier)
    }
    func setupViewModelListeners(){
        viewModel.isLoading.bind{ [weak self] isLoading in
            self?.showProgress(status: isLoading)
        }
        viewModel.flickrData.bind{ [weak self] data in
            self?.collectionView.reloadData()
        }
        viewModel.error.bind{ error in
            if let error = error{
                Log.error("Error Occured while fetching data", error)
            }
        }
    }
}
//MARK:- Business Logic
extension ViewController{
    func showProgress(status: Bool){
        progress.isHidden = !status
    }
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(collectionView.contentOffset.y >= (collectionView.contentSize.height - collectionView.bounds.size.height)) {
            viewModel.fetchFlickerData()
        }
    }
}
// MARK:- Events
extension ViewController{
    
}
//MARK:- Collection View Data Source
extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.flickrData.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrCollectionViewCell.identifier, for: indexPath) as! FlickrCollectionViewCell
        let item = viewModel.flickrData.value[indexPath.item]
        let url = getFlickrImageURL(serverID: item.server, photoID: item.id, secret: item.secret)
        cell.flickerImage.loadImageFromURL(urlString: url)
        return cell
    }
    
}
// MARK:- Collection View Delegate
extension ViewController: UICollectionViewDelegate{
    
}
// MARK:- Collection View Delegate Flow Layout
extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/2 - 10
        let height = width
        return .init(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

// MARK:- get image url of the Photo
extension UIViewController{
    /// builds URL String from of Photo from it's propertires
    /// - Parameter serverID: server ID of the photo
    /// - Parameter photoID: ID of the photo
    /// - Parameter secret: Photo secret
    /// - Returns: A String containing url of the photo
    func getFlickrImageURL(serverID:String,photoID:String,secret:String)->String{
        //_{size-suffix}
        return "https://live.staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg"
    }
}
