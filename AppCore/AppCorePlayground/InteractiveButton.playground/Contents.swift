//: Playground - noun: a place where people can play

//: [Previous](@previous)
 import Foundation
 import UIKit
 import RxSwift
 import RxCocoa
 import PlaygroundSupport

struct UI {
    let textbox = UITextField(frame: CGRect(x: 30, y: 100, width: 300, height: 30))

    let label = UILabel(frame: CGRect(x: 200, y: 30, width: 150, height: 30) )
    let button = UIButton(frame: CGRect(x: 30, y: 30, width: 150, height: 30))
    init() {
        textbox.backgroundColor = UIColor.white
        label.text = "No result"
        label.textColor = UIColor.white
        button.setTitle("Sample Now!", for: .normal)
    }
}

func createSearchRequest(_ searchString: String) -> Observable<String> {
    let time = Double(arc4random_uniform(4000)) / Double(1000)
    return Observable<Int64>
        .timer(time, scheduler: MainScheduler.instance)
        .map { tick in return "Search result: \(searchString) in \(time) seconds" }
}

var disposeBag = DisposeBag()

let ui = UI()

let subscription =
ui.textbox.rx.text
.filter { $0 != "" }
.throttle(0.5, scheduler: MainScheduler.instance)
.distinctUntilChanged()
.flatMapLatest { searchString in
    createSearchRequest(searchString!)
}
.subscribe(onNext: { searchResult in
    print(searchResult)
})

class MyViewController : UIViewController {

    var disposeBag = DisposeBag()
    var lastSearchString = ""
    var lastSearchStringTime = NSDate()

    @objc func buttonTapped(_ sender: UIButton) {
        print("old callback method")
    }

    @objc func textChanged(_ sender: UITextField) {
        if let searchString = ui.textbox.text {
            //let currentSearchStringTime = NSDate()
            //if currentSearchStringTime - lastSearchStringTime < 0.3 {
            createSearchRequest(searchString)
                .subscribe(onNext: { searchResult in
                print(searchResult)
            })
            //}

            lastSearchString = searchString
            lastSearchStringTime = NSDate()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ui.button.addTarget(nil, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        ui.textbox.addTarget(nil, action: #selector(textChanged(_:)), for: .allEvents)
    }

}


 ui.button.rx.tap
 .scan(false) { colorSwitch, tap in
    return !colorSwitch
 }.subscribe(onNext: { colorSwitch in

 print("tapped")
 ui.button.backgroundColor = colorSwitch ?  UIColor.red : UIColor.green

 }).disposed(by: disposeBag)


 let vc = UIViewController()
 vc.view.addSubview(ui.button)
 vc.view.addSubview(ui.textbox)
 vc.view.addSubview(ui.label)

 PlaygroundPage.current.liveView = vc
 print("Finished set up")

