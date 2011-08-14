BEGIN { FS="|"; }
{ 
  duration = $1;
  description = $2;

  split(description, desc, "@")
  project = desc[2]
  task    = desc[1]
  
  split(duration, m, " ");
  minutes = length(m) == 2 ? m[1] : m[1]*60 + m[3]

  timelogs[project, task] = timelogs[project, task] + minutes
  projects[project] = project
}
END {
  last_project = ""

  n = asort(projects)
  for (i = 1; i <= n; i++) {
    for (timelog in timelogs) {
      split(timelog, separate, SUBSEP)
      project = separate[1]
      task    = separate[2]
    
      if (projects[i] != project) continue;

      minutes = timelogs[timelog]
      total_minutes += minutes

      hours = minutes / 60
      if (project != last_project) {
        print ""
        print project
      }
      print (sprintf("%.2fh | %s", hours, task ))

      last_project = project
    }
  }


  print ""
  print (sprintf("Total: %.2fh", total_minutes / 60))
} 

function print_r(arr) {
  for (key in arr) {
    print (sprintf("%s: %s", key, arr[key]))
  }
}
