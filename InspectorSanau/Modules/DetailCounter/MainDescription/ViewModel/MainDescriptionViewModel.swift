//
//  MainDescriptionViewModel.swift
//  InspectorSanau
//
//  Created by Andrey Novikov on 5/11/21.
//

import Foundation
import RxSwift
import RxCocoa


protocol MainDescriptionViewModelPresentable {
    typealias Input = (exelButton: Driver<Void>, fileName: Driver<String>,
                       firstDate: Driver<String>,
                       lastDate: Driver<String>)
    typealias Output = (success: Driver<URL>, buttonIsActive: Driver<Bool>)
    typealias Builder = (Input) -> MainDescriptionViewModelPresentable
    
    var input: Input { get set }
    var output: Output { get set }
}



final class MainDescriptionViewModel: MainDescriptionViewModelPresentable {
    var input: Input
    var output: Output
    
    private let firstDate = PublishRelay<String>.init()
    private let lastDate = PublishRelay<String>.init()
    private let exelUrl = PublishRelay<URL>.init()
    private let httpManager = HTTPManager()
    private let dispose = DisposeBag()
    private let id: String
    
    init(input: MainDescriptionViewModelPresentable.Input, id: String) {
        self.input = input
        self.output = MainDescriptionViewModel.output(input: input, exelUrl: exelUrl)
        self.id = id
        process()
    }
}

private extension MainDescriptionViewModel {
    func process() {
        let dateDriver = Driver<(String, String, String)>.combineLatest(input.firstDate,
                                                                input.lastDate,
                                                                input.fileName) { (firstDate, lastDate, fileName) -> (String, String, String) in
            return (firstDate, lastDate, fileName)
        }
        
        input.exelButton.withLatestFrom(dateDriver).asObservable().subscribe { (event) in
            if let element = event.element {
                do {
                    
                    print(element.0)
                    print(element.1)
                    
                    let lastFixFrom = element.0.getDate()?.getStringForServer() ?? ""
                    let lastFixTo = element.1.getDate()?.getStringForServer() ?? ""
                    
                    print(lastFixFrom)
                    print(lastFixTo)

                    
                    let params: [String: Any] = ["serialNumber": self.id,
                                                 "role": "ROLE_OPERATOR",
                                                 "lastFixFrom": lastFixFrom,
                                                 "lastFixTo": lastFixTo]
                    let value: Single<Data> = try self.httpManager.downLoadExel(request: ApplicationRouter.extelData(params).asURLRequest())
                    value.subscribeOn(MainScheduler.instance).asObservable().subscribe { (event) in
                        switch event {
                        case .next(let result):
                            print(result)
                            
//                            let fileName = UUID().uuidString
                            guard let url = try? self.savetoFileManager(data: result, fileName: element.2) else {
                                let error = NSError(domain: "Failed to save file manager", code: -1, userInfo: [:])
                                print(error)
                                return
                            }
                    
                            self.exelUrl.accept(url)
                            
                        case .error(let error):
                            print(error)
                        case .completed:
                            break
                        }
                    }.disposed(by: self.dispose)
                } catch {
                    
                }
            }
        }.disposed(by: dispose)
    }
    
    func savetoFileManager(data: Data, fileName: String) throws -> URL {
        let fileManager = FileManager.default
        let path = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = path.appendingPathComponent(fileName + ".xlsx")
        try data.write(to: fileURL)
        return fileURL
    }
}


extension MainDescriptionViewModel {
    static func output(input: MainDescriptionViewModelPresentable.Input,
                       exelUrl: PublishRelay<URL>) -> MainDescriptionViewModelPresentable.Output {
        
        let buttonIsActive = Driver<Bool>.combineLatest(input.fileName,
                                                        input.firstDate,
                                                        input.lastDate) { (fileName, firstDate, lastDate) -> Bool in
            print(firstDate, lastDate.dateIsAvalible())
            print(lastDate, lastDate.dateIsAvalible())
            return !fileName.isEmpty && firstDate.dateIsAvalible() && lastDate.dateIsAvalible() && firstDate.count == 10 && lastDate.count == 10 && firstDate.firstDateLessLastDate(second: lastDate)
        }
        
        return (success: exelUrl.asDriver(onErrorDriveWith: .never()), buttonIsActive: buttonIsActive)
    }
}


extension String {
    mutating func validateDate() -> String {
        if self.count == 1 || self.count == 3 {
            self.append("/")
        }
        
        return self
    }
}

extension String {
    func dateIsAvalible() -> Bool {
        // dd/mm/yyyy
        let dateFormatter = DateFormatter()
        let dateFormate = "dd/MM/yyyy"
        
        dateFormatter.dateFormat = dateFormate
        if let _ = dateFormatter.date(from: self) {
            return true
        } else {
            return false
        }
    }
}

extension String {
    func firstDateLessLastDate(second: String) -> Bool {
        let dateFormatter = DateFormatter()
        let dateFormate = "dd/MM/yyyy"
        dateFormatter.dateFormat = dateFormate
        
        if let firstDate = dateFormatter.date(from: self), let lastDate = dateFormatter.date(from: second) {
            return firstDate <= lastDate
        } else {
            return false
        }
    }
}

extension String {
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        let dateFormate = "dd/MM/yyyy"
        dateFormatter.dateFormat = dateFormate
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
