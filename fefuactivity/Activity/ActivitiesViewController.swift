import UIKit

struct ParamsActivitiesTable {
    let date: String
    let cell: [ParamsTableCell]
}

class ActivitiesViewController: UIViewController {
    
    private let data: [ParamsActivitiesTable] = {
        let activity1: [ParamsTableCell] = [
            ParamsTableCell(distance: "14.32 км",
                            duration: "2 часа 46 минут",
                            timeAgo: "14 часов назад",
                            icon: UIImage(systemName: "bicycle.circle.fill"),
                            type: "Велосипед",
                            startTime: "14:49",
                            endTime: "16:31"
                           )
        ]

        let activity2: [ParamsTableCell] = [
            ParamsTableCell(distance: "14.32 км",
                            duration: "2 часа 46 минут",
                            timeAgo: "14 часов назад",
                            icon: UIImage(systemName: "bicycle.circle.fill"),
                            type: "Велосипед",
                            startTime: "14:49",
                            endTime: "16:31"
                            )
            ]
        return [ParamsActivitiesTable(date:"Вчера", cell: activity1),
                ParamsActivitiesTable(date: "Май 2022 года", cell: activity2)
        ]
    }()
    
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var listActivities: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listActivities.isHidden = true
        self.title = "Активности"
        
        listActivities.dataSource = self
        listActivities.delegate = self
        
        listActivities.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityTableViewCell")
    }
    
    @IBAction func clickStart(_ sender: Any) {
        if emptyStateView.isHidden {
            let controller = MapController(nibName: "MapController", bundle: nil)
            navigationController?.pushViewController(controller, animated: true)
            return
        }
        emptyStateView.isHidden = true
        listActivities.isHidden = false
    }
    
}

extension ActivitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsView = ActivityDetailsViewController(nibName: "ActivityDetailsViewController", bundle: nil)
        detailsView.params = self.data[indexPath.section].cell[indexPath.row]
        navigationController?.pushViewController(detailsView, animated: true)
    }
}

extension ActivitiesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UILabel()
        header.font = .boldSystemFont(ofSize: 22)
        header.text = self.data[section].date
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].cell.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityData = self.data[indexPath.section].cell[indexPath.row]
        let reusableCell = self.listActivities.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath)
        guard let cell = reusableCell as? ActivityTableViewCell else {
            return UITableViewCell()
        }
        cell.bind(activityData)
        return cell
    }
    
}
