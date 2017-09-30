//
//  ViewController.swift
//  Homework2
//
//  Created by Lauren Champeau on 9/27/17.
//  Copyright © 2017 Lauren Champeau. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let imageURLs = Array<String>(arrayLiteral: "https://upload.wikimedia.org/wikipedia/commons/d/d8/NASA_Mars_Rover.jpg", "http://www.wired.com/wp-content/uploads/images_blogs/wiredscience/2012/08/Mars-in-95-Rover1.jpg", "http://news.brown.edu/files/article_images/MarsRover1.jpg", "http://www.nasa.gov/images/content/482643main_msl20100916-full.jpg", "https://upload.wikimedia.org/wikipedia/commons/f/fa/Martian_rover_Curiosity_using_ChemCam_Msl20111115_PIA14760_MSL_PIcture-3-br2.jpg", "http://mars.nasa.gov/msl/images/msl20110602_PIA14175.jpg", "http://i.kinja-img.com/gawker-media/image/upload/iftylroaoeej16deefkn.jpg", "http://www.nasa.gov/sites/default/files/thumbnails/image/journey_to_mars.jpeg", "http://i.space.com/images/i/000/021/072/original/mars-one-colony-2025.jpg?1375634917", "http://cdn.phys.org/newman/gfx/news/hires/2015/earthandmars.png")
    var tableImages = Array<UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func beginDownloadsPressed(_ sender: UIButton) {
        let bgTimeRemaining = UIApplication.shared.backgroundTimeRemaining
        let backgroundQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        backgroundQueue.async {
            var backgroundTask : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
            backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                UIApplication.shared.endBackgroundTask(backgroundTask)
                backgroundTask = UIBackgroundTaskInvalid
                })

            for i in 0 ... self.imageURLs.count - 1{
                if (bgTimeRemaining < 6) {
                    break;
                }
                let imgURL = self.imageURLs[i]
                let image = UIImage(data: try! Data(contentsOf: URL(string: imgURL)!))
                Thread.sleep(forTimeInterval: 1)
                self.tableImages.append(image!)
                DispatchQueue.main.sync{
                    let rowIndex = i; //your row index where you want to add cell
                    let sectionIndex = 0;//your section index
                    let iPath : IndexPath = IndexPath(row: rowIndex, section: sectionIndex)
                    self.tableView.insertRows(at: [iPath], with: UITableViewRowAnimation.left)
                }
            }
            
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = UIBackgroundTaskInvalid
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        let image : UIImage = self.tableImages[indexPath.row]
        cell.imageView?.image = image
        cell.textLabel?.text = self.imageURLs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableImages.count
    }
    
}

