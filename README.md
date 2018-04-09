```
let tableView = UITableView(frame: .zero, style: .plain)
// 拆分刷新
let refresh = ZFListViewRefreshNormal(tableView)
// 拆分网络加载
let client = ZFHomeClient()

listView = ZFListView(frame: .zero, refresh: refresh, client: client)

// 配置刷新
listView.configure(topRefreshEnabled: true)
listView.configure(moreRefreshEnabled: true)

// 配置UI
listView.tableView.delegate = dataSource
listView.tableView.dataSource = dataSource
listView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

listView.listChangedHandler = {
[weak self] (items) in
guard let `self` = self else { return }
self.dataSource.configure(list: items)
self.listView.tableView.reloadData()
}
dataSource.heightForRowHandler = {
[weak self] (tableView, indexPath) in
guard let _ = self else { return 0 }
return 44
}
dataSource.cellForRowHandler = {
(tableView, indexPath, data) in
let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
cell.textLabel?.text = data
return cell
}
dataSource.didSelectRowHandler = {
(tableView, indexPath, data) in
debugPrint("did select \(data ?? "data")")
}

```
