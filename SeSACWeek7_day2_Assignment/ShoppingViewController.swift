//
//  ShoppingViewController.swift
//  SeSACWeek7_day2_Assignment
//
//  Created by 박현진 on 8/12/25.
//

import UIKit
import SnapKit
import Kingfisher
import Alamofire

class ShoppingViewController: UIViewController {
    
    static let identifier = "ShoppingViewController"
    
    var list: [ProductsList] = []
    var total: Int = 0
    
//    let sorts = ["", "sim", "date", "dsc", "asc"]
//    var page = 1
    var buttonCheck = 0
//    var count = 1
//    var url = ""
//    var fixUrl = ""

    //var shoppingList: [ProductsList] = []
    var searchBarToss: String = ""
    let priceFormat = NumberFormatter()
    
//    let recommendCollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//        collectionView.backgroundColor = .black
//        let layout = UICollectionViewFlowLayout()
//        let deviceWidth = UIScreen.main.bounds.width
//        let cellWidth = deviceWidth - (10 * 2) - (10 * 3) //좌우여백 2개, 셀사이간격 3개
//        layout.itemSize = CGSize(width: cellWidth/4, height: cellWidth/4) //셀 4개
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.minimumInteritemSpacing = 5
//        layout.minimumLineSpacing = 5
//        layout.scrollDirection = .horizontal
//        collectionView.collectionViewLayout = layout
//        collectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
//        return collectionView
//    }()
    
