fetch("https://raw.githubusercontent.com/ifyouseewendy/verbose-disco/8211128fc38bfadc158c8b336167b30289c6c5f8/issues.json")
  .then(response => response.json())
  .then(function(issues) {
    var tasks = [];
    issues.forEach(function(issue) {
      tasks.push({
        id: issue.title,
        name: issue.title,
        start: issue.start_date.join("-"),
        end: issue.end_date.join("-"),
        progress: 100,
        dependencies: null,
        url: issue.url
      });
    });
    var gantt = new Gantt("#gantt", tasks, {
      custom_popup_html: function(task) {
        // the task object will contain the updated
        // dates and progress value
        return `
          <div class="title">${task.name}</div>
          <div class="subtitle">
            <p>${task.start} - ${task.end}</p>
            <p><a href="${task.url}" target="_blank">Detail</a></p>
          </div>
        `;
      }
    });
    gantt.change_view_mode('Month');
  })
