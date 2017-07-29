import UIKit

class RDMainViewController: UINavigationController {
    
    var tabController: RDTopTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isTranslucent = false
        self.navigationBar.shadowImage = #imageLiteral(resourceName: "TransparentPixel")
        self.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "Pixel"), for: .default)
        
        let vc1 = RDTableViewController(title: "California", tableData: self.californiaData)
        let vc2 = RDTableViewController(title: "Oregon", tableData: oregonData)
        let vc3 = RDTableViewController(title: "Washington", tableData: self.washingtonData)
        
        let tabController = RDTopTabBarController()
        tabController.title = "Pacific Crest Trail"
        tabController.setViewControllers([vc1, vc2, vc3], animated: false)
        self.tabController = tabController
        
        self.pushViewController(tabController, animated: false)
    }
    
    let californiaData = [
        "Laguna Mountains",
        "Anza-Borrego Desert",
        "San Felipe Hills",
        "San Jacinto Mountains",
        "Mt. San Jacinto",
        "San Gorgonio Wilderness",
        "San Bernardino Mountains",
        "San Gabriel Mountains",
        "Mt. Baden-Powell",
        "Mojave Desert",
        "Tehachapi Mountains",
        "The Sierra Nevada",
        "Kennedy Meadows",
        "The High Sierra",
        "Sequoia-Kings Canyon National Parks",
        "John Muir Trail",
        "Mt. Whitney",
        "John Muir Wilderness",
        "Ansel Adams Wilderness",
        "Yosemite National Park",
        "Desolation Wilderness",
        "Granite Chief Wilderness",
        "Donner Pass",
        "Sierra Buttes",
        "Lassen Volcanic National Park",
        "Hat Creek Rim",
        "Burney Falls State Park",
        "Secion “O”",
        "Mt. Shasta",
        "Castle Crags Wilderness",
        "Trinity Alps Wilderness",
        "Russian Wilderness",
        "Etna, California",
        "Marble Mountain Wilderness"
    ]
    
    let oregonData = [
        "Eagle Creek",
        "Mt. Hood",
        "Mt. Jefferson",
        "Three Fingered Jack",
        "Mt. Washington",
        "Three Sisters Wilderness",
        "Diamond Peak Wilderness",
        "Mt. Thielsen Wilderness",
        "Crater Lake National Park",
        "Sky Lakes Wilderness",
        "Mt. McLoughlin"
    ]
    
    let washingtonData = [
        "Pasayten Wilderness",
        "North Cascades National Park",
        "Glacier Peak Wilderness",
        "Alpine Lakes Wilderness",
        "Mt. Rainier",
        "Goat Rocks",
        "Mt. Adams",
        "Columbia River"
    ]
}
