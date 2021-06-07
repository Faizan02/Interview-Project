//
//  FlickerViewModel.swift
//  Test Project
//
//  Created by Admin on 07/06/2021.
//

import Foundation
class FlickerViewModel{
    
    let flickrData:Box<[FlickerPhoto]> = Box([])
    let isLoading:Box<Bool> = Box(false)
    let error:Box<Error?> = Box(nil)
    var flickerResponse:FlickerResponse?
    
    func fetchFlickerData(){
        if !checkIfAlreadyLoadingData(){
            isLoading.value = true
            NetworkManager.request(endpoint: FlickerEndpoint.getSearchResults(searchText: "iOS", page: getPageNumber())) { [weak self] (result: Result<FlickerResponse,Error>) in
                switch result{
                case.success(let response):
                    DispatchQueue.main.async {
                        self?.isLoading.value = false
                        self?.flickerResponse = response
                        let photos = response.photos?.photo ?? []
                        self?.flickrData.value.append(contentsOf: photos)
                    }
                case .failure(let error1):
                    DispatchQueue.main.async {
                        self?.isLoading.value = false
                        self?.error.value = error1
                        Log.error("response error", error1)
                    }
                }
            }
        }
    }
    func checkIfAlreadyLoadingData()->Bool{
        return isLoading.value
    }
    func getPageNumber()->Int{
        return (flickerResponse?.photos?.page ?? 0) + 1
    }
}
