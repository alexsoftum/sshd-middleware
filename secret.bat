for /f "delims== tokens=1,2" %%G in (.env) do set %%G=%%H

kubectl create secret docker-registry gitlab-creditails --docker-server=server.gitlab.com --docker-username=%GITLAB_USER% --docker-password=%GITLAB_TOKEN% --docker-email=%GITLAB_EMAIL% --namespace=postal-production
