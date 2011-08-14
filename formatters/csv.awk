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
      print (sprintf("%s, \"%.2fh\", %s", escape(trim(project)), hours, escape(trim(task)) ))

      last_project = project
    }
  }
} 

function ltrim(s)  { sub(/^[ \t]+/, "", s); return s }
function rtrim(s)  { sub(/[ \t]+$/, "", s); return s }
function trim(s)   { return rtrim(ltrim(s)); }
function escape(s) { gsub(/"/, "\"\"", s); return ("\"" s "\"") }
