//
//  SLTMapDetailViewController.swift
//  Solity Demo
//
//  Created by Solity 013 on 2021/11/25.
//

import UIKit
import CoreLocation

class SLTMapDetailViewController: UIViewController {

    let kHeight_SegmentBackground: CGFloat = 60
    let kHeight_BottomControlView: CGFloat = 300
    
    var selectedLocation: CLLocation!
    
    var lockAnnotation: BMKPointAnnotation!
    //复用annotationView的指定唯一标识
    let annotationViewIdentifier = "com.SolityChina.BaiduMapDemo.annotationView"
    
    private var _searchDataArray: NSMutableArray!
    let cellIdentifier = "com.SolityChina.BaiduMapDemo.searchResultTableViewCell"
    
    //MARK:Initialization method
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(nibName: nil, bundle: nil)
    }
    
    //MARK:View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _searchDataArray = NSMutableArray.init()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
        mapView.viewWillAppear()
        //开启定位服务
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //当mapView即将被隐藏的时候调用，存储当前mapView的状态
        mapView.viewWillDisappear()
    }
    
    //MARK:Config UI
    func configUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = COLOR(0xFFFFFF)
        view.backgroundColor = COLOR(0xFFFFFF)
        view.addSubview(mapSegmentControl)
        //将mapView添加到当前视图中
        view.addSubview(mapView)
        view.addSubview(tableView)
    }
    
    //MARK:Responding events
    @objc func segmentControlDidChangeValue(_ segmented: UISegmentedControl) {
        switch segmented.selectedSegmentIndex {
        case 0:
            //设置当前地图语言为英文
            mapView.languageType = kBMKMapLanguageTypeEnglish
        case 1:
            //设置当前地图语言为中文
            mapView.languageType = kBMKMapLanguageTypeChinese
        default:
            //默认当前地图语言为英文
            mapView.languageType = kBMKMapLanguageTypeEnglish
            break
        }
    }
    
    
    lazy var mapSegmentControl: UISegmentedControl = {
       let segmentControl = UISegmentedControl.init(items: ["英文地图", "中文地图"])
        segmentControl.frame = CGRect(x: 10 * widthScale, y: 12.5, width: 355 * widthScale, height: 35)
        segmentControl.setTitle("英文地图", forSegmentAt: 0)
        segmentControl.setTitle("中文地图", forSegmentAt: 1)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self , action: #selector(segmentControlDidChangeValue), for: UIControl.Event.valueChanged)
        return segmentControl
    }()
    
    lazy var mapView: BMKMapView = {
        let mapView = BMKMapView(frame: CGRect(x: 0, y: kHeight_SegmentBackground, width: KScreenWidth, height: KScreenHeight - kViewTopHeight - kHeight_SegmentBackground - kHeight_BottomControlView - KiPhoneXSafeAreaDValue))
        //设置mapView的代理
        mapView.delegate = self
        mapView.userTrackingMode = BMKUserTrackingModeNone
        mapView.zoomLevel = 17
        //显示定位图层
        mapView.showsUserLocation = true
        return mapView
    }()
    
    lazy var locationManager: CLLocationManager = {
        //初始化BMKLocationManager的实例
        let manager = CLLocationManager()
        //设置定位管理类实例的代理
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame:CGRect(x:0, y:KScreenHeight - KiPhoneXSafeAreaDValue - kHeight_BottomControlView - kViewTopHeight, width:KScreenWidth, height:kHeight_BottomControlView), style:UITableView.Style.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableView
    }()
    
    
    //MARK: UserAction
    func creatAndAddAnnotation() {
        if lockAnnotation != nil {
            mapView.removeAnnotation(lockAnnotation)
        }
        
        setupDefaultData()
        //初始化标注类BMKPointAnnotation的实例
        lockAnnotation = BMKPointAnnotation.init()
        //设置标注的经纬度坐标
        lockAnnotation.coordinate = selectedLocation.coordinate
        //设置标注的标题
        let title = String(format: "门锁位置：(latitude:%f,longitude:%f)", selectedLocation.coordinate.latitude, selectedLocation.coordinate.longitude)
        lockAnnotation.title = title
        //副标题
        lockAnnotation.subtitle = "可拖拽选择门锁位置"
        /**
         当前地图添加标注，需要实现BMKMapViewDelegate的-mapView:viewForAnnotation:方法
         来生成标注对应的View
         @param annotation 要添加的标注
         */
        mapView.addAnnotation(lockAnnotation)
        
        mapView.setCenter(selectedLocation.coordinate, animated: true)
    }
    
    //MARK:Search Data
    func setupDefaultData() {
        //初始化请求参数类BMKNearbySearchOption的实例
        let nearbyOption = BMKPOINearbySearchOption()
        //检索关键字
        nearbyOption.keywords = ("房地产").components(separatedBy: ",")
        //检索的中心点
        nearbyOption.location = selectedLocation.coordinate
        searchData(nearbyOption)
    }
    
    func searchData(_ option: BMKPOINearbySearchOption) {
        //初始化BMKPoiSearch实例
        let POISearch = BMKPoiSearch()
        //设置POI检索的代理
        POISearch.delegate = self
        //初始化请求参数类BMKNearbySearchOption的实例
        let nearbyOption = BMKPOINearbySearchOption()
        /**
         检索关键字，必选。
         在周边检索中关键字为数组类型，可以支持多个关键字并集检索，如银行和酒店。每个关键字对应数组一个元素。
         最多支持10个关键字。
         */
        nearbyOption.keywords = option.keywords
        //检索中心点的经纬度，必选
        nearbyOption.location = option.location
        /**
         检索半径，单位是米。
         当半径过大，超过中心点所在城市边界时，会变为城市范围检索，检索范围为中心点所在城市
         */
        nearbyOption.radius = option.radius
        /**
         检索分类，可选。
         该字段与keywords字段组合进行检索。
         支持多个分类，如美食和酒店。每个分类对应数组中一个元素
         */
        nearbyOption.tags = option.tags
        /**
         是否严格限定召回结果在设置检索半径范围内。默认值为false。
         值为true代表检索结果严格限定在半径范围内；值为false时不严格限定。
         注意：值为true时会影响返回结果中total准确性及每页召回poi数量，我们会逐步解决此类问题。
         */
        nearbyOption.isRadiusLimit = option.isRadiusLimit
        /**
         POI检索结果详细程度
         
         BMK_POI_SCOPE_BASIC_INFORMATION: 基本信息
         BMK_POI_SCOPE_DETAIL_INFORMATION: 详细信息
         */
        nearbyOption.scope = option.scope
        //检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
        nearbyOption.filter = option.filter
        //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
        nearbyOption.pageIndex = option.pageIndex
        //单次召回POI数量，默认为10条记录，最大返回20条。
        nearbyOption.pageSize = option.pageSize
        /**
         根据中心点、半径和检索词发起周边检索：异步方法，返回结果在BMKPoiSearchDelegate
         的onGetPoiResult里
         
         nearbyOption 周边搜索的搜索参数类
         成功返回YES，否则返回NO
         */
        let flag = POISearch.poiSearchNear(by: nearbyOption)
        if flag {
            NSLog("POI周边检索成功")
        } else {
            NSLog("POI周边检索失败")
        }
    }
}


