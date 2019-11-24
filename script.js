google.charts.load('current', { 'packages': ['gantt'] });
google.charts.setOnLoadCallback(drawChart);

function drawChart() {
  var options = {
    height: 1000,
    gantt: {
        trackHeight: 30
    }
  };

  var chart = new google.visualization.Gantt(document.getElementById('chart_div'));

  var data = new google.visualization.DataTable();
  data.addColumn('string', 'Task ID');
  data.addColumn('string', 'Task Name');
  data.addColumn('string', 'Issue');
  data.addColumn('date', 'Start Date');
  data.addColumn('date', 'End Date');
  data.addColumn('number', 'Duration');
  data.addColumn('number', 'Percent Complete');
  data.addColumn('string', 'Dependencies');

  fetch("https://raw.githubusercontent.com/ifyouseewendy/verbose-disco/master/issues.json")
    .then(response => response.json())
    .then(function(issues) {
        issues.forEach(
          issue => data.addRow([
              issue.title,
              issue.title,
              issue.url,
              new Date(issue.start_date[0], issue.start_date[1] - 1, issue.start_date[2]),
              new Date(issue.end_date[0], issue.end_date[1] - 1, 30),
              null,
              100,
              null
          ])
        )
        chart.draw(data, options);
    })
}
