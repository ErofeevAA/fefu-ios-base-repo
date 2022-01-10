import UIKit
import CoreData

struct ParamsActivitiesTable {
    let date: Date
    let cell: [ParamsTableCell]
}

class ActivitiesViewController: UIViewController {
    
    var data = [ParamsActivitiesTable]()
    
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var listActivities: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listActivities.isHidden = true
        self.title = "Активности"
        
        listActivities.dataSource = self
        listActivities.delegate = self
        
        listActivities.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityTableViewCell")
        
        loadData()
        listActivities.reloadData()
    }
    
    func loadData() {
        let context = FEFUCoreDataContainer.instance.context

        let activityRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        
        do {
            let rawActivities = try context.fetch(activityRequest)

            let activitiesViewParams: [ParamsTableCell] = rawActivities.map { rawActivity in

                let image = UIImage(systemName: "bicycle.circle.fill") ?? UIImage()

                return ParamsTableCell(
                    distance: rawActivity.distance,
                    duration: rawActivity.duration,
                    date: rawActivity.date ?? Foundation.Date(),
                    icon: image,
                    type: rawActivity.type ?? "",
                    startTime: rawActivity.startTime ?? "",
                    endTime: rawActivity.endTime ?? ""
                )
            }
            let groupedActivitiesByDate = Dictionary(grouping: activitiesViewParams) { param in
                return createDate(param.date)
            }

            self.data = groupedActivitiesByDate.map { (date, cells) in
                return ParamsActivitiesTable(
                    date: date,
                    cell: cells
                )
            }

            emptyStateView.isHidden = !data.isEmpty
            listActivities.isHidden = data.isEmpty
        } catch {
            print(error)
        }
    }
    
    private func createDate(_ date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components) ?? Date()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listActivities.reloadData()
    }
    
    @IBAction func clickStart(_ sender: Any) {
        let controller = MapController(nibName: "MapController", bundle: nil)
        navigationController?.pushViewController(controller, animated: true)
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        
        header.text = dateFormatter.string(from: self.data[section].date)
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