extension SLTMapDetailViewController: BMKMapViewDelegate {
    
    /**
     根据anntation生成对应的annotationView
     
     @param mapView 地图View
     @param annotation 指定的标注
     @return 生成的标注View
     */
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation.isKind(of: BMKPointAnnotation.self) {
            /**
             根据指定标识查找一个可被复用的标注，用此方法来代替新创建一个标注，返回可被复用的标注
             */
            var annotationView: BMKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewIdentifier) as? BMKPinAnnotationView
            if annotationView == nil {
                /**
                 初始化并返回一个annotationView
                 
                 @param annotation 关联的annotation对象
                 @param reuseIdentifier 如果要重用view，传入一个字符串，否则设为nil，建议重用view
                 @return 初始化成功则返回annotationView，否则返回nil
                 */
                annotationView = BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: annotationViewIdentifier)
                /**
                 默认情况下annotationView的中心点位于annotation的坐标位置，可以设置centerOffset改变
                 annotationView的位置，正的偏移使annotationView朝右下方移动，负的朝左上方，单位是像素
                 */
                annotationView?.centerOffset = CGPoint(x: 0, y: 0)
                /**
                 默认情况下, 弹出的气泡位于annotationView正中上方，可以设置calloutOffset改变annotationView的
                 位置，正的偏移使annotationView朝右下方移动，负的朝左上方，单位是像素
                 */
                annotationView?.calloutOffset = CGPoint(x: 0, y: 0)
                //是否显示3D效果，标注在地图旋转和俯视时跟随旋转、俯视，默认为NO
                annotationView?.enabled3D = false
                //是否忽略触摸时间，默认为YES
                annotationView?.isEnabled = true
                /**
                 开发者可以直接设置这个属性，默认为NO，当设置为YES时annotationView默认选中，并弹出气泡
                 */
                annotationView?.isSelected = true
                //annotationView被选中时，是否显示气泡（若显示，annotation必须设置了title），默认为YES
                annotationView?.canShowCallout = true
                /**
                 annotationView的颜色： BMKPinAnnotationColorRed，BMKPinAnnotationColorGreen，
                 BMKPinAnnotationColorPurple
                 */
                annotationView?.pinColor = UInt(BMKPinAnnotationColorRed)
                //设置从天而降的动画效果
                annotationView?.animatesDrop = true
                //当设为YES并实现了setCoordinate:方法时，支持将annotationView在地图上拖动
                annotationView?.isDraggable = true
            }
            annotationView?.isSelected = true
            return annotationView
        }
        return nil
    }
    
    /**
     点击地图标注会回调此方法
     
     @param mapView 地图View
     @param mapPoi 返回点击地图地图坐标点的经纬度
     */
    func mapView(_ mapView: BMKMapView!, onClickedMapPoi mapPoi: BMKMapPoi!) {
        selectedLocation = CLLocation.init(latitude: mapPoi.pt.latitude, longitude: mapPoi.pt.longitude)
        creatAndAddAnnotation()
    }
    
    /**
     点击地图非标注区域会回调此方法
     
     @param mapView 地图View
     @param coordinate 返回点击地图非标注区域地图坐标点的经纬度
     */
    func mapView(_ mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        selectedLocation = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        creatAndAddAnnotation()
    }
    
    /**
     *拖动annotation view时，若view的状态发生变化，会调用此函数。ios3.2以后支持
     *@param mapView 地图View
     *@param view annotation view
     *@param newState 新状态
     *@param oldState 旧状态
     */
    func mapView(_ mapView: BMKMapView!, annotationView view: BMKAnnotationView!, didChangeDragState newState: UInt, fromOldState oldState: UInt) {
        if newState == BMKAnnotationViewDragStateEnding {
            
            view.dragState = UInt(BMKAnnotationViewDragStateNone)
            
            let tempLocation = CLLocation.init(latitude: view.annotation.coordinate.latitude, longitude: view.annotation.coordinate.longitude)
            selectedLocation = tempLocation
//            let tempPointAnnotation = view.annotation as! BMKPointAnnotation
//            print("title000 === \(String(describing: view.annotation.title?()))")
//            //修改标注的标题
//            let title = String(format: "门锁位置：(latitude:%f,longitude:%f)", selectedLocation.coordinate.latitude, selectedLocation.coordinate.longitude)
//            print("title111 === \(title)")
//            tempPointAnnotation.title = title
//            print("title222 === \(String(describing: view.annotation.title?()))")
//            mapView.setCenter(selectedLocation.coordinate, animated: true)
            creatAndAddAnnotation()
        }
    }
}