    let shoppingCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .black
        let layout = UICollectionViewFlowLayout()
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth - (10 * 2) - (10 * 1) //좌우여백 2개, 셀사이간격 1개
        layout.itemSize = CGSize(width: cellWidth/2, height: cellWidth/1.5) //셀 2개
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 30
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        collectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.identifier)
        return collectionView
    }()
    var sortButtonStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    let totalLabel = {
        let label = UILabel()
        label.textColor = .green
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    let sortSimButton = {
        let button = SortButton(setTitle: "정확도")
        return button
    }()
    let sortDateButton = {
        let button = SortButton(setTitle: "날짜순")
        return button
    }()
    let sortDscButton = {
        let button = SortButton(setTitle: "가격높은순")
        return button
    }()
    let sortAscButton = {
        let button = SortButton(setTitle: "가격낮은순")
        return button
    }()
    
    let viewModel = ShoppingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHiearachy()
        configureLayout()
        configureView()
                
        //self.navigationItem.title = "\(searchBarToss)"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backItem?.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.backgroundColor = .black
        
        //callRequst(page: 2, start: count, sortIndex: buttonCheck)
        
        sortSimButton.addTarget(self, action: #selector(sortSimButtomClicked), for: .touchUpInside)
        sortDateButton.addTarget(self, action: #selector(sortDateButtomClicked), for: .touchUpInside)
        sortDscButton.addTarget(self, action: #selector(sortDscButtomClicked), for: .touchUpInside)
        sortAscButton.addTarget(self, action: #selector(sortAscButtomClicked), for: .touchUpInside)
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
        
        viewModel.output.naviTitle.bind {
            let title = self.viewModel.output.naviTitle.value
            print("타이틀 받음adijflaij, \(title)")
            self.navigationItem.title = title
        }
        viewModel.output.shoppingList.bind {
            self.list = self.viewModel.output.shoppingList.value
            self.shoppingCollectionView.reloadData()
        }
    }
    
    @objc func sortSimButtomClicked() {
        print("정확도 버튼 눌림")
        buttonCheck = 1
        list.removeAll()
        viewModel.input.sortTypeTrigger.value = buttonCheck
        shoppingCollectionView.reloadData()
    }
    @objc func sortDateButtomClicked() {
        print("날짜순 버튼 눌림")
        buttonCheck = 2
        list.removeAll()
        viewModel.input.sortTypeTrigger.value = buttonCheck
        shoppingCollectionView.reloadData()
    }
    @objc func sortDscButtomClicked() {
        print("가격높은순 버튼 눌림")
        buttonCheck = 3
        list.removeAll()
        viewModel.input.sortTypeTrigger.value = buttonCheck
        shoppingCollectionView.reloadData()

    }
    @objc func sortAscButtomClicked() {
        print("가격낮은순 버튼 눌림")
        buttonCheck = 4
        list.removeAll()
        viewModel.input.sortTypeTrigger.value = buttonCheck
        shoppingCollectionView.reloadData()
    }
    
    //네이버 API 요청
//    func callRequst(page: Int, start: Int, sortIndex: Int) {
//        print("sort는 \(sortIndex), count는\(count)")
//        //print(#function, "첫번째")
//        let urlFormat = "https://openapi.naver.com/v1/search/shop.json?query=\(searchBarToss)&display=30&start=\(start)&sort=\(sorts[sortIndex])"
//        let removePart = "&sort=\(sorts[sortIndex])"
//        
//        url = urlFormat
//        
//        if page > 1 && sortIndex == 0 {
//            print("\(page)페이지 : 정렬버튼X")
//            if let range = url.range(of: removePart) {
//                url.removeSubrange(range)
//            }
//            print("페이지수로 url삭제체크 : \(url)")
//        } else { //page가 0,1일때
//            print("\(page)페이지 : 정렬버튼O")
//            print("페이지수로 url체크 : \(url)")
//        }
//        fixUrl = url
//        //url.append(sort)
//        //url.append("\(query)&display=100")
//        
//        let header: HTTPHeaders = ["X-Naver-Client-Id": "xA5LXXctMDL0kfcaEa4x",
//                                   "X-Naver-Client-Secret": "xspwBdaWWj"]
//        AF.request(fixUrl, method: .get, headers: header)
//            .validate(statusCode: 200..<300)
//            .responseDecodable(of: ShoppingList.self) { response in
//            //print(#function, "두번째")
//            switch response.result {
//            case .success(let value):
//                print("success")
//                
//                self.list.append(contentsOf: value.items)
//                self.total = value.total
//                
//                self.shoppingCollectionView.reloadData() //데이터 갱신 후 잊지 않기!
////                self.recommendCollectionView.reloadData()
//
//                if start == 1 {
//                    self.shoppingCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
//                }
//
//            case .failure(let error):
//                self.showAlert(title: "데이터를 가져오는데 실패했습니다.", message: "", ok: "확인")
//                print("fail", error)
//            }
//        }
//        //print(#function, "세번째")
//        print("url체크 : \(fixUrl)")
//    }
}

extension ShoppingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        totalLabel.text = "\(list.count)개의 검색결과"
        //totalLabel.text = "\(total)개의 검색결과"

        
//        
//        if collectionView == recommendCollectionView {
//            print("카운트체크1 \(list.count)")
//            return list.count
//        } else {
//            print("카운트체크2 \(list.count)")
//            return list.count
//        }

        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        //let bottomCell =  collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as! RecommendCollectionViewCell
        //print("indexPath.item체크 :\(indexPath.item)")
        
//        if collectionView == recommendCollectionView {
//            print("체크1")
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as! RecommendCollectionViewCell
//            
//            let item = list[indexPath.item]
//            let url = URL(string: item.image)
//            cell.recommendImageView.kf.setImage(with: url)
//            return cell
//        } else {
//            print("체크2")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingCollectionViewCell.identifier, for: indexPath) as! ShoppingCollectionViewCell
            let item = list[indexPath.item]
            let url = URL(string: item.image)
            cell.shoppoingImageView.kf.setImage(with: url)
            cell.shoppingMallNameLabel.text = item.mallName
            cell.shoppingTitleLabel.text = item.title
            priceFormat.numberStyle = .decimal
            cell.shoppingPriceLabel.text = priceFormat.string(for: Int(item.lprice))
            return cell
//        }
    }
    
    //페이지네이션
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        // 30 > 60 > 90 > 120
//        // 27 > 57 > 87 > 117
//        // 1 > 2 > 3 > 4
//        print("indexPath.item : \(indexPath.item) ,list.count: \(list.count), self.total: \(self.total),")
//        //(list.count - 3)의 의미 : 다 보여주기 3개쯤 전에 미리 호출
//        if indexPath.item == (list.count - 3) && list.count < total { //네이버에서 제공하는 display(한번에 보여줄 수 있는 데이터 갯수) 최대값100, 여기선 30으로 설정: 30개로 최대 갯수를 설정했으니 27번째 데이터 보일때쯤 데이터 호출
//            print("현재 \(page)페이지 , 추정 총 페이지 \(total / 30)개")
//            if list.count < total {
//                print("\(page)페이지, 데이터 갯수 \(list.count)개")
//                page += 1
//                count += 30
//                callRequst(page: page, start: count, sortIndex: buttonCheck)
//            }
//        }
//    }
}

extension ShoppingViewController: DesignProtocol {
    
    func configureHiearachy() {
        shoppingCollectionView.delegate = self
        shoppingCollectionView.dataSource = self
        
//        recommendCollectionView.delegate = self
//        recommendCollectionView.dataSource = self
//        
        view.addSubview(shoppingCollectionView)
//        view.addSubview(recommendCollectionView)
        view.addSubview(totalLabel)
        view.addSubview(sortButtonStackView)
        sortButtonStackView.addArrangedSubview(sortSimButton)
        sortButtonStackView.addArrangedSubview(sortDateButton)
        sortButtonStackView.addArrangedSubview(sortDscButton)
        sortButtonStackView.addArrangedSubview(sortAscButton)
    }
    
    func configureLayout() {
        totalLabel.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(20)
        }
        sortButtonStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(totalLabel.snp.bottom).offset(5)
            make.bottom.equalTo(shoppingCollectionView.snp.top).offset(5)
            make.height.equalTo(50)
        }
        shoppingCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(sortButtonStackView.snp.bottom).offset(5)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            //make.bottom.equalTo(recommendCollectionView.snp.top).offset(-10)
        }
//        recommendCollectionView.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//            make.height.equalTo(120)
//        }
        
    }
    
    func configureView() {
        view.backgroundColor = .black
        //shoppingCollectionView.keyboardDismissMode = .onDrag
    }
}
