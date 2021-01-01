## Verbose Disco

Get your person Github access token from "Settings -> Developer settings -> Personal access tokens".

Run the following script to fetch the tickets

```sh
export TOKEN={YOUR_TOKEN}
ruby get.rb
```

Render

* Update script.js to `fetch("./issues.json")`
* Init a local server by `ruby -run -e httpd . -p 5000`
* Visit localhost:5000

Ref

* [GitHub GraphQL API](https://developer.github.com/v4/explorer/)
* [Gantt Chart - Google Charts](https://developers.google.com/chart/interactive/docs/gallery/ganttchart)