extension SLTMapDetailViewController: CLLocationManagerDelegate {
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if selectedLocation != nil { return }
        
        selectedLocation = location
        manager.stopUpdatingLocation()
                
        let bmkUserLocation = BMKUserLocation()
        bmkUserLocation.location = location
        //实现该方法，否则定位图标不出现
        mapView.updateLocationData(bmkUserLocation)
        let param = BMKLocationViewDisplayParam()
        //设置显示精度圈
        param.isAccuracyCircleShow = true
        //更新定位图层个性化样式
        mapView.updateLocationView(with: param)
        
        creatAndAddAnnotation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败")
    }
}

//MARK: UITableViewDataSource & UITableViewDelegate
extension SLTMapDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _searchDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let tempResult: BMKPoiInfo = (_searchDataArray.object(at: indexPath.row)) as! BMKPoiInfo
        let text = String(format: "%@(latitude:%f,longitude:%f)", tempResult.name, tempResult.pt.latitude, tempResult.pt.longitude)
        cell.textLabel?.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tempResult: BMKPoiInfo = (_searchDataArray.object(at: indexPath.row)) as! BMKPoiInfo
        let tempLocation = CLLocation.init(latitude: tempResult.pt.latitude, longitude: tempResult.pt.longitude)
        selectedLocation = tempLocation
        creatAndAddAnnotation()
    }
}

//MARK: - BMKPoiSearchDelegate
extension SLTMapDetailViewController: BMKPoiSearchDelegate {
    
    /**
     POI检索返回结果回调
     
     @param searcher 检索对象
     @param poiResult POI检索结果列表
     @param error 错误码
     */
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPOISearchResult!, errorCode: BMKSearchErrorCode) {
        _searchDataArray.removeAllObjects()
        _searchDataArray.addObjects(from: poiResult.poiInfoList)
        tableView.reloadData()
    }
}
