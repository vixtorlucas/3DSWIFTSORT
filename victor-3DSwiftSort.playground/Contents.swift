//: A UIKit based Playground for presenting user interface
//
//  ViewController.swift
/*

3D SWIFT SORT is a Playground that simulate an algorithm visualization made with SceneKit. To start using, select any of 3 avalible algorithm on the top. After it sort you can restart tapping the reload button at bottom, that will generate new block with diferent colors and values. At the configuration button you can select how much blocks will be used to the demo. Made for XCode Swift Playground.


*/
//  Created by Victor Lucas Deodato on 22/03/19.
//  Copyright © 2019. All rights reserved.


import UIKit
import SceneKit
import PlaygroundSupport

class ViewController: UIViewController {
	
	var scene = SCNScene()
	var boxes = [SCNBox]()
	var boxsnodes = [SCNNode]()
	var shouldRotateConfig: Bool = true
	var shouldTotateReload: Bool = true
	var numberOfBoxes: Int = 20
	var pickerData: [Int] = [Int]()
	
	let sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: 380, height: 700))
	let infoview = UIView(frame: CGRect(x: 165, y: 600, width: 45, height: 45))
	let confView = UIView(frame: CGRect(x: 260, y: 600, width: 45, height: 45))
	let uitext = UITextView(frame: CGRect(x: 5, y: 10, width: 220, height: 320))
	let uipickerView = UIPickerView(frame: CGRect(x: 5, y: 20, width: 220, height: 220))
	let hintText = UITextView(frame:  CGRect(x: 10, y: 230, width: 210, height: 130))
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		uipickerView.dataSource = self
		uipickerView.delegate = self
		
		self.view = loadView()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		createBoxes()
		
	}
	
	func loadView() -> UIView{
		
		// color
		let backColor = UIColor(red:0.85, green:0.89, blue:0.95, alpha:1.0)
		
		let view = UIView()
		
		view.backgroundColor = backColor
		
		//Create Logo
		
		let header = UIImageView(frame: CGRect(x: 40, y: 50, width: 300, height: 60))
		header.image = UIImage(named: "logo1")
		
		//Create buttons
		
		let button = UIButton(frame: CGRect(x: 30, y: 130, width: 90, height: 45))
		button.setImage(UIImage(named: "bubble"), for: .normal)
		button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
		
		let button2 = UIButton(frame: CGRect(x: 145, y: 130, width: 90, height: 45))
		button2.setImage(UIImage(named: "insertion"), for: .normal)
		button2.addTarget(self, action: #selector(self.buttonTapped2), for: .touchUpInside)
		
		let button3 = UIButton(frame: CGRect(x: 260, y: 130, width: 90, height: 45))
		button3.setImage(UIImage(named: "selection"), for: .normal)
		button3.addTarget(self, action: #selector(self.buttonTapped3), for: .touchUpInside)
		
		let button4 = UIButton(frame: CGRect(x: 70, y: 600, width: 45, height: 45))
		button4.setImage(UIImage(named: "reload"), for: .normal)
		button4.addTarget(self, action: #selector(self.buttonTappedReload), for: .touchUpInside)
		
		let button5 = UIButton(frame: CGRect(x: 165, y: 600, width: 45, height: 45))
		button5.setImage(UIImage(named: "about"), for: .normal)
		button5.addTarget(self, action: #selector(self.buttonTappedAbout), for: .touchUpInside)
		
		let button6 = UIButton(frame: CGRect(x: 260, y: 600, width: 45, height: 45))
		button6.setImage(UIImage(named: "config"), for: .normal)
		button6.tag = 6
		button6.addTarget(self, action: #selector(self.buttonTappedConfig), for: .touchUpInside)
		
		// configure Views
		
		infoview.backgroundColor = UIColor(red:0.31, green:0.49, blue:0.74, alpha:1)
		infoview.isHidden = true
		
		uitext.text = "Hello! Welcome to \n3D SWIFT SORT! \n\nThis playground was developed by Victor Lucas Deodato to present the 3D visualization of three of the main sorting algorithms: the bubble sort, the insertion sort and the selection sort. \n\nTo see this playground running, you just need to select one of the three buttons in the top. And if you want to generate new random values for the size of the blocks, just click the reload button, the first one in the bottom. \n\nOh! And it is in the settings button, the last one in the bottom, that you can set the number of blocks to display! \n\nEnjoy! ;)"
		uitext.textColor = UIColor.white
		uitext.allowsEditingTextAttributes = false
		uitext.isEditable = false
		uitext.textAlignment = .center
		uitext.backgroundColor = .clear
		uitext.isSelectable = false
		uitext.font = UIFont.systemFont(ofSize: 15)
		uitext.isHidden = true
		
		for i in 1...50{
			pickerData.append(i)
		}
		
		uipickerView.isHidden = true
		
		hintText.text = "Select the value and press the reload button to apply. After that, press BUBBLE, INSERTION or SELECTION to run the algorithm."
		hintText.font = UIFont.systemFont(ofSize: 15)
		hintText.textColor = UIColor.white
		hintText.isEditable = false
		hintText.textAlignment = .center
		hintText.backgroundColor = .clear
		hintText.isSelectable = false
		hintText.isHidden = true
		hintText.isScrollEnabled = false
		
		confView.backgroundColor = UIColor(red:0.31, green:0.49, blue:0.74, alpha:1)
		confView.isHidden = true
		
		sceneView.backgroundColor = backColor
		
		sceneView.scene = scene
		sceneView.isPlaying = true
	
		// default lighting
		
		sceneView.autoenablesDefaultLighting = true
		
		// Camera
		
		sceneView.allowsCameraControl = true
		sceneView.cameraControlConfiguration.autoSwitchToFreeCamera = true
		
		view.addSubview(sceneView)
		view.addSubview(infoview)
		infoview.addSubview(uitext)
		view.addSubview(confView)
		confView.addSubview(uipickerView)
		confView.addSubview(hintText)
		view.addSubview(header)
		view.addSubview(button)
		view.addSubview(button2)
		view.addSubview(button3)
		view.addSubview(button4)
		view.addSubview(button5)
		view.addSubview(button6)
		
		return view
	}
	
	// Create Boxs function
	func createBoxes() {
		
		let red:CGFloat  = .random(in: 0 ... 1)
		let green:CGFloat  = .random(in: 0 ... 1)
		let blue:CGFloat  = .random(in: 0 ... 1)
		
		boxes = []
		boxsnodes = []
		
		for i in 0...numberOfBoxes - 1{
			
			DispatchQueue.main.async {
				
				let number = Int.random(in: 0 ..< 300) + 30
				let colornumber = 330
				let box = SCNBox(width:(CGFloat(number)), height: 10, length: 10, chamferRadius: 0)
				let boxNode = SCNNode(geometry: box)
				let a = CGFloat(integerLiteral: number)
				let b = CGFloat(integerLiteral: Int(colornumber - number))
				let redColor = CGFloat((a*red)/CGFloat(integerLiteral: colornumber))
				let blueColor = CGFloat((b*blue)/CGFloat(integerLiteral: colornumber))
				
				boxNode.position = SCNVector3(0,((-self.numberOfBoxes)/2)+(10*i), 0)
				box.firstMaterial?.diffuse.contents = UIColor(red:redColor,green: green, blue:blueColor, alpha: 1)
				box.firstMaterial?.isDoubleSided = true
				
				self.boxes.append(box)
				self.boxsnodes.append(boxNode)
				self.scene.rootNode.addChildNode(boxNode)
			}
			
		}

	}
	
	// Buttons actions fuctions
	
	@objc func buttonTapped(sender : UIButton) {
		
		sortBuble(box: boxes, boxNode: boxsnodes)
	}
	
	@objc func buttonTapped3(sender: UIButton) {
		
		selectionSort(box: boxes, boxNode: boxsnodes)
	}
	
	@objc func buttonTappedReload(sender: UIButton) {
		
		UIView.animate(withDuration: 0.6, animations: {
			
			if self.shouldRotateConfig{
				
				sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
				self.shouldRotateConfig = false
			}else{
				
				sender.transform = CGAffineTransform(rotationAngle: 0)
				self.shouldRotateConfig = true
			}
			
		})
		
		for i in self.boxsnodes{
			
			i.removeFromParentNode()
		}
		
		self.createBoxes()
	}
	
	@objc func buttonTappedConfig(sender: UIButton){
			
			UIView.animate(withDuration: 0.6, animations: {
				
				if self.shouldRotateConfig{
					
					sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
					
					self.shouldRotateConfig = false
				}else{
					sender.transform = CGAffineTransform(rotationAngle: 0)

					self.shouldRotateConfig = true
				}
				
			})
			
			UIView.animate(withDuration: 0.3, animations: {
				
				if  self.confView.isHidden{
					
					self.confView.isHidden = false
					self.confView.frame.origin.x = 75
					self.confView.frame.origin.y = 200
					self.confView.frame.size.width = 230
					self.confView.frame.size.height = 350
					self.confView.layer.cornerRadius = 15
					self.uipickerView.isHidden = false
					self.uipickerView.selectRow(self.numberOfBoxes - 1, inComponent: 0, animated: false)
					self.uipickerView.reloadAllComponents()
					self.hintText.isHidden = false
					
				}else{
					
					self.confView.frame.origin.x = 250
					self.confView.frame.origin.y = 600
					self.confView.frame.size.width = 45
					self.confView.frame.size.height = 45
					self.confView.layer.cornerRadius = 15
					self.confView.isHidden = true
					self.uipickerView.isHidden = true
					self.hintText.isHidden = true
				}
			})
		
	}
	
	@objc func buttonTapped2(sender : UIButton) {
		
		insertionSort(box: boxes, boxNode: boxsnodes)
	}
	
	@objc func buttonTappedAbout(sender: UIButton) {
		
		let image1 = UIImage(named: "about")
		let image2 = UIImage(named: "about2")
		let image3 = UIImage(named: "about3")
		
		sender.imageView?.animationImages = [image1,image2,image3,image3,image2,image1] as? [UIImage]
		sender.imageView?.animationRepeatCount = 2
		sender.imageView?.startAnimating()
		
		UIView.animate(withDuration: 0.3, animations: {
			
			if self.infoview.isHidden{
				
				self.infoview.isHidden = false
				self.infoview.frame.origin.x = 75
				self.infoview.frame.origin.y = 200
				self.infoview.frame.size.width = 230
				self.infoview.frame.size.height = 350
				self.infoview.layer.cornerRadius = 15
				self.uitext.isHidden = false
				
			}else{
				
				self.infoview.frame.origin.x = 165
				self.infoview.frame.origin.y = 600
				self.infoview.frame.size.width = 45
				self.infoview.frame.size.height = 45
				self.infoview.layer.cornerRadius = 15
				self.infoview.isHidden = true
				self.uitext.isHidden = true
			}
		})
		
	}
	
	// Algorithm Fuctions
	
	func insertionSort(box: [SCNBox], boxNode: [SCNNode]){
		
		var a = box
		var b = boxNode
		var timer: Timer?
		var time: Int = 0
		var interations: Int = 0
		
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
			time += 1
		})
		
		DispatchQueue.global().async { [weak self] in
			
			let serialQueue = DispatchQueue(label: "queuename")
			
			for x in 1..<a.count {
				
				var y = x
				while y > 0 && a[y].width < a[y - 1].width { // 3
					
					serialQueue.sync{
						
						let num1 = b[y].position.y
						let num2 = b[y-1].position.y
						
						let moveTo1 = SCNAction.move(to: SCNVector3(0,num2, -25), duration: TimeInterval(0.1))
						let moveTo2 = SCNAction.move(to: SCNVector3(0,num2, 0), duration: TimeInterval(0.1))
						let move1 = SCNAction.move(to: SCNVector3(0,num1, 25), duration: TimeInterval(0.1))
						let move2 = SCNAction.move(to: SCNVector3(0,num1, 0), duration: TimeInterval(0.1))
						
						interations += 1
						
						let dispatchSemaphore = DispatchSemaphore(value: 0)
						
						DispatchQueue.main.async {
							b[y].runAction(moveTo1) {
								
								b[y].runAction(moveTo2) {
								}
								
							}
							
							b[y-1].runAction(move1) {
								
								b[y-1].runAction(move2) {
									
									let tmp = a[y]
									a[y] = a[y-1]
									a[y-1] = tmp
									
									let tmp2 = b[y]
									b[y] = b[y-1]
									b[y-1] = tmp2
									
									dispatchSemaphore.signal()
								}
								
							}
							
						}
						
						dispatchSemaphore.wait(timeout: .now() + 4)
						
					}
					y -= 1
				}
			}
			
			serialQueue.sync{
				
				if box == self?.boxes{
					
					timer?.invalidate()
					let alert = UIAlertController(title: "WELL DONE!", message: "Interations: \(interations)\n\nAlgorithm time: \(time)s\n\nClick on the reload button to get new values for sorting!", preferredStyle: UIAlertController.Style.alert)
					alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
					self?.present(alert, animated: true, completion: nil)
					
					self?.boxes = a
					self?.boxsnodes = b
				}
			}
			
		}
		
	}
	
	func sortBuble(box: [SCNBox], boxNode: [SCNNode]) {
		
		var a = box
		var b = boxNode
		var timer: Timer?
		var time: Int = 0
		var interations: Int = 0
		
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
			time += 1
		})
		
		DispatchQueue.global().async { [weak self] in
			
			let serialQueue = DispatchQueue(label: "queuename")
			
			for i in 0..<a.count {
				
				for j in 1..<a.count {
					
					serialQueue.async {
						
						if a[j].width < a[j-1].width  {
							
							let num1 = b[j].position.y
							let num2 = b[j-1].position.y
							
							let moveTo1 = SCNAction.move(to: SCNVector3(0,num2, -25), duration: TimeInterval(0.1))
							let moveTo2 = SCNAction.move(to: SCNVector3(0,num2, 0), duration: TimeInterval(0.1))
							let move1 = SCNAction.move(to: SCNVector3(0,num1, 25), duration: TimeInterval(0.1))
							let move2 = SCNAction.move(to: SCNVector3(0,num1, 0), duration: TimeInterval(0.1))
							
							interations += 1
							
							let dispatchSemaphore = DispatchSemaphore(value: 0)
							
							DispatchQueue.main.async {
								
								b[j].runAction(moveTo1) {
									
									b[j].runAction(moveTo2) {
									}
									
								}
								
								b[j-1].runAction(move1) {
									
									b[j-1].runAction(move2) {
										
										let tmp = a[j]
										a[j] = a[j-1]
										a[j-1] = tmp
										
										let tmp2 = b[j]
										b[j] = b[j-1]
										b[j-1] = tmp2
										
										
										dispatchSemaphore.signal()
									}
									
								}
								
							}
							
							dispatchSemaphore.wait(timeout: .now() + 4)
							
						}
						
					}
					
				}
				
			}
			serialQueue.sync{
				
				if box == self?.boxes{
					
					timer?.invalidate()
					
					let alert = UIAlertController(title: "WELL DONE!", message: "Interations: \(interations)\n\nAlgorithm time: \(time)s\n\nClick on the reload button to get new values for sorting!", preferredStyle: UIAlertController.Style.alert)
					alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
					
					self?.present(alert, animated: true, completion: nil)
					self?.boxes = a
					self?.boxsnodes = b
				}
			}
			
		}
		
	}
	
	func selectionSort(box: [SCNBox], boxNode: [SCNNode]) {
		
		var a = box
		var b = boxNode
		var interations: Int = 0
		var timer: Timer?
		var time: Int = 0
		
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
			time += 1
		})// 2

		DispatchQueue.global().async { [weak self] in
			
			let serialQueue = DispatchQueue(label: "queuename")

			for x in 0 ..< a.count - 1 {     // 3
				
				serialQueue.async {
					
					var lowest = x
					
					for y in x + 1 ..< a.count {   // 4
						if a[y].width < a[lowest].width {
							lowest = y
						}
					}
				
					if x != lowest {               // 5
						
						let num1 = b[x].position.y
						let num2 = b[lowest].position.y
						
						let moveTo1 = SCNAction.move(to: SCNVector3(0,num2, -25), duration: TimeInterval(0.1))
						let moveTo2 = SCNAction.move(to: SCNVector3(0,num2, 0), duration: TimeInterval(0.1))
						let move1 = SCNAction.move(to: SCNVector3(0,num1, 25), duration: TimeInterval(0.1))
						let move2 = SCNAction.move(to: SCNVector3(0,num1, 0), duration: TimeInterval(0.1))
						
						interations += 1
						
						let dispatchSemaphore = DispatchSemaphore(value: 0)
						
						DispatchQueue.main.async {
							
							b[x].runAction(moveTo1) {
								
								b[x].runAction(moveTo2) {
								}
								
							}
							
							b[lowest].runAction(move1) {
								
								b[lowest].runAction(move2) {
									
									a.swapAt(x, lowest)
									b.swapAt(x, lowest)
									
									dispatchSemaphore.signal()
								}
								
							}
							
						}
						
						dispatchSemaphore.wait(timeout: .now() + 4)
						
					}
				}
			}
			
			serialQueue.async{
				
				if box == self?.boxes{
					
					timer?.invalidate()
					let alert = UIAlertController(title: "WELL DONE!", message: "Interations: \(interations)\n\nAlgorithm time: \(time)s\n\nClick on the reload button to get new values for sorting!", preferredStyle: UIAlertController.Style.alert)
					alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
					
					self?.present(alert, animated: true, completion: nil)
					self?.boxes = a
					self?.boxsnodes = b
				}
			}
		}
		
	}
	
}

extension ViewController: UIPickerViewDelegate,UIPickerViewDataSource{
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		return pickerData.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		return "\(pickerData[row])"
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		numberOfBoxes = pickerData[row]
	}
	
	
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = ViewController()

